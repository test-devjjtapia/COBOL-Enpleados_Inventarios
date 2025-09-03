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
