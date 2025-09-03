       IDENTIFICATION DIVISION.
       PROGRAM-ID. SISTEMA-INVENTARIO.
       AUTHOR. Javier J. Tapia.
       DATE-WRITTEN. 2025-08-14.
      
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
           
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRODUCTOS-ARCHIVO
           ASSIGN TO "productos.dat"
           ORGANIZATION IS INDEXED
           ACCESS MODE IS DYNAMIC
           RECORD KEY IS PROD-ID
           ALTERNATE RECORD KEY IS PROD-NOMBRE WITH DUPLICATES
           FILE STATUS IS WS-PROD-STATUS.
           
           SELECT MOVIMIENTOS-ARCHIVO
           ASSIGN TO "movimientos.dat"
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS WS-MOV-STATUS.
           
           SELECT REPORTE-ARCHIVO
           ASSIGN TO "reporte_inventario.txt"
           ORGANIZATION IS LINE SEQUENTIAL.
           
       DATA DIVISION.
       FILE SECTION.
       FD  PRODUCTOS-ARCHIVO.
       01  REGISTRO-PRODUCTO.
           05  PROD-ID             PIC 9(6).
           05  PROD-NOMBRE         PIC X(30).
           05  PROD-CATEGORIA      PIC X(20).
           05  PROD-PRECIO         PIC 9(7)V99.
           05  PROD-STOCK          PIC 9(5).
           05  PROD-STOCK-MIN      PIC 9(5).
           05  PROD-PROVEEDOR      PIC X(30).
           05  PROD-ULTIMA-COMPRA  PIC X(10).
           
       FD  MOVIMIENTOS-ARCHIVO.
       01  REGISTRO-MOVIMIENTO.
           05  MOV-FECHA           PIC X(10).
           05  MOV-TIPO            PIC X(1).
               88 ES-ENTRADA       VALUE "E".
               88 ES-SALIDA        VALUE "S".
           05  MOV-PROD-ID         PIC 9(6).
           05  MOV-CANTIDAD        PIC 9(5).
           05  MOV-PRECIO-UNIT     PIC 9(7)V99.
           
       FD  REPORTE-ARCHIVO.
       01  LINEA-REPORTE          PIC X(132).
           
       WORKING-STORAGE SECTION.
       01  WS-VARIABLES.
           05  WS-PROD-STATUS      PIC X(2).
           05  WS-MOV-STATUS       PIC X(2).
           05  WS-FIN              PIC X VALUE "N".
           05  WS-OPCION           PIC 9.
           05  WS-FECHA-HOY        PIC X(10).
           05  WS-TOTAL-VALOR      PIC 9(12)V99.
           05  WS-INDICE           PIC 99.
           
       01  WS-CONTADORES.
           05  WS-PRODUCTOS-BAJOS  PIC 9(4) VALUE 0.
           05  WS-TOTAL-PRODUCTOS  PIC 9(4) VALUE 0.
           05  WS-MOVIMIENTOS-HOY  PIC 9(4) VALUE 0.
           
       01  WS-CABECERA-PRINCIPAL.
           05  FILLER     PIC X(80) VALUE ALL "=".
           05  FILLER     PIC X(40) VALUE 
               "    SISTEMA DE GESTION DE INVENTARIO    ".
           05  FILLER     PIC X(80) VALUE ALL "=".
           
       01  WS-MENU.
           05  WS-MENU-TITULO    PIC X(80).
           05  WS-MENU-LINEA-DIV PIC X(80).
           05  WS-MENU-LINEAS.
               10  WS-MENU-LINEA OCCURS 8 TIMES PIC X(80).
               
       01  WS-LINEA-DETALLE.
           05  FILLER     PIC X(2)  VALUE SPACES.
           05  WS-DET-ID  PIC 9(6).
           05  FILLER     PIC X(2)  VALUE SPACES.
           05  WS-DET-NOM PIC X(30).
           05  FILLER     PIC X(2)  VALUE SPACES.
           05  WS-DET-CAT PIC X(20).
           05  FILLER     PIC X(2)  VALUE SPACES.
           05  WS-DET-STK PIC ZZZ9.
           05  FILLER     PIC X(2)  VALUE SPACES.
           05  WS-DET-PRE PIC $ZZZZ9.99.
           
       PROCEDURE DIVISION.
       MAIN-SECTION SECTION.
       MAIN-LOGIC.
           PERFORM 000-INICIAR
           PERFORM 100-PROCESAR-MENU UNTIL WS-FIN = "S"
           PERFORM 999-FINALIZAR
           STOP RUN.
           
       000-INICIAR.
           PERFORM 001-ABRIR-ARCHIVOS
           PERFORM 002-OBTENER-FECHA
           DISPLAY WS-CABECERA-PRINCIPAL.
           
       001-ABRIR-ARCHIVOS.
           OPEN I-O PRODUCTOS-ARCHIVO
           IF WS-PROD-STATUS = "35"
               OPEN OUTPUT PRODUCTOS-ARCHIVO
               CLOSE PRODUCTOS-ARCHIVO
               OPEN I-O PRODUCTOS-ARCHIVO
           END-IF

           OPEN I-O MOVIMIENTOS-ARCHIVO
           IF WS-MOV-STATUS = "35"
               OPEN OUTPUT MOVIMIENTOS-ARCHIVO
               CLOSE MOVIMIENTOS-ARCHIVO
               OPEN I-O MOVIMIENTOS-ARCHIVO
           END-IF.
           
       002-OBTENER-FECHA.
           ACCEPT WS-FECHA-HOY FROM DATE YYYYMMDD.
           
       MENU-SECTION SECTION.
       100-PROCESAR-MENU.
           PERFORM 110-MOSTRAR-MENU
           ACCEPT WS-OPCION
           
           EVALUATE WS-OPCION
               WHEN 1
                   PERFORM 200-NUEVO-PRODUCTO
               WHEN 2
                   PERFORM 300-ENTRADA-STOCK
               WHEN 3
                   PERFORM 400-SALIDA-STOCK
               WHEN 4
                   PERFORM 500-CONSULTAR-PRODUCTO
               WHEN 5
                   PERFORM 600-LISTAR-BAJO-STOCK
               WHEN 6
                   PERFORM 700-GENERAR-REPORTE
               WHEN 7
                   PERFORM 800-VER-MOVIMIENTOS
               WHEN 8
                   MOVE "S" TO WS-FIN
               WHEN OTHER
                   DISPLAY "Opcion invalida"
           END-EVALUATE.
           
       110-MOSTRAR-MENU.
           INITIALIZE WS-MENU
           MOVE ALL "=" TO WS-MENU-LINEA-DIV
           STRING "                    MENU PRINCIPAL" 
               DELIMITED BY SIZE INTO WS-MENU-TITULO
           STRING "     1. Registrar Nuevo Producto" 
               DELIMITED BY SIZE INTO WS-MENU-LINEA(1)
           STRING "     2. Registrar Entrada de Stock" 
               DELIMITED BY SIZE INTO WS-MENU-LINEA(2)
           STRING "     3. Registrar Salida de Stock" 
               DELIMITED BY SIZE INTO WS-MENU-LINEA(3)
           STRING "     4. Consultar Producto" 
               DELIMITED BY SIZE INTO WS-MENU-LINEA(4)
           STRING "     5. Listar Productos Bajo Stock" 
               DELIMITED BY SIZE INTO WS-MENU-LINEA(5)
           STRING "     6. Generar Reporte de Inventario" 
               DELIMITED BY SIZE INTO WS-MENU-LINEA(6)
           STRING "     7. Ver Movimientos del Dia" 
               DELIMITED BY SIZE INTO WS-MENU-LINEA(7)
           STRING "     8. Salir" 
               DELIMITED BY SIZE INTO WS-MENU-LINEA(8)
           DISPLAY WS-CABECERA-PRINCIPAL
           DISPLAY SPACES
           DISPLAY WS-MENU-TITULO
           DISPLAY WS-MENU-LINEA-DIV
           DISPLAY SPACES
           PERFORM VARYING WS-INDICE FROM 1 BY 1 UNTIL WS-INDICE > 8
               DISPLAY WS-MENU-LINEA(WS-INDICE)
           END-PERFORM
           DISPLAY SPACES
           DISPLAY WS-MENU-LINEA-DIV
           DISPLAY SPACES
           DISPLAY "Ingrese su opcion (1-8): ".

       PRODUCTOS-SECTION SECTION.
       200-NUEVO-PRODUCTO.
           DISPLAY "=== REGISTRO DE NUEVO PRODUCTO ==="
           DISPLAY "ID Producto (6 digitos): "
           ACCEPT PROD-ID
           
           READ PRODUCTOS-ARCHIVO
               INVALID KEY
                   PERFORM 210-INGRESAR-DATOS
               NOT INVALID KEY
                   DISPLAY "ERROR: Producto ya existe"
           END-READ.
           
       210-INGRESAR-DATOS.
           DISPLAY "Nombre del Producto: "
           ACCEPT PROD-NOMBRE
           DISPLAY "Categoria: "
           ACCEPT PROD-CATEGORIA
           DISPLAY "Precio: "
           ACCEPT PROD-PRECIO
           DISPLAY "Stock Inicial: "
           ACCEPT PROD-STOCK
           DISPLAY "Stock Minimo: "
           ACCEPT PROD-STOCK-MIN
           DISPLAY "Proveedor: "
           ACCEPT PROD-PROVEEDOR
           MOVE WS-FECHA-HOY TO PROD-ULTIMA-COMPRA
           
           WRITE REGISTRO-PRODUCTO
               INVALID KEY
                   DISPLAY "Error al guardar producto"
               NOT INVALID KEY
                   DISPLAY "Producto registrado exitosamente"
           END-WRITE.
           
       300-ENTRADA-STOCK.
           DISPLAY "=== ENTRADA DE STOCK ==="
           PERFORM 310-BUSCAR-PRODUCTO
           IF WS-PROD-STATUS = "00"
               PERFORM 320-REGISTRAR-ENTRADA
           END-IF.
           
       310-BUSCAR-PRODUCTO.
           DISPLAY "ID Producto: "
           ACCEPT PROD-ID
           READ PRODUCTOS-ARCHIVO
               INVALID KEY
                   DISPLAY "Producto no encontrado"
               NOT INVALID KEY
                   DISPLAY "Producto: " PROD-NOMBRE
                   DISPLAY "Stock actual: " PROD-STOCK
           END-READ.
           
       320-REGISTRAR-ENTRADA.
           DISPLAY "Cantidad a ingresar: "
           ACCEPT MOV-CANTIDAD
           DISPLAY "Precio unitario: "
           ACCEPT MOV-PRECIO-UNIT
           
           MOVE "E" TO MOV-TIPO
           MOVE PROD-ID TO MOV-PROD-ID
           MOVE WS-FECHA-HOY TO MOV-FECHA
           
           WRITE REGISTRO-MOVIMIENTO
           
           ADD MOV-CANTIDAD TO PROD-STOCK
           MOVE WS-FECHA-HOY TO PROD-ULTIMA-COMPRA
           
           REWRITE REGISTRO-PRODUCTO
               INVALID KEY
                   DISPLAY "Error actualizando stock"
               NOT INVALID KEY
                   DISPLAY "Stock actualizado correctamente"
           END-REWRITE.
           
       400-SALIDA-STOCK.
           DISPLAY "=== SALIDA DE STOCK ==="
           PERFORM 310-BUSCAR-PRODUCTO
           IF WS-PROD-STATUS = "00"
               PERFORM 410-REGISTRAR-SALIDA
           END-IF.
           
       410-REGISTRAR-SALIDA.
           DISPLAY "Cantidad a retirar: "
           ACCEPT MOV-CANTIDAD
           
           IF MOV-CANTIDAD > PROD-STOCK
               DISPLAY "Error: Stock insuficiente"
           ELSE
               MOVE "S" TO MOV-TIPO
               MOVE PROD-ID TO MOV-PROD-ID
               MOVE WS-FECHA-HOY TO MOV-FECHA
               MOVE PROD-PRECIO TO MOV-PRECIO-UNIT
               
               WRITE REGISTRO-MOVIMIENTO
               
               SUBTRACT MOV-CANTIDAD FROM PROD-STOCK
               
               REWRITE REGISTRO-PRODUCTO
                   INVALID KEY
                       DISPLAY "Error actualizando stock"
                   NOT INVALID KEY
                       DISPLAY "Stock actualizado correctamente"
               END-REWRITE
           END-IF.
           
       CONSULTAS-SECTION SECTION.
       500-CONSULTAR-PRODUCTO.
           DISPLAY "=== CONSULTA DE PRODUCTO ==="
           PERFORM 310-BUSCAR-PRODUCTO
           IF WS-PROD-STATUS = "00"
               PERFORM 510-MOSTRAR-DETALLES
           END-IF.
           
       510-MOSTRAR-DETALLES.
           DISPLAY "=== DETALLES DEL PRODUCTO ==="
           DISPLAY "ID: " PROD-ID
           DISPLAY "Nombre: " PROD-NOMBRE
           DISPLAY "Categoria: " PROD-CATEGORIA
           DISPLAY "Precio: $" PROD-PRECIO
           DISPLAY "Stock Actual: " PROD-STOCK
           DISPLAY "Stock Minimo: " PROD-STOCK-MIN
           DISPLAY "Proveedor: " PROD-PROVEEDOR
           DISPLAY "Ultima Compra: " PROD-ULTIMA-COMPRA.
           
       600-LISTAR-BAJO-STOCK.
           DISPLAY "=== PRODUCTOS BAJO STOCK MINIMO ==="
           MOVE 0 TO WS-PRODUCTOS-BAJOS
           
           PERFORM 610-LEER-SIGUIENTE UNTIL WS-PROD-STATUS = "10"
           
           DISPLAY "Total productos bajo stock: " WS-PRODUCTOS-BAJOS.
           
       610-LEER-SIGUIENTE.
           READ PRODUCTOS-ARCHIVO NEXT RECORD
               AT END
                   MOVE "10" TO WS-PROD-STATUS
               NOT AT END
                   IF PROD-STOCK <= PROD-STOCK-MIN
                       ADD 1 TO WS-PRODUCTOS-BAJOS
                       PERFORM 510-MOSTRAR-DETALLES
                   END-IF
           END-READ.

       REPORTES-SECTION SECTION.           
       700-GENERAR-REPORTE.
           DISPLAY "=== GENERANDO REPORTE DE INVENTARIO ==="
           
           OPEN OUTPUT REPORTE-ARCHIVO
           
           MOVE SPACES TO LINEA-REPORTE
           STRING "REPORTE DE INVENTARIO - FECHA: " 
                  WS-FECHA-HOY
                  DELIMITED BY SIZE
                  INTO LINEA-REPORTE
           WRITE LINEA-REPORTE
           
           MOVE SPACES TO LINEA-REPORTE
           MOVE ALL "-" TO LINEA-REPORTE
           WRITE LINEA-REPORTE
           
           MOVE 0 TO WS-TOTAL-VALOR
           MOVE 0 TO WS-TOTAL-PRODUCTOS
           
           PERFORM 710-PROCESAR-PRODUCTOS UNTIL 
                   WS-PROD-STATUS = "10"
           
           MOVE SPACES TO LINEA-REPORTE
           STRING "Total Productos: " WS-TOTAL-PRODUCTOS
                  " - Valor Total Inventario: $" WS-TOTAL-VALOR
                  DELIMITED BY SIZE
                  INTO LINEA-REPORTE
           WRITE LINEA-REPORTE
           
           CLOSE REPORTE-ARCHIVO
           DISPLAY "Reporte generado exitosamente".
           
       710-PROCESAR-PRODUCTOS.
           READ PRODUCTOS-ARCHIVO NEXT RECORD
               AT END
                   MOVE "10" TO WS-PROD-STATUS
               NOT AT END
                   ADD 1 TO WS-TOTAL-PRODUCTOS
                   COMPUTE WS-TOTAL-VALOR = WS-TOTAL-VALOR +
                          (PROD-STOCK * PROD-PRECIO)
                   MOVE SPACES TO LINEA-REPORTE
                   STRING PROD-ID " - " PROD-NOMBRE " - "
                          PROD-CATEGORIA " - Stock: " PROD-STOCK
                          " - Precio: $" PROD-PRECIO
                          DELIMITED BY SIZE
                          INTO LINEA-REPORTE
                   WRITE LINEA-REPORTE
           END-READ.
           
       800-VER-MOVIMIENTOS.
           DISPLAY "=== MOVIMIENTOS DEL DIA ==="
           MOVE 0 TO WS-MOVIMIENTOS-HOY
           
           PERFORM 810-PROCESAR-MOVIMIENTOS UNTIL 
                   WS-MOV-STATUS = "10"
           
           DISPLAY "Total movimientos del dia: " 
                   WS-MOVIMIENTOS-HOY.
           
       810-PROCESAR-MOVIMIENTOS.
           READ MOVIMIENTOS-ARCHIVO NEXT RECORD
               AT END
                   MOVE "10" TO WS-MOV-STATUS
               NOT AT END
                   IF MOV-FECHA = WS-FECHA-HOY
                       ADD 1 TO WS-MOVIMIENTOS-HOY
                       DISPLAY "Tipo: " MOV-TIPO " - "
                               "Producto: " MOV-PROD-ID " - "
                               "Cantidad: " MOV-CANTIDAD " - "
                               "Precio: $" MOV-PRECIO-UNIT
                   END-IF
           END-READ.

       FINALIZAR-SECTION SECTION.           
       999-FINALIZAR.
           CLOSE PRODUCTOS-ARCHIVO
           CLOSE MOVIMIENTOS-ARCHIVO.
