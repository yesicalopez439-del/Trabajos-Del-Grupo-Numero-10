# Archivo: tarea.py
# Profe, ¡este es mi proyecto! Tuve que buscar mucha ayuda para que funcionara la base de datos.
# Esto es Python, que es lo que conecta todo con PostgreSQL (el servidor de la base de datos).

import psycopg2
from psycopg2 import Error 

# --- 1. CONFIGURACIÓN DE CONEXIÓN (¡Esto es delicado!) ---
DATOS_CONEXION = {
    "host": "localhost",
    "database": "script_vista_sql", # El nombre de la DB que creamos
    "user": "postgres",
    "password": "postgres",         # <--- ¡REVISAR! Si tiene tildes, falla (lo aprendí a la mala)
    "port": "5432"
}

# --- 2. CONSULTAS DISPONIBLES (El Menú para los Informes) ---
CONSULTAS_DISPONIBLES = {
    1: {
        "nombre": "Total Graduados por IES y Programa",
        "sql": """
            SELECT nombre_ies, nombre_programa, SUM(cantidad_graduados) AS total 
            FROM VISTA_GRADUADOS_DETALLADOS 
            GROUP BY 1, 2 
            ORDER BY total DESC;
        """
    },
    2: {
        "nombre": "Distribución por Departamento y Metodología",
        "sql": """
            SELECT nombre_departamento, nombre_metodologia, SUM(cantidad_graduados) AS total 
            FROM VISTA_GRADUADOS_DETALLADOS 
            GROUP BY 1, 2 
            ORDER BY total DESC;
        """
    },
    3: {
        "nombre": "Total Graduados por Área de Conocimiento",
        "sql": """
            SELECT nombre_area_conocimiento, SUM(cantidad_graduados) AS total 
            FROM VISTA_GRADUADOS_DETALLADOS 
            GROUP BY 1 
            ORDER BY total DESC;
        """
    },
    4: {
        "nombre": "Filtro por Año de Graduación" 
    },
    6: {
        "nombre": "¡Gracias por ver mi proyecto!" # El mensaje especial es la opción 6
    }
}
OPCION_SALIR = 5 
OPCION_MENSAJE = 6


# --- 3. FUNCIONES DE EJECUCIÓN Y FORMATO (¡ESTAS SON LAS QUE FALTABAN ARRIBA!) ---

def _formatear_resultados(columnas, resultados, nombre_informe):
    """
    Función auxiliar para que la tabla se vea bonita en la terminal.
    Esto calcula el espacio exacto que necesita cada columna para que no se vea desordenado.
    """
    if not resultados:
        print(f"No se encontraron resultados para el informe: {nombre_informe}.")
        return

    print(f"\n--- RESULTADOS: {nombre_informe} ---")
    
    col_widths = [len(col) for col in columnas]
    for fila in resultados:
        for i, item in enumerate(fila):
            col_widths[i] = max(col_widths[i], len(str(item)) + 2) 

    header = "| " + " | ".join(f"{col:<{col_widths[i]}}" for i, col in enumerate(columnas)) + " |"
    separator = "-" * len(header)
    
    print(separator)
    print(header)
    print(separator)

    for fila in resultados:
        format_list = [f"{str(item):<{col_widths[i]}}" for i, item in enumerate(fila[:-1])]
        format_list.append(f"{str(fila[-1]):>{col_widths[-1]}}") 
        
        fila_formateada = "| " + " | ".join(format_list) + " |"
        print(fila_formateada)
    print(separator)


def ejecutar_consulta(consulta_sql, nombre_informe, parametros=None):
    """
    Esta función es el motor. Intenta conectar y ejecutar el SQL.
    Si parametros NO es None, usa la función de seguridad de psycopg2.
    """
    conexion = None
    
    try:
        print("\nIntentando conectar a la base de datos...")
        conexion = psycopg2.connect(**DATOS_CONEXION)
        cursor = conexion.cursor()
        print(f"Conexión exitosa. Ejecutando informe: {nombre_informe}")
        
        # ¡La parte clave! Si hay 'parametros' (como el año), se los paso aquí.
        cursor.execute(consulta_sql, parametros) 
        
        columnas = [desc[0] for desc in cursor.description]
        resultados = cursor.fetchall()
        
        _formatear_resultados(columnas, resultados, nombre_informe)
            
    except (Exception, Error) as error:
        print(f"\n--- ERROR DE CONEXIÓN/EJECUCIÓN (¡Ups!) ---")
        print(f"Ocurrió un error al ejecutar el informe: {error}")
        
    finally:
        if conexion:
            cursor.close()
            conexion.close()
            print("Conexión a PostgreSQL cerrada.")


def _manejar_filtro_anio():
    """
    Función para la Opción 4: Le pregunta al usuario el año y luego llama a la función de ejecución.
    """
    anio_str = input(">> Ingrese el año de graduación (ej: 2023): ")
    try:
        anio = int(anio_str) # Intento convertirlo a número entero
        
        # Aquí escribo el SQL. Uso %s para el lugar donde irá el año.
        consulta_sql = """
            SELECT 
                nombre_ies, 
                nombre_programa, 
                SUM(cantidad_graduados) AS total 
            FROM 
                VISTA_GRADUADOS_DETALLADOS 
            WHERE 
                anio_graduacion = %s 
            GROUP BY 
                1, 2 
            ORDER BY 
                total DESC;
        """
        nombre_informe = f"Graduados por IES y Programa (Año {anio})"
        
        # Ejecuto la consulta. La variable 'anio' va en los 'parametros'. ¡Esto evita la inyección SQL!
        ejecutar_consulta(consulta_sql, nombre_informe, parametros=(anio,))
        
    except ValueError:
        print("\n❌ Año no válido. ¡Solo se aceptan números enteros!")


# --- 4. FUNCIÓN DEL MENÚ PRINCIPAL (El programa empieza aquí) ---
def mostrar_menu():
    """Muestra el menú y gestiona la interacción del usuario."""
    while True:
        print("\n" + "="*50)
        print("📊 MENÚ DE INFORMES DE GRADUADOS (¡Mi proyecto!)")
        print("="*50)
        
        # Imprime las opciones en orden forzado (1, 2, 3, 4)
        for i in range(1, 5):
            print(f"{i}. {CONSULTAS_DISPONIBLES[i]['nombre']}")

        # Imprime la opción especial de Salir (5)
        print(f"{OPCION_SALIR}. Salir del programa")
        
        # Imprime la opción especial de Mensaje (6)
        print(f"{OPCION_MENSAJE}. {CONSULTAS_DISPONIBLES[OPCION_MENSAJE]['nombre']}")

        print("-" * 50)
        
        try:
            eleccion = input("Ingrese el número del informe que desea ejecutar: ")
            eleccion = int(eleccion)
            
            if eleccion == OPCION_SALIR:
                # Mensaje de despedida final
                print("\n" + "*"*60)
                print("🌟 ¡GRACIAS POR VER MI PROYECTO! 🌟".center(60))
                print("Trabajo realizado por: YESICA ALEJANDRA BEDOYA".center(60))
                print("Fue algo complicado, ¡pero nunca imposible!".center(60))
                print("*"*60)
                break
            
            # Lógica para ejecutar consultas (1, 2, 3)
            elif eleccion in [1, 2, 3]:
                datos = CONSULTAS_DISPONIBLES[eleccion]
                ejecutar_consulta(datos["sql"], datos["nombre"])
            
            # Lógica para ejecutar filtro dinámico (4)
            elif eleccion == 4: 
                _manejar_filtro_anio()

            # Lógica para mostrar el mensaje de agradecimiento (6)
            elif eleccion == OPCION_MENSAJE:
                print("\n" + "="*50)
                print("¡GRACIAS POR REVISAR! 😊".center(50))
                print("Este proyecto fue un gran reto. Demuestra que la programación, aunque es difícil, es increíble cuando funciona.".center(50))
                print("="*50)
            
            else:
                print("\n❌ Opción no válida. ¡Tengo que practicar más los números!")

        except ValueError:
            print("\n❌ Entrada no válida. Por favor, ingrese solo un número.")
        except KeyboardInterrupt:
            print("\n\nSaliendo del programa por interrupción del teclado.")
            break

# --- 5. EJECUCIÓN DEL SCRIPT ---
# Aquí es donde aparece el nombre al inicio de la ejecución.
print("\n" + "="*60)
print("¡Bienvenido al Gestor de Informes Académicos!".center(60))
print("Trabajo realizado por: YESICA ALEJANDRA BEDOYA".center(60))
print("="*60)
if __name__ == "__main__":
    mostrar_menu()