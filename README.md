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
