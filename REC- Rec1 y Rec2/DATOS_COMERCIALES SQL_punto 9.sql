
-- # BLOQUE 1: ESTRUCTURA COMPLETA (CREACIÓN DE TABLAS Y VIEW)
-- # Objetivo: Crear la arquitectura de la base de datos y la vista principal.
-- 1. LIMPIEZA
DROP VIEW IF EXISTS vista_detalle_ventas_completo;
DROP TABLE IF EXISTS detalle_pedido CASCADE;
DROP TABLE IF EXISTS pedidos CASCADE;
DROP TABLE IF EXISTS empleados CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;
DROP TABLE IF EXISTS sucursales CASCADE;

-- 2. CREACIÓN DE TABLAS BASE
CREATE TABLE categorias (
    categoria_id SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE sucursales (
    sucursal_id SERIAL PRIMARY KEY,
    ciudad_sucursal VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL UNIQUE
);

-- 3. CREACIÓN DE TABLAS CON CLAVES FORÁNEAS
CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL UNIQUE,
    precio NUMERIC(10, 2) NOT NULL,
    categoria_id INTEGER REFERENCES categorias(categoria_id)
);

CREATE TABLE empleados (
    empleado_id SERIAL PRIMARY KEY,
    nombre_empleado VARCHAR(100) NOT NULL UNIQUE,
    sucursal_id INTEGER REFERENCES sucursales(sucursal_id)
);

CREATE TABLE pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INTEGER REFERENCES clientes(cliente_id),
    empleado_id INTEGER REFERENCES empleados(empleado_id),
    fecha_pedido DATE NOT NULL
);

CREATE TABLE detalle_pedido (
    detalle_id SERIAL PRIMARY KEY,
    pedido_id INTEGER REFERENCES pedidos(pedido_id),
    producto_id INTEGER REFERENCES productos(producto_id),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    UNIQUE (pedido_id, producto_id) -- Clave única compuesta para evitar duplicados en el detalle
);

-- 4. CREACIÓN DE LA VIEW
CREATE OR REPLACE VIEW vista_detalle_ventas_completo AS
SELECT
    c.nombre_cliente AS cliente, p.nombre_producto AS producto, cat.nombre_categoria AS categoria_producto, 
    d.cantidad AS cantidad_vendida, p.precio AS precio_unitario, (d.cantidad * p.precio) AS total_linea, 
    e.nombre_empleado AS vendedor_asignado, s.ciudad_sucursal AS sucursal_origen, 
    r.pedido_id AS id_pedido, r.fecha_pedido AS fecha_venta
FROM clientes c
JOIN pedidos r ON c.cliente_id = r.cliente_id
JOIN detalle_pedido d ON r.pedido_id = d.pedido_id
JOIN productos p ON d.producto_id = p.producto_id
JOIN categorias cat ON p.categoria_id = cat.categoria_id
JOIN empleados e ON r.empleado_id = e.empleado_id
JOIN sucursales s ON e.sucursal_id = s.sucursal_id;
-- # BLOQUE 2: INSERCIÓN DE DATOS INICIALES Y REFERENCIA
-- # Objetivo: Llenar las tablas maestras antes de las transacciones.


-- REFERENCIAS FIJAS
INSERT INTO sucursales (ciudad_sucursal) VALUES ('Medellín'), ('Bogotá'), ('Barranquilla'), ('Bucaramanga') ON CONFLICT (ciudad_sucursal) DO NOTHING;
INSERT INTO categorias (nombre_categoria) VALUES ('Electrónica'), ('Ropa'), ('Alimentos'), ('Mobiliario'), ('Hogar y Jardín'), ('Juguetes'), ('Salud y Belleza'), ('Deportes'), ('Libros'), ('Herramientas') ON CONFLICT (nombre_categoria) DO NOTHING;

-- CLIENTES
INSERT INTO clientes (nombre_cliente) VALUES ('Ana López'), ('Carlos Pérez'), ('Elena Torres'), ('Fernando Giraldo'), ('Isabel Valencia'), ('Ricardo Mendoza'), ('Laura Pérez'), ('Miguel Rojas'), ('Andrea Soto'), ('Daniel Hoyos'), ('Valeria Rivas'), ('Felipe Velez'), ('Gabriela Muñoz'), ('Héctor Díaz'), ('Juana Restrepo'), ('Kevin Londoño'), ('Manuela Toro'), ('Nicolás Caro'), ('Octavio Zuluaga'), ('Paola Quintero'), ('Roberto Gómez'), ('Silvia Pardo'), ('Iván Duque'), ('Luisa Fernanda'), ('Camilo Echeverri'), ('Valentina Giraldo'), ('Humberto Sierra') ON CONFLICT (nombre_cliente) DO NOTHING;

-- EMPLEADOS
INSERT INTO empleados (nombre_empleado, sucursal_id) VALUES ('Luis Gomez', 1), ('Marta Ruiz', 2), ('Sofía Ramírez', 3), ('Javier Ortiz', 4), ('Diana Castro', 1), ('Oscar Ruiz', 2), ('Lina Márquez', 3), ('Mario Torres', 4), ('Pedro Sánchez', 1) ON CONFLICT (nombre_empleado) DO NOTHING;

-- PRODUCTOS
INSERT INTO productos (nombre_producto, precio, categoria_id) VALUES ('Laptop', 3500000.00, 1), ('Camisa', 120000.00, 2), ('Pan Integral', 5500.00, 3), ('Mesa de Oficina', 850000.00, 4), ('Silla de Jardín', 185000.00, 5), ('Set de Bloques', 75990.00, 6), ('Smart TV 55"', 4980500.00, 1), ('Crema Hidratante', 35000.00, 7), ('Kit Pesas 10kg', 180000.00, 8), ('Novela Clásica', 45000.00, 9), ('Taladro Percutor', 320000.00, 10),('Mouse Inalámbrico', 75000.00, 1), ('Jeans Slim Fit', 120000.00, 2), ('Aceite de Oliva L.', 48000.00, 3) ON CONFLICT (nombre_producto) DO NOTHING;
-- # BLOQUE 3: REINICIO DE SECUENCIAS (CORREGIDO)
-- # Objetivo: Asegurar que la secuencia de 'pedido_id' empiece en el valor correcto (>= 1).
SELECT setval('pedidos_pedido_id_seq', (SELECT COALESCE(MAX(pedido_id), 0) FROM pedidos) + 1, false);
-- # BLOQUE 4: INSERCIÓN MASIVA DE TRANSACCIONES (PL/PGSQL)
-- # Objetivo: Generar 30 pedidos aleatorios y sus detalles (Volumen de datos).
DO $$
DECLARE
    i INT;
    max_cliente_id INT;
    max_empleado_id INT;
    max_producto_id INT;
BEGIN
    -- Obtenemos los IDs máximos reales de las tablas pobladas
    SELECT MAX(cliente_id) INTO max_cliente_id FROM clientes;
    SELECT MAX(empleado_id) INTO max_empleado_id FROM empleados;
    SELECT MAX(producto_id) INTO max_producto_id FROM productos;

    -- Insertar 30 nuevos pedidos
    FOR i IN 1..30 LOOP
        INSERT INTO pedidos (cliente_id, empleado_id, fecha_pedido) VALUES 
        (
            floor(random() * (max_cliente_id) + 1)::int, -- Cliente aleatorio
            floor(random() * (max_empleado_id) + 1)::int, -- Empleado aleatorio
            '2025-11-23'::date - (floor(random() * 60)::int * interval '1 day') -- Fecha aleatoria de los últimos 60 días
        );
        -- Insertar 1 a 4 detalles por pedido (productos comprados)
        FOR j IN 1..floor(random() * 4) + 1 LOOP
            BEGIN
                INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad) VALUES 
                (
                    currval('pedidos_pedido_id_seq'), -- Uso el ID del pedido que acabo de crear
                    floor(random() * (max_producto_id) + 1)::int, -- Producto aleatorio
                    floor(random() * 5) + 1 -- Cantidad de 1 a 5 unidades
                );
            EXCEPTION WHEN unique_violation THEN
            END; -- Si el producto ya está en ese pedido, lo ignoro (DO NOTHING)
        END LOOP;
    END LOOP;
END $$;

-- Profe, esta vista se llama "vista_detalle_ventas_completo" y es mi "tabla virtual" de ventas.
-- La hice con 6 JOINs para no tener que repetir toda esta conexión en mi código Python.
-- Lo que hace es consolidar: Quién compra, qué producto, a qué precio, y qué vendedor lo atendió, con su sucursal.

CREATE OR REPLACE VIEW vista_detalle_ventas_completo AS
SELECT
    c.nombre_cliente AS cliente, 
    p.nombre_producto AS producto, 
    cat.nombre_categoria AS categoria_producto, 
    d.cantidad AS cantidad_vendida, 
    p.precio AS precio_unitario, 
    (d.cantidad * p.precio) AS total_linea, 
    e.nombre_empleado AS vendedor_asignado, 
    s.ciudad_sucursal AS sucursal_origen, 
    r.pedido_id AS id_pedido, 
    r.fecha_pedido AS fecha_venta
FROM clientes c
JOIN pedidos r ON c.cliente_id = r.cliente_id -- 1. Clientes y Pedidos
JOIN detalle_pedido d ON r.pedido_id = d.pedido_id -- 2. Pedidos y Detalles
JOIN productos p ON d.producto_id = p.producto_id -- 3. Detalles y Productos
JOIN categorias cat ON p.categoria_id = cat.categoria_id -- 4. Productos y Categorías
JOIN empleados e ON r.empleado_id = e.empleado_id -- 5. Pedidos y Empleados
JOIN sucursales s ON e.sucursal_id = s.sucursal_id; -- 6. Empleados y Sucursales (¡6 JOINs!)