       IDENTIFICATION DIVISION.
       PROGRAM-ID. REGISTRO-EMPLEADOS.
       AUTHOR. Javier J. Tapia.
       DATE-WRITTEN. 2025-08-14.
      
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT EMPLEADOS-ARCHIVO
           ASSIGN TO "empleados.dat"
           ORGANIZATION IS LINE SEQUENTIAL.
           
       DATA DIVISION.
       FILE SECTION.
       FD  EMPLEADOS-ARCHIVO.
       01  REGISTRO-EMPLEADO.
           05  EMP-ID              PIC 9(5).
           05  EMP-NOMBRE          PIC X(30).
           05  EMP-DEPARTAMENTO    PIC X(20).
           05  EMP-SALARIO         PIC 9(7)V99.
           
       WORKING-STORAGE SECTION.
       01  WS-VARIABLES.
           05  WS-FIN              PIC X VALUE 'N'.
           05  WS-CONTADOR         PIC 9(3) VALUE 0.
           05  WS-TOTAL-SALARIOS   PIC 9(9)V99 VALUE 0.
           05  WS-PROMEDIO         PIC 9(9)V99.
           
       01  WS-CABECERA.
           05  FILLER             PIC X(72) VALUE ALL '*'.
           
       01  WS-LINEA-DETALLE.
           05  FILLER             PIC X(2)  VALUE SPACES.
           05  WS-DET-ID          PIC 9(5).
           05  FILLER             PIC X(2)  VALUE SPACES.
           05  WS-DET-NOMBRE      PIC X(30).
           05  FILLER             PIC X(2)  VALUE SPACES.
           05  WS-DET-DEPTO       PIC X(20).
           05  FILLER             PIC X(2)  VALUE SPACES.
           05  WS-DET-SALARIO     PIC $ZZZ,ZZ9.99.
           
       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM 100-INICIO
           PERFORM 200-PROCESO UNTIL WS-FIN = 'S'
           PERFORM 300-FINAL
           STOP RUN.
           
       100-INICIO.
           OPEN OUTPUT EMPLEADOS-ARCHIVO
           DISPLAY WS-CABECERA
           DISPLAY "SISTEMA DE REGISTRO DE EMPLEADOS"
           DISPLAY WS-CABECERA.
           
       200-PROCESO.
           DISPLAY "Ingrese ID del empleado (99999 para terminar): "
           ACCEPT EMP-ID
           
           IF EMP-ID = 99999
               MOVE 'S' TO WS-FIN
           ELSE
               PERFORM 210-PROCESAR-EMPLEADO
           END-IF.

       210-PROCESAR-EMPLEADO.
           DISPLAY "Ingrese nombre del empleado: "
           ACCEPT EMP-NOMBRE
           DISPLAY "Ingrese departamento: "
           ACCEPT EMP-DEPARTAMENTO
           DISPLAY "Ingrese salario: "
           ACCEPT EMP-SALARIO
           
           WRITE REGISTRO-EMPLEADO
           
           ADD 1 TO WS-CONTADOR
           ADD EMP-SALARIO TO WS-TOTAL-SALARIOS
           
           MOVE EMP-ID TO WS-DET-ID
           MOVE EMP-NOMBRE TO WS-DET-NOMBRE
           MOVE EMP-DEPARTAMENTO TO WS-DET-DEPTO
           MOVE EMP-SALARIO TO WS-DET-SALARIO
           
           DISPLAY WS-LINEA-DETALLE.
               
       300-FINAL.
           IF WS-CONTADOR > 0
               COMPUTE WS-PROMEDIO = WS-TOTAL-SALARIOS / WS-CONTADOR
           END-IF
           
           DISPLAY WS-CABECERA
           DISPLAY "RESUMEN DE PROCESO"
           DISPLAY "Total de empleados: " WS-CONTADOR
           DISPLAY "Total de salarios: $" WS-TOTAL-SALARIOS
           DISPLAY "Salario promedio:  $" WS-PROMEDIO
           DISPLAY WS-CABECERA
           
           CLOSE EMPLEADOS-ARCHIVO.
