;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%       SINTAXIS MASM     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include macrosPF.asm	;Archivo con los macros a utilizar
include Usuario.inc

.model small 
;********************** SEGMENTO DE PILA ***********************
.286
.stack 100h
;********************** SEGMENTO DE DATO ***********************
.data
;-----------------------------------------------------------------


EncabezadoReporte db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",13,10,
                    "FACULTAD DE INGENIERIA",13,10,
                    "ESCUELA DE CIENCIAS Y SISTEMAS",13,10,
                    "ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A",13,10,
                    "PRIMER SEMESTRE 2020",13,10,
                    "OSCAR ALFREDO LLAMAS LEMUS",13,10,
                    "201602625",13,10,13,10

TReporte db "REPORTE PROYECTO FINAL",13,10,13,10 

PUBLIC Usuarios
Usuarios	Usuario 20 DUP (<>)

;**************************************************************************
bufferEntrada db 50 dup('$'),00
bufferAuxiliar db 50 dup('$'),00
bufferAuxiliar2 db 50 dup('$'),00
handlerEntrada dw ?
bufferReporte db "Puntos.rep",00h
handlerReporte dw ?
bufferInformacion db 200 dup('$')
bufferInfoAux db 200 dup('$')
bufferFechaHora db 15 dup('$')
NBytes WORD 0
Num db 50 dup(00h)
IDAux db 10 dup('$')
TotalUsuarios WORD 0
OffsetUsuario WORD 0
UsuarioAux WORD 0
Punteos WORD 25 dup (0)
intAux WORD 0
intCont WORD 0
ColumnaCarro WORD 54550
NumPrint db 100 dup('$')
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
errorEscritura db "ERROR AL ESCRIBIR EL ARCHIVO!",0ah,0dh,"$"
encabezado db "	UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",0ah,0dh,"	FACULTAD DE INGENIERIA",0ah,0dh,
				09h,"CIENCIAS Y SISTEMAS",0ah,0dh,"	ARQUITECTURAS DE COMPUTADORES Y ENSAMBLADORES 1",0ah,0dh,
				09h,"SECCION A",0ah,0dh,"	NOMBRE: OSCAR ALFREDO LLAMAS LEMUS",0ah,0dh,
				09h,"CARNET: 201602625",0ah,0dh,0ah,0dh,"$"
menu db "	1) Ingresar",0ah,0dh,"	2) Registrar",0ah,0dh,"	3) Salir",0ah,0dh,"$"
Usermenu db "	1) Iniciar Juego",0ah,0dh,"	2) Cargar Juego",0ah,0dh,"	3) Salir",0ah,0dh,"$"
Adminmenu db "	1) Top 10 puntos",0ah,0dh,"	2) Top 10 tiempo",0ah,0dh,"	3) Salir",0ah,0dh,"$"
flecha db "	>>","$"
elegir db "Elija una opcion:","$"
titulo_ingreso db "+++++++++++++++++ INICIAR SESION +++++++++++++++","$"
titulo_admin db "+++++++++++++++++ BIENVENIDO ADMINISTRADOR +++++++++++++++","$"
titulo_registro db "+++++++++++++++++ REGISTRAR NUEVO USUARIO +++++++++++++++","$"
simbolos_mas db "+++++++++++++++++","$"
bienvenido_titulo db "Bienvenid@ ","$"
ingrese_usuario db "Ingrese Username: ","$"
ingrese_pass db "Ingrese Password: ","$"
ingrese_cargar db "INGRESE RUTA DEL ARCHIVO QUE DESEA CARGAR (EJ: C:\Juego.ply)",0ah,0dh,"$"
asigTerminada db "  Asignacion exitosa. Presione cualquier tecla para continuar.","$"
errorIngreso db "Datos invalidos o usuario inexistente. Presione cualquier tecla para continuar.","$"
regExitoso db "Registro exitoso! Presione cualquier tecla para continuar.","$"
PresioneContinuar db "  Presione cualquier tecla para continuar.","$"
ReporteGenerado db "    Reporte generado con exito!",0ah,0dh,"$"
int_invalido db "Intervalo invalido! Presione cualquier tecla para volver a intentar.",0ah,0dh,"$"
formato_invalido db "Formato invalido! Presione cualquier tecla para volver a intentar.",0ah,0dh,"$"
extension_invalida db "Extension invalida! Presione cualquier tecla para volver a intentar.",0ah,0dh,"$"
espacio db "  ","$"
;********************** SEGMENTO DE CODIGO *********************** 
.code

main proc 
mov dx,@data
mov ds,dx
mov OffsetUsuario, offset Usuarios
Inicio:


    Clear_Screen
	InicioVideo
	PintarFondo 15d
	PintarCarro 10d

	PausaSalir
	RegresarATexto
	jmp salir


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
	getCharSE
	jmp Inicio

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
	getCharSE
	cmp al,31h			;1
	je INICIAR_JUEGO
	cmp al,32h			;2
    je CARGAR_JUEGO
    cmp al,33h			;3
    je Inicio
	jmp Inicio_Usuario

INICIAR_JUEGO:
InicioVideo
PintarFondo 15
PausaSalir
RegresarATexto
jmp Inicio_Usuario

CARGAR_JUEGO:
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
	jmp Inicio

Error_Escritura:
	print salto
	print errorEscritura
	getCharSE
	jmp Inicio

Error_Abrir:
	print salto
	print errorAbrir
	getCharSE
	jmp Inicio

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

salir:					
	mov ax,4c00h 		
	xor al,al 
	int 21h 				

main endp 	

end main

