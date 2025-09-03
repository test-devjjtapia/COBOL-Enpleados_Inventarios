# Sistema de Gestión de Empleados e Inventario
Este repositorio contiene dos sistemas desarrollados en COBOL para la gestión de empleados y control de inventario.

📁 Estructura del Proyecto
```
Estructura
├── empleados.cob          # Sistema de registro de empleados
├── inventario.cob         # Sistema de gestión de inventario
├── empleados.dat          # Archivo de datos de empleados (generado)
├── productos.dat          # Archivo de datos de productos (generado)
├── movimientos.dat        # Archivo de movimientos de inventario (generado)
└── reporte_inventario.txt # Reportes de inventario (generado)
```

## 🏢 Sistema de Registro de Empleados (empleados.cob)
### Funcionalidades
+ Registro de nuevos empleados con ID, nombre, departamento y salario
+ Validación de entrada de datos
+ Cálculo automático de estadísticas (total de salarios, promedio)
+ Almacenamiento en archivo secuencial

### Estructura de datos
REGISTRO-EMPLEADO:
  - ID (5 dígitos)
  - Nombre (30 caracteres)
  - Departamento (20 caracteres)
  - Salario (formato 9(7)V99)

### Uso
El programa solicita interactivamente los datos de cada empleado. Para finalizar la entrada, ingrese el ID 99999.

## 📦 Sistema de Gestión de Inventario (inventario.cob)
### Funcionalidades Principales
  - Menú interactivo con 8 opciones:
  - Registrar nuevo producto
  - Registrar entrada de stock
  - Registrar salida de stock
  - Consultar producto
  - Listar productos bajo stock mínimo
  - Generar reporte de inventario
  - Ver movimientos del día
  - Salir del sistema
### Gestión completa de productos con:
  - Registro indexado por ID y nombre
  - Control de stock y stock mínimo
  - Seguimiento de proveedores y últimas compras
### Sistema de movimientos que registra:
  - Entradas y salidas de inventario
  - Fechas de transacciones
  - Precios unitarios
### Reportes automáticos con:
  - Valor total del inventario
  - Productos con stock bajo
  - Movimientos diarios
### Estructuras de Datos
  - ID (6 dígitos)
  - Nombre (30 caracteres)
  - Categoría (20 caracteres)
  - Precio (formato 9(7)V99)
  - Stock actual y mínimo (5 dígitos)
  - Proveedor (30 caracteres)
  - Última fecha de compra (10 caracteres)
### Movimiento:
  - Fecha (10 caracteres)
  - Tipo (E/S para Entrada/Salida)
  - ID de producto (6 dígitos)
  - Cantidad (5 dígitos)
  - Precio unitario (formato 9(7)V99)
## 🚀 Compilación y Ejecución
### Requisitos
  - Compilador COBOL (GnuCOBOL recomendado)
  - Sistema operativo compatible
### Compilación
# Compilar sistema de empleados
```
cobc -x empleados.cob
```
# Compilar sistema de inventario
```
cobc -x inventario.cob
```
### Ejecución
# Ejecutar sistema de empleados
```
./empleados
```
# Ejecutar sistema de inventario
```
./inventario
```
## 📊 Características Técnicas
  - Manejo de archivos: Organización secuencial e indexada
  - Validación de datos: Verificación de existencia de registros
  - Manejo de errores: Control de estados de archivo
  - Interfaz de usuario: Menús interactivos con formato
  - Reportes: Generación de documentos formateado
## 📝 Notas
  - Los archivos de datos se crean automáticamente al ejecutar los programas por primera vez
  - El sistema de inventario utiliza organización indexada para búsquedas eficientes
  - Ambos sistemas incluyen validaciones para evitar errores de entrada de datos
