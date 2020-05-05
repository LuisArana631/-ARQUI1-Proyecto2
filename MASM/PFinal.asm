;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%       SINTAXIS MASM     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include macrosPF.asm	;Archivo con los macros a utilizar
include Usuario.inc
include Level.inc

.model small 
;********************** SEGMENTO DE PILA ***********************
.286
.stack 100h
;********************** SEGMENTO DE DATO ***********************
.data
;---------------------------CADENAS PARA REPORTE-------------------------
EncabezadoReporte db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",13,10,
                    "FACULTAD DE INGENIERIA",13,10,
                    "ESCUELA DE CIENCIAS Y SISTEMAS",13,10,
                    "ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A",13,10,
                    "PRIMER SEMESTRE 2020",13,10,
                    "OSCAR ALFREDO LLAMAS LEMUS",13,10,
                    "201602625",13,10,13,10

RSalto db " ",13,10
RTabulacion db "        "
R_TPuntos db "+++++++++++++++ TOP 10 PUNTOS +++++++++++++++",13,10,13,10
R_TTiempo db "+++++++++++++++ TOP 10 TIEMPO +++++++++++++++",13,10,13,10
Rcolumnas_puntos db "    Usuario        Nivel       Puntos",13,10,13,10
Rcolumnas_tiempo db "    Usuario        Nivel       Tiempo",13,10,13,10
TReporte db "REPORTE PROYECTO FINAL",13,10,13,10 
REspacio db "  "
RPunto db "."
;------------------------------------------------------------------
PUBLIC Niveles
Niveles	    Level 10 DUP (<>)

PUBLIC Usuarios
Usuarios	Usuario 20 DUP (<>)

PUBLIC UAuxiliar
UAuxiliar Usuario 1 DUP (<>)

PUBLIC UsuariosAux
UsuariosAux	Usuario 20 DUP (<>)

;**************************************************************************
bufferEntrada db 50 dup('$'),00
bufferAuxiliar db 50 dup('$')
handlerEntrada dw ?
bufferPuntos db "Puntos.rep",00h
handlerPuntos dw ?
bufferTiempo db "Tiempo.rep",00h
handlerTiempo dw ?
bufferInformacion db 300 dup('$')
bufferInfoAux db 200 dup('$')
bufferFechaHora db 15 dup('$')
NBytes WORD 0
IDAux db 10 dup('$')
IDAuxFile db 10 dup(00h)
TotalUsuarios WORD 0
TotalNiveles WORD 0
OffsetUsuario WORD 0
NivelAux WORD 0
UsuarioAux WORD 0
OFFSETAux WORD 0
Valores db 25 dup (0)
intAux WORD 0
AuxVar db 0
intCont WORD 0
NumeroAux WORD 0
Contador1 WORD 0
Contador2 WORD 0
Contador3 WORD 0
Contador4 WORD 0
;-------VARIABLES QUICKSORT--------
subArray WORD 0
right WORD 0
left WORD 0
_right WORD 0
_left WORD 0
pivot db 0
;--------VARIABLES SHELLSORT------
ValorI WORD 0
ValorJ WORD 0
increment WORD 0
temp db 0
;---------VARIABLES JUEGO---------
PuntajeAux db 0
TiempoAux db 0
Taux WORD 0
TOaux WORD 0
TPaux WORD 0
PPaux WORD 0
POaux WORD 0
CCaux WORD 0
;---------------------------------
NivelGeneral db 1
ColorCarro db 13d
StringSize WORD 0
Velocidad WORD 0
Segundos WORD 0
ValorDelay WORD 10100101101b
ColumnaCarro WORD 10101010b
AnchoBarra WORD 10
AlturaMax WORD 150
AlturaAux WORD 0
ValorMax WORD 0
ColorAux db 15d
HzAux WORD 100d
InicioBarra WORD 0
Separacion db 0
Separacion2 db 0
SeparacionAux db 0
NumPrint db 100 dup('$')
Num db 100 dup(00h)
arregloID db 10 dup('$')
arregloPASS db 10 dup('$')
salto db " ",0ah,0dh,"$"
AdminUser db "admin$$$"
AdminPass db "1234$$$$"
exitoAbrir db " ARCHIVO CARGADO EXITOSAMENTE!",0ah,0dh,"$"
exitoGuardar db "ARCHIVO GUARDADO EXITOSAMENTE!",0ah,0dh,"$"
errorCrear db "ERROR AL CREAR EL ARCHIVO!",0ah,0dh,"$"
errorAbrir db "ERROR AL CARGAR EL ARCHIVO!",0ah,0dh,"$"
errorCerrar db "ERROR AL CERRAR EL ARCHIVO!",0ah,0dh,"$"
errorLeer db "ERROR AL LEER EL ARCHIVO!",0ah,0dh,"$"
errorEntrada db "Archivo de entrada invalido! Presione cualquier tecla para regresar.","$"
errorEscritura db "ERROR AL ESCRIBIR EL ARCHIVO!",0ah,0dh,"$"
encabezado db "	UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",0ah,0dh,"	FACULTAD DE INGENIERIA",0ah,0dh,
				09h,"CIENCIAS Y SISTEMAS",0ah,0dh,"	ARQUITECTURAS DE COMPUTADORES Y ENSAMBLADORES 1",0ah,0dh,
				09h,"SECCION A",0ah,0dh,"	NOMBRE: OSCAR ALFREDO LLAMAS LEMUS",0ah,0dh,
				09h,"CARNET: 201602625",0ah,0dh,0ah,0dh,"$"
menu db "	1) Ingresar",0ah,0dh,"	2) Registrar",0ah,0dh,"	3) Salir",0ah,0dh,"$"
Usermenu db "	1) Iniciar Juego",0ah,0dh,"	2) Cargar Juego",0ah,0dh,"	3) Salir",0ah,0dh,"$"
Adminmenu db "	1) Top 10 puntos",0ah,0dh,"	2) Top 10 tiempo",0ah,0dh,"	3) Salir",0ah,0dh,"$"
Tipomenu db "  1) Ordenamiento BubbleSort Ascendente",0ah,0dh,"  2) Ordenamiento BubbleSort Descendente",0ah,0dh,
            "  3) Ordenamiento QuickSort Ascendente",0ah,0dh,"  4) Ordenamiento QuickSort Descendente",0ah,0dh,
            "  5) Ordenamiento ShellSort Ascendente",0ah,0dh,"  6) Ordenamiento ShellSort Descendente",0ah,0dh,
				"  7) Regresar",0ah,0dh,"$"
flecha db "	>>","$"
elegir db "Elija una opcion:","$"
ingreseVelocidad db "Ingrese un valor de velocidad [0,9]: ","$"
titulo_ingreso db "+++++++++++++++++ INICIAR SESION +++++++++++++++","$"
titulo_admin db "+++++++++++++++++ BIENVENIDO ADMINISTRADOR +++++++++++++++","$"
titulo_registro db "+++++++++++++++++ REGISTRAR NUEVO USUARIO +++++++++++++++","$"
titulo_puntos db "+++++++++++++++++ REPORTE PUNTOS +++++++++++++++","$"
titulo_tiempo db "+++++++++++++++++ REPORTE TIEMPO +++++++++++++++","$"
titulo_tipo db "+++++++++++++++++ TIPO DE ORDENAMIENTO +++++++++++++++","$"
titulo_velocidad db "+++++++++++++++++ VALOR DE VELOCIDAD +++++++++++++++","$"
titulo_cargar db "+++++++++++++++++ CARGAR JUEGO +++++++++++++++","$"
titulo_pausa db "+++++++++++++++ PAUSA ++++++++++++++","$"
simbolos_mas db "+++++++++++++++++","$"
bienvenido_titulo db "Bienvenid@ ","$"
ingrese_usuario db "Ingrese Username: ","$"
ingrese_pass db "Ingrese Password: ","$"
ingrese_cargar db "INGRESE RUTA DEL ARCHIVO QUE DESEA CARGAR (EJ: C:\Juego.ply)",0ah,0dh,"$"
asigTerminada db "  Asignacion exitosa. Presione cualquier tecla para continuar.","$"
cargTerminada db "  Carga exitosa. Presione cualquier tecla para continuar.","$"
errorIngreso db "Datos invalidos o usuario inexistente. Presione cualquier tecla para continuar.","$"
regExitoso db "Registro exitoso! Presione cualquier tecla para continuar.","$"
PresioneContinuar db "  Presione cualquier tecla para continuar.","$"
PresioneBarra db "  Presione la barra espaciadora para continuar.","$"
ReporteGenerado db "    Reporte generado con exito!",0ah,0dh,"$"
valor_invalido db "Valor invalido! Presione cualquier tecla para volver a intentar.",0ah,0dh,"$"
formato_invalido db "Formato invalido! Presione cualquier tecla para volver a intentar.",0ah,0dh,"$"
extension_invalida db "Extension invalida! Presione cualquier tecla para volver a intentar.",0ah,0dh,"$"
espacio db "   ","$"
tabulacion db "	","$"
SPVar db " ","$"
punto db ".","$"
GTiempo db "Tiempo: ","$"
TPuntos db "Grafica: Puntuaciones        ","$"
TBA db "Ordenamiento Burbuja Asc.    ","$"
TBD db "Ordenamiento Burbuja Desc.   ","$"
TQA db "Ordenamiento QuickSort Asc.  ","$"
TQD db "Ordenamiento QuickSort Desc. ","$"
TSA db "Ordenamiento ShellSort Asc.  ","$"
TSD db "Ordenamiento ShellSort Desc. ","$"
TVelocidad db "Velocidad:","$"
TNivel db " Nivel:","$"
EPuntos db " Puntos:","$"
ETiempo db " 00:00","$"
NoUsuarios db "No hay ningun usuario registrado. Presione cualquier tecla para continuar.",0ah,0dh,"$"
columnas_puntos db "    Usuario		Nivel		Puntos","$"
columnas_tiempo db "    Usuario		Nivel		Tiempo","$"
;********************** SEGMENTO DE CODIGO *********************** 
.code

main proc 
mov dx,@data
mov ds,dx
mov OffsetUsuario, offset Usuarios

Inicio:
    Clear_Screen
    print encabezado
    print elegir
	print salto

Imprimir_Menu:
	print menu
	getCharSE
	cmp al,31h			;1
	je OPCION1
	cmp al,32h			;2
    je OPCION2
    cmp al,33h			;3
    je salir
	jmp Inicio

OPCION1: ;INGRESAR
	Clear_Screen
	LimpiarBuffer arregloID, SIZEOF arregloID, 24h
	LimpiarBuffer arregloPASS, SIZEOF arregloPASS, 24h
	print titulo_ingreso
	print salto
	print ingrese_usuario   
	ObtenerTexto arregloID
	print salto
	print ingrese_pass
	ObtenerTexto arregloPASS
	Comparar arregloID, AdminUser
	jne IngresoUsuario
	Comparar arregloPASS, AdminPass
	jne Error_Ingreso
	jmp SesionAdmin
	

Error_Ingreso:
	print salto
	print errorIngreso
	getCharSE
	jmp Inicio

SesionAdmin:
	Clear_Screen
	print titulo_admin
	print salto
	print salto
	print encabezado
    print elegir
	print salto
	print Adminmenu
	VerificarTecladoAdmin:
	getCharSE
	cmp al,31h			;1
	je TOP_PUNTOS
	cmp al,32h			;2
    je TOP_TIEMPO
    cmp al,33h			;3
    je Inicio
	jmp VerificarTecladoAdmin

TOP_PUNTOS:
    Clear_Screen
    print titulo_puntos
    print salto
    print salto
    DuplicarUsuarios
    ImprimirPuntuaciones   
    ObtenerPuntuaciones
    print salto
    print PresioneBarra
    LeerBarra:
    getCharSE
    cmp al,20h ;Barra Espaciadora
    je ElegirOrdenamiento
    jmp LeerBarra

TOP_TIEMPO:
    Clear_Screen
    print titulo_tiempo
    print salto
    print salto
    DuplicarUsuarios
    ImprimirTiempos
    ObtenerTiempos
    print salto
    print PresioneBarra
    LeerBarra2:
    getCharSE
    cmp al,20h ;Barra Espaciadora
    je ElegirOrdenamiento
    jmp LeerBarra2


ElegirOrdenamiento:
    Clear_Screen
    print titulo_tipo
    print salto
    print salto
    print elegir
    print salto
    print salto
    print Tipomenu
    mov Segundos,0
    VerificarTipo:
	getCharSE
	cmp al,31h			;1
	je BurbujaAscendente
	cmp al,32h			;2
    je BurbujaDescendente
	cmp al,33h			;3
	je QuickAscendente
	cmp al,34h			;4
    je QuickDescendente
    cmp al,35h			;5
	je ShellAscendente
	cmp al,36h			;6
    je ShellDescendente
	cmp al,37h			;7
    je SesionAdmin
	jmp VerificarTipo

BurbujaAscendente:
    SetearVelocidad
    InicioVideo  
    GraficarArreglo Valores, TPuntos   
    PausaSalir
    BurbujaAsc Valores, TBA
    PausaSalir
    RegresarATexto
    jmp SesionAdmin

BurbujaDescendente:
    SetearVelocidad
    InicioVideo 
    GraficarArreglo Valores, TPuntos   
    PausaSalir
    BurbujaDec Valores, TBD
    PausaSalir
    RegresarATexto
    jmp SesionAdmin

QuickAscendente:
    SetearVelocidad
    InicioVideo
    GraficarArreglo Valores, TPuntos   
    PausaSalir
    QuickSortAsc Valores, TQA
    PausaSalir
    RegresarATexto
    jmp SesionAdmin

QuickDescendente:
    SetearVelocidad
    InicioVideo
    GraficarArreglo Valores, TPuntos   
    PausaSalir
    QuickSortDesc Valores, TQD
    PausaSalir
    RegresarATexto
    jmp SesionAdmin

ShellAscendente:
    SetearVelocidad
    InicioVideo
    GraficarArreglo Valores, TPuntos      
    PausaSalir
    ShellSortAsc Valores, TSA
    PausaSalir
    RegresarATexto
    jmp SesionAdmin

ShellDescendente:
    SetearVelocidad
    InicioVideo
    GraficarArreglo Valores, TPuntos      
    PausaSalir
    ShellSortDesc Valores, TSD   
    PausaSalir
    RegresarATexto
    jmp SesionAdmin


IngresoUsuario:
	LoggearUsuario
	Inicio_Usuario:
	Clear_Screen
	print simbolos_mas
	print espacio
	print bienvenido_titulo
	mov bx,UsuarioAux
	CopiarArreglo [bx].Usuario.Username, IDAux, 0, 10
	print IDAux
	print espacio
	print simbolos_mas
	print salto
	print salto
	print encabezado
    print elegir
	print salto
	print Usermenu
	VerificarTeclado:
	getCharSE
	cmp al,31h			;1
	je INICIAR_JUEGO
	cmp al,32h			;2
    je CARGAR_JUEGO
    cmp al,33h			;3
    je Inicio
	jmp VerificarTeclado

INICIAR_JUEGO:
InicioVideo
mov cx,TotalNiveles
cmp cx,0
jg JuegoConNiveles
JuegoSN
RegresarATexto
jmp Inicio_Usuario
JuegoConNiveles:
JuegoCN
RegresarATexto
jmp Inicio_Usuario





CARGAR_JUEGO:
Clear_Screen
print titulo_cargar
print salto
print salto
print ingrese_cargar
print salto
print flecha
LimpiarBuffer bufferEntrada, SIZEOF bufferEntrada,24h
ObtenerRuta bufferEntrada
AbrirArchivo bufferEntrada, handlerEntrada
ContinuarLeer:
LimpiarBuffer bufferInformacion, SIZEOF bufferInformacion,24h
LeerArchivo handlerEntrada, bufferInformacion, SIZEOF bufferInformacion
SetearJuego
print salto
print cargTerminada
getCharSE
jmp Inicio_Usuario


OPCION2: ;REGISTRAR
	Clear_Screen
	LimpiarBuffer arregloID, SIZEOF arregloID, 24h
	LimpiarBuffer arregloPASS, SIZEOF arregloPASS, 24h
	print titulo_registro
	print salto
	print ingrese_usuario   
	ObtenerTexto arregloID
	print salto
	print ingrese_pass
	ObtenerTexto arregloPASS
	mov di,OffsetUsuario
	mov [di].Usuario.Punteo,0
	mov [di].Usuario.Nivel,1
	xor bx,bx
	Copiar:
	mov al,arregloID[bx]
	mov [di].Usuario.Username[bx],al
	inc bx
	xor cx,cx
	mov cx,SIZEOF arregloID
	cmp bx,cx
	jb Copiar
	xor bx,bx
	Copiar2:
	mov al,arregloPASS[bx]
	mov [di].Usuario.Password[bx],al
	inc bx
	mov cx,SIZEOF arregloPASS
	cmp bx,cx
	jb Copiar2
	inc TotalUsuarios
	add OffsetUsuario,SIZEOF Usuario
	print regExitoso
	getCharSE
	jmp Inicio        

Error_Crear:
	print salto
	print errorCrear
	getCharSE
	jmp SesionAdmin

Error_Escritura:
	print salto
	print errorEscritura
	getCharSE
	jmp Inicio

Error_Abrir:
	print salto
	print errorAbrir
	getCharSE
	jmp CARGAR_JUEGO

Error_Leer:
	print salto
	print errorLeer
	getCharSE
	jmp Inicio	

Error_Cerrar:
	print salto
	print errorCerrar
	getCharSE
	jmp Inicio


Error_Entrada:
	print salto
	print errorEntrada
	getCharSE
	jmp Inicio_Usuario   

salir:					
	mov ax,4c00h 		
	xor al,al 
	int 21h 				

main endp 	

ConvertirNum proc
            push bp                    ;almacenamos el puntero base
            mov  bp,sp                 ;ebp contiene la direccion de esp
            sub  sp,2                  ;se guarda espacio para dos variables
            mov word ptr[bp-2],0       ;var local =0 
            pusha
            LimpiarBuffer Num, SIZEOF Num, 00h
            xor si,si                          ;si=0
            cmp ax,0                           ;si ax, ya viene con un cero
            je casoMinimo           
            mov  bx,0                          ;denota el fin de la cadena
            push bx                            ;se pone en la pila el fin de cadena
            Bucle:  
                mov dx,0
                cmp ax,0                    ;¿AX= 0?
                je toNum                    ;si:enviar numero al arreglo                
                mov bx,10                   ;divisor  = 10
                div bx                      ;ax =cociente ,dx= residuo
                add dx,48d                   ;residuo +48 para  poner el numero en ascii
                push dx                     ;lo metemos en la pila 
                jmp Bucle
            toNum:
                pop bx                      ;obtenemos elemento de la pila
                mov word ptr[bp-2],bx       ; pasamos de 16 bits a 8 bits 
                mov al, byte ptr[bp-2]
                cmp al,0                    ;¿Fin de Numero?
                je FIN                      ;si: enviar al fin del procedimiento
                mov num[si],al              ;ponemos el numero en ascii en la cadena
                inc si                      ;incrementamos los valores               
                jmp toNum                   ;iteramos de nuevo            
            casoMinimo:
                add al,48d                         ;convertimos 0 ascii
                mov Num[si],al                     ;Lo pasamos a num
                jmp FIN
            FIN:
                popa
                mov sp,bp               ;esp vuelve apuntar al inicio y elimina las variables locales
                pop bp                  ;restaura el valor del puntro base listo para el ret
                ret 
    ConvertirNum endp

ConvertirPrint proc
            push bp                   
            mov  bp,sp                
            sub  sp,2                 
            mov word ptr[bp-2],0      
            pusha
            LimpiarBuffer NumPrint, SIZEOF NumPrint, 24h
            xor si,si                        
            cmp ax,0                        
            je casoMinimo2         
            mov  bx,0                       
            push bx                          
            Bucle2:  
                mov dx,0
                cmp ax,0                   
                je toNum2                                
                mov bx,10               
                div bx                    
                add dx,48d                
                push dx                    
                jmp Bucle2
            toNum2:
                pop bx                   
                mov word ptr[bp-2],bx    
                mov al, byte ptr[bp-2]
                cmp al,0                   
                je FIN2                  
                mov NumPrint[si],al          
                inc si                            
                jmp toNum2                 
            casoMinimo2:
                add al,48d                     
                mov NumPrint[si],al                
                jmp FIN2
            FIN2:
                popa
                mov sp,bp           
                pop bp                
                ret 
    ConvertirPrint endp

	Random proc 
        ;--------------------------------------------------------------------
        ;   Recibe:       [bp+4] Limite Superior                    
        ;                                                                    
        ;   Devuelve:    AX = Numero ramdon del uno al LimiteSuperior (Max. 255)         
        ;                                                                    
        ;   Comentarios: Obtiene la hora del sistema                         
        ;--------------------------------------------------------------------

        ;ini Subrutina proglogo
            push bp                    ;almacenamos el puntero base
            mov  bp,sp                 ;ebp contiene la direccion de esp
            sub  sp,2                  ;se guarda espacio para dos variables
            mov word ptr[bp-2],0       ;var local =0
            push dx
            push bx
        ;fin Subrutina prologo

        ;Ini Codigo--
  
            mov ah,2ch                  ;funcion de la hora
            int 21h                     ;llamada a ms-dos

            mov byte ptr[bp-2],dl       ;DL = Segundos(No son precisas)    
            mov ax,word ptr[bp-2]       ;diviendo = Centesimas
            mov bl,byte ptr[bp+4]       ;divisor  = 10
            div bl                      ;al=cociente, ah= residuo


            add ah,1                    ;mod %10 +1
            
            mov byte ptr[bp-2],ah
            mov ax,word ptr[bp-2]
        ;Fin Codigo--


        ;ini Subrutina epilogo
            FIN:
                push bx
                push dx 
                mov sp,bp               ;esp vuelve apuntar al inicio y elimina las variables locales
                pop bp                  ;restaura el valor del puntro base listo para el ret
                ret 2                   ; vaciamos los parametros de entrada
            ;fin etiqueta
        ;fin Subrutna epilogo
    Random endp


end main

