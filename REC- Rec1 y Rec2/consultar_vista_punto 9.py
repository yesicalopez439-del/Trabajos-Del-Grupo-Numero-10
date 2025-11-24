# Mi Proyecto de Informes de Ventas
# Autora: Yesica Alejandra Bedoya 
# Fecha: 24 de Noviembre de 2025
# Profe, ¡este código es el que usa la vista que creamos en PostgreSQL!
# Lo hice con mucho cuidado para que se vea bonito y se entienda.
# PARTE 1: LAS HERRAMIENTAS QUE NECESITO (IMPORTACIONES)

import psycopg2 # Este es para hablar con la base de datos PostgreSQL. ¡Es el traductor!
import sys      # Este es para poder salir del programa si algo sale mal (como si se cae la conexión).
import locale   # Este es CLAVE: Lo uso para poner los números con formato COP ($ 1.234.567) 

# PARTE 2: CONFIGURACIÓN Y CONEXIÓN A LA BASE DE DATOS
# Esto es para que el programa sepa dónde está la plata (los datos).
# Configuración de localización (para el formato de dinero colombiano - COP)
try:
    # Intento configurar el idioma de Colombia. ¡Es difícil que funcione en todos los PCs!
    locale.setlocale(locale.LC_ALL, 'es_CO.utf8') 
except locale.Error:
    try:
        # Si la primera falla, intento esta otra configuración que es más común en Windows.
        locale.setlocale(locale.LC_ALL, 'Spanish_Colombia.1252') 
    except locale.Error:
        # Si ambas fallan, al menos aviso y sigo sin el formato COP perfecto.
        print("¡OJO! Advertencia: No se pudo configurar bien el formato COP. Los números saldrán simples.")

# Mis datos de conexión a PostgreSQL (¡no decirle a nadie mi contraseña!)
DB_NAME = "DATOS_COMERCIALES"
DB_USER = "postgres"
DB_PASS = "postgres"  # <<<< ¡Profe, aquí va mi contraseña de PostgreSQL!
DB_HOST = "localhost"
DB_PORT = "5432"

conn = None # Declaro esta variable global. Es como el 'puente' al que me voy a conectar.

def conectar_db():
    """
    Profe, esta función intenta abrir el puente para hablar con la base de datos.
    Si el puente se abre bien, ¡sigo! Si no, el programa se cierra con sys.exit(1).
    """
    global conn
    try:
        conn = psycopg2.connect(
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASS,
            host=DB_HOST,
            port=DB_PORT
        )
        print("¡Conexión a la base de datos exitosa! Estamos listos para trabajar.")
        return True
    except psycopg2.Error as e:
        print(f"¡AYUDA! Error al intentar conectar con la base de datos: {e}")
        sys.exit(1)

# PARTE 3: LA FUNCIÓN MÁGICA PARA IMPRIMIR TABLAS

def ejecutar_consulta(query, titulo):
    """
    Profe, esta es la función más importante.
    - Recibe el SQL (query) y el título del informe.
    - Ejecuta el SQL, saca los datos y los imprime bien bonitos en forma de tabla.
    - Y lo más chévere: ¡Convierte los números de plata a formato COP!
    """
    if not conn:
        print("¡Error! La conexión se perdió. ¿Será que el servidor de la base de datos se apagó?")
        return

    try:
        cursor = conn.cursor() # El cursor es el que 'mueve' las cosas dentro de la base de datos.
        cursor.execute(query)  # Le digo al cursor: "¡Ejecuta este SQL!"
        
        columnas = [desc[0].upper() for desc in cursor.description] # Guardo los nombres de las columnas.
        resultados = cursor.fetchall()                             # Guardo todos los datos que me devuelve el SQL.

        # Esto es un truco para saber cuáles columnas tienen dinero y cuáles no.
        # Busco las palabras 'MONTO', 'GASTO', 'PRECIO', o 'TOTAL'.
        indices_dinero = [i for i, col in enumerate(columnas) if 'MONTO' in col or 'GASTO' in col or 'PRECIO' in col or 'TOTAL' in col]

        # ------------------- IMPRESIÓN BONITA -------------------
        print(f"\n{'='*90}")
        print(f"   INFORME: {titulo}")
        print(f"{'='*90}")
        print(f"Total de registros encontrados: {len(resultados)}") # Muestro cuántas filas encontré.
        
        if not resultados:
            print("No se encontraron datos. ¡Tal vez la base de datos está vacía!")
            return

        # 1. Calcular el ancho de cada columna para que no quede torcido
        anchos = [len(col) for col in columnas]
        for fila in resultados:
            for i, valor in enumerate(fila):
                # Uso locale.currency para darle el formato COP a la plata
                valor_str = locale.currency(valor, symbol=True, grouping=True) if i in indices_dinero else str(valor)
                if len(valor_str) > anchos[i]:
                    anchos[i] = len(valor_str)

        anchos = [a + 2 for a in anchos] # Le doy 2 espacios de margen a cada lado.

        # 2. Imprimir Encabezados
        print("-" * 90)
        fila_encabezado = "".join(col.ljust(anchos[i]) for i, col in enumerate(columnas))
        print(fila_encabezado)
        print("-" * 90)

        # 3. Imprimir Datos (¡Aquí aplico el formato COP de verdad!)
        for fila in resultados:
            fila_str = ""
            for i, valor in enumerate(fila):
                if i in indices_dinero:
                    valor_str = locale.currency(valor, symbol=True, grouping=True) # Lo convierto a $ 1.234.567,00
                else:
                    valor_str = str(valor)
                
                fila_str += valor_str.ljust(anchos[i])
            print(fila_str)
        
        print("="*90)

    except psycopg2.Error as e:
        print(f"¡Problemas con el SQL! Error al ejecutar la consulta '{titulo}': {e}")
    finally:
        if 'cursor' in locals() and cursor:
            cursor.close() # Cierro el cursor para no dejar la base de datos abierta.


# PARTE 4: MIS 5 INFORMES DE NEGOCIO 


def informe_ventas_por_vendedor():
    """Informe 1: ¿Quién es el mejor vendiendo?"""
    query = """
    SELECT 
        vendedor_asignado,
        sucursal_origen,
        COUNT(DISTINCT id_pedido) AS total_pedidos,
        SUM(total_linea) AS monto_total_vendido  -- Calculo la plata total que vendió
    FROM 
        vista_detalle_ventas_completo
    GROUP BY 
        vendedor_asignado, sucursal_origen
    ORDER BY 
        monto_total_vendido DESC;
    """
    ejecutar_consulta(query, "Total de Ventas por Vendedor y Sucursal")


def informe_productos_mas_vendidos():
    """Informe 2: Top 15 productos más vendidos. ¡Puse LIMIT 15 para que no sea tan largo!"""
    query = """
    SELECT 
        categoria_producto,
        producto,
        SUM(cantidad_vendida) AS unidades_vendidas
    FROM 
        vista_detalle_ventas_completo
    GROUP BY 
        categoria_producto, producto
    ORDER BY 
        unidades_vendidas DESC
    LIMIT 15;  -- Esto hace que solo me muestre los 15 primeros.
    """
    ejecutar_consulta(query, "Top 15 Productos Más Vendidos por Categoría")


def informe_clientes_premium():
    """Informe 3: Top 15 clientes que más nos compran. ¡Son los VIP!"""
    query = """
    SELECT 
        cliente,
        SUM(total_linea) AS gasto_total
    FROM 
        vista_detalle_ventas_completo
    GROUP BY 
        cliente
    ORDER BY 
        gasto_total DESC
    LIMIT 15; -- También pongo LIMIT 15 aquí.
    """
    ejecutar_consulta(query, "Top 15 Clientes con Mayor Gasto")


def informe_ventas_por_dia():
    """Informe 4: ¿Qué días vendimos más? Agrupo por fecha."""
    query = """
    SELECT 
        fecha_venta,
        COUNT(DISTINCT id_pedido) AS total_pedidos,
        SUM(total_linea) AS monto_total_diario
    FROM 
        vista_detalle_ventas_completo
    GROUP BY 
        fecha_venta
    ORDER BY 
        fecha_venta DESC
    LIMIT 15; -- Los últimos 15 días con ventas.
    """
    ejecutar_consulta(query, "Ventas Totales Agrupadas por Día")


def informe_detalle_completo():
    """Informe 5: El detalle de cada venta. Ordeno por fecha para ver las últimas."""
    query = """
    SELECT 
        cliente,
        producto,
        cantidad_vendida,
        precio_unitario,
        total_linea,
        vendedor_asignado,
        sucursal_origen,
        fecha_venta
    FROM 
        vista_detalle_ventas_completo
    ORDER BY 
        fecha_venta DESC, id_pedido DESC -- Ordeno por fecha y luego por ID del pedido.
    LIMIT 15; -- Solo me interesa ver las últimas 15.
    """
    ejecutar_consulta(query, "Detalle COMPLETO de las Últimas 15 Transacciones")


# PARTE 5: EL MENÚ Y EL PROGRAMA PRINCIPAL

def mostrar_menu():
    """
    Profe, este solo imprime las opciones del menú.
    Lo hice con esas líneas raras (╔═, ║) para que se vea más profesional.
    """
    
    print("\n" + "╔══════════════════════════════════════════════════════════════════════════╗")
    print("║      📊 MENÚ DE INFORMES COMERCIALES (Mi Proyecto) 📈                      ║")
    print("║                                                                          ║")
    print("║  Trabajo realizado por: YESICA ALEJANDRA BEDOYA                          ║")
    print("╚══════════════════════════════════════════════════════════════════════════╝")
    
    print("1. Total de Ventas por Vendedor y Sucursal")
    print("2. Top 15 Productos Más Vendidos por Categoría")
    print("3. Top 15 Clientes con Mayor Gasto")
    print("4. Ventas Totales Agrupadas por Día")
    print("5. Detalle COMPLETO de Transacciones (Muestra las últimas 15)")
    print("6. Salir del programa")
    
    print("="*60) # Pongo una línea de separación


def main():
    """
    Profe, esta es la función que lo pone todo a funcionar (la función 'main').
    Es como el motor principal del programa.
    """
    global conn
    if not conectar_db():
        return # Si la conexión falla, me voy.
    
    while True: # Esto es un 'loop infinito'. Se repite hasta que elija la opción 6.
        mostrar_menu()
        opcion = input("Ingrese el número del informe que desea ejecutar: ").strip()

        if opcion == '1':
            informe_ventas_por_vendedor()
        elif opcion == '2':
            informe_productos_mas_vendidos()
        elif opcion == '3':
            informe_clientes_premium()
        elif opcion == '4':
            informe_ventas_por_dia()
        elif opcion == '5':
            informe_detalle_completo()
        elif opcion == '6':
            print("\n---------------------------------------------------------")
            print("¡Gracias por el apoyo, Profe! Este proyecto lo hice pensando en aprender. 👋")
            print("---------------------------------------------------------")
            break # Rompo el 'loop' y salgo del programa.
        else:
            print("\n¡Oops! Opción no válida. Por favor, ingrese un número del 1 al 6.")


# Esto es para que el programa sepa que debe empezar a correr aquí.
if __name__ == '__main__':
    try:
        main()
    finally:
        if conn:
            conn.close() 
            print("¡Ya terminé! Conexión a PostgreSQL cerrada.") # Cierro la conexión al finalizar.