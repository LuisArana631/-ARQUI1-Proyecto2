;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%  IMPRIMIR TEXTO  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

print macro cadena
mov ah,09h
mov dx, offset cadena
int 21h
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  DELAY  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Delay macro constante
LOCAL D1,D2,Fin
push si
push di
mov si,constante
D1:
dec si
jz Fin
mov di,constante
D2:
dec di
jnz D2
jmp D1
Fin:
pop di
pop si
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  SONIDO  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Sonido macro Hz
mov al, 86h
out 43h, al
mov ax, Hz
out 42h, al
mov al, ah
out 42h, al
in al, 61h
or al, 00000011b
out 61h, al
Delay 1200
in al, 61h
and al, 11111100b
out 61h, al
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%    OBTENER FECHA Y HORA     %%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ObtenerFechaHora macro bufferFecha
PUSH ax
PUSH bx
PUSH cx
PUSH dx
PUSH si
	xor si, si
	xor bx, bx

	mov ah,2ah
	int 21h
	;REGISTRO DL = DIA 	 REGISTRO DH = MES

	Establer_Numero bufferFecha, dl  		;ESTABLECIENDO UN NUMERO PARA DIA
	mov bufferFecha[si],2fh ;HEXA DE /
	inc si
	Establer_Numero bufferFecha, dh 		;ESTABLECIENDO UN NUMERO PARA MES
	mov bufferFecha[si],2fh ;HEXA DE /
	inc si
	mov bufferFecha[si],31h	; = 1
	inc si
	mov bufferFecha[si],39h	; = 9
	inc si
	mov bufferFecha[si],20h	; = espacio
	inc si
	mov bufferFecha[si],20h	; = espacio
	inc si

	mov ah,2ch
	int 21h
	;REGISTRO CH = HORA 	 REGISTRO CL = MINUTOS
	Establer_Numero bufferFecha, ch  		;ESTABLECIENDO UN NUMERO PARA HORA
	mov bufferFecha[si],3ah 				;HEXA DE :
	inc si
	Establer_Numero bufferFecha, cl 		;ESTABLECIENDO UN NUMERO PARA MINUTOS

POP si
POP dx
POP cx
POP bx
POP ax
endm

Establer_Numero macro bufferFecha, registro
PUSH ax
PUSH bx
	xor ax,ax
	xor bx,bx	;PASO MI REGISTRO PARA DIVIDIR
	mov bl,0ah
	mov al,registro
	div bl

	 Obtener_Numero bufferFecha, al 	;PRIMERO EL CONCIENTE
	 Obtener_Numero bufferFecha, ah 	;SEGUNDO EL MODULO

POP bx
POP ax
endm

Obtener_Numero macro bufferFecha, registro
LOCAL cero,uno,dos,tres,cuatro,cinco,seis,siete,ocho,nueve,Salir
	cmp registro , 00h
	je cero
	cmp registro, 01h
	je uno
	cmp registro, 02h
	je dos
	cmp registro, 03h
	je tres
	cmp registro, 04h
	je cuatro
	cmp registro, 05h
	je cinco
	cmp registro, 06h
	je seis
	cmp registro, 07h
	je siete
	cmp registro, 08h
	je ocho
	cmp registro, 09h
	je nueve
	jmp Salir

	cero:
		mov bufferFecha[si],30h 	;0
		inc si
		jmp Salir
	uno:
		mov bufferFecha[si],31h 	;1
		inc si
		jmp Salir
	dos:
		mov bufferFecha[si],32h 	;2
		inc si
		jmp Salir
	tres:
		mov bufferFecha[si],33h 	;3
		inc si
		jmp Salir
	cuatro:
		mov bufferFecha[si],34h 	;4
		inc si
		jmp Salir
	cinco:
		mov bufferFecha[si],35h 	;5
		inc si
		jmp Salir
	seis:
		mov bufferFecha[si],36h 	;6
		inc si
		jmp Salir
	siete:
		mov bufferFecha[si],37h 	;7
		inc si
		jmp Salir
	ocho:
		mov bufferFecha[si],38h 	;8
		inc si
		jmp Salir
	nueve:
		mov bufferFecha[si],39h 	;9
		inc si
		jmp Salir
	Salir:
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPARAR STRINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Comparar macro String1, String2
	LOCAL ContinuarLoop, InicioLoop, FinLoop, Contadores, NoIguales, Final
	xor si,si
	mov cx,4
	InicioLoop:	
	mov al, String1[si]
	mov dl, String2[si]
	cmp String1[si],24h
	je FinLoop
	cmp String2[si],24h
	je FinLoop
	cmp al,dl
	jne NoIguales
	cmp al,dl
	je ContinuarLoop
	jmp FinLoop
	ContinuarLoop:
	inc si
	dec cx
	cmp cx,0001b
    ja InicioLoop
	jmp FinLoop
	FinLoop:
	cmp al,dl
	jmp Final

	NoIguales:
	mov al,0
	mov dl,1
	cmp al,dl

	Final:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LIMPIAR PANTALLA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear_Screen macro
	mov ax,03h
    int 10h
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LIMPIAR ARREGLO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LimpiarBuffer macro buffer, NoBytes, Char
	LOCAL Repetir
	xor si,si
	xor cx,cx
	mov cx,NoBytes
	Repetir:
	mov buffer[si], Char
	inc si
	loop Repetir
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%% OBTNER UN CARACTER DEL TECLADO CON ECHO %%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getChar macro
	mov ah,01h
	int 21h
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%% OBTENER UN CARACTER DEL TECLADO SIN ECHO %%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getCharSE macro
	mov ah,08h
	int 21h
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% OBTENER TEXTO DEL TECLADO %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ObtenerTexto macro buffer
LOCAL ObtenerChar, FinOT
xor si, si
ObtenerChar:
getChar
cmp al, 0dh
je FinOT
mov buffer[si],al
inc si
jmp ObtenerChar
FinOT:
mov al,24h
mov buffer[si],al
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% OBTENER RUTA DEL TECLADO %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ObtenerRuta macro buffer
LOCAL ObtenerChar, FinOT
xor si, si
ObtenerChar:
getChar
cmp al, 0dh
je FinOT
mov buffer[si],al
inc si
jmp ObtenerChar
FinOT:
mov al,00h
mov buffer[si],al
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% ABRIR ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AbrirArchivo macro buffer, handler
mov ah,3dh
mov al,02h
lea dx,buffer
int 21h
jc Error_Abrir
mov handler,ax
jmp ContinuarLeer
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% CERRAR ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CerrarArchivo macro handler
mov ah,3eh
mov bx, handler
int 21h
jc Error_Cerrar
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% LEER ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

LeerArchivo macro handler, buffer, NoBytes
mov ah,3fh
mov bx,handler
mov cx,NoBytes
lea dx,buffer
int 21h
jc Error_Leer
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% CREAR ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CrearArchivo macro buffer, handler
mov ah,3ch
mov cx,00h
lea dx,buffer
int 21h
jc Error_Crear
mov handler,ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% ESCRIBIR ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EscribirArchivo macro handler, buffer, NoBytes
mov ah,40h
mov bx,handler
mov cx,NoBytes
lea dx,buffer
int 21h
jc Error_Escritura
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%% CONVERTIR ASCII A NUMERO %%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AsciiToNum macro numero
LOCAL INICIO, FIN
xor ax,ax
xor bx,bx
xor cx,cx
mov bx,10
xor si,si
INICIO:
	mov cl,numero[si]
	cmp cl,48
	jl FIN
	cmp cl,57
	jg FIN
	inc si
	sub cl,48
	mul bx
	add ax,cx
	jmp INICIO
FIN:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONVERTIR NUMERO A ASCII %%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ConvertirString macro buffer
LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN
LimpiarBuffer buffer, SIZEOF buffer, 24h
xor si,si
xor cx,cx
xor bx,bx
xor dx,dx
mov dl,0ah
test ax,1000000000000000	
jnz NEGATIVO
jmp Dividir2

NEGATIVO:
	neg ax
	mov buffer[si],45
	inc si
	jmp Dividir2
Dividir:
	xor ah,ah
Dividir2:
	div dl
	inc cx
	push ax
	cmp al,00h
	je FinCr3
	jmp Dividir
FinCr3:
	pop ax
	add ah,30h
	mov buffer[si],ah
	inc si
	loop FinCr3
	mov ah,24h
	mov buffer[si],ah
	inc si
FIN:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OBTENER NUMERO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getNumero macro buffer
LOCAL INICIO, FIN
xor si,si
INICIO:
	getChar
	cmp al,0dh
	je FIN
	mov buffer[si],al
	inc si
	jmp INICIO
FIN:
	mov buffer[si],00h	
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REEMPLAZAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Reemplazar macro arreglo, char1, char2, inicio, fin
LOCAL SeguirReemplazando, HacerReemplazo, Incremento
xor dx,dx
mov dl,char1
xor ax,ax
mov al,char2
xor di,di
mov di,inicio
SeguirReemplazando:
mov ah,arreglo[di]
cmp ah,dl
je HacerReemplazo
jmp Incremento
HacerReemplazo:
mov arreglo[di],00h
Incremento:
inc di
mov cx,fin
cmp di, cx
jb SeguirReemplazando
endm



;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INICIAR MODO VIDEO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

InicioVideo macro
mov ax,0013h
int 10h
mov ax, 0A000h
mov es, ax  ; es = A000h (memoria de graficos).
endm



;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DIBUJAR UN PIXEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pixel macro x0, y0, color
push cx
mov ah,0ch
mov al,color
mov bh,0h
mov dx,y0
mov cx,x0
int 10h
pop cx
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% PAUSA PARA SALIR DE VIDEO %%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PausaSalir macro
mov ah,00h
int 16h
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%% REGRESAR A MODO TEXTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RegresarATexto macro
mov ah,00h
mov al,03h
int 10h
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% OBTENER TAMAÑO DE UN STRING %%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getSize macro buffer, Char, NoBytes
LOCAL Comparar, Aumentar, FinGetSize
xor si,si
Comparar:
cmp buffer[si],Char
jne Aumentar
jmp FinGetSize

Aumentar:
inc si
cmp si,NoBytes
jb Comparar


FinGetSize:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COPIAR ARREGLO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CopiarArreglo macro BufferFuente, BufferDestino, Start, Finish
LOCAL Copiar
LimpiarBuffer BufferDestino, SIZEOF BufferDestino,24h
mov si, Start
mov cx,Finish
xor di,di
Copiar:
mov al,BufferFuente[si]
mov BufferDestino[di],al
inc si
inc di
cmp si,cx
jb Copiar
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COPIAR ARREGLO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CopiarArregloFile macro BufferFuente, BufferDestino, Start, Finish
LOCAL Copiar
LimpiarBuffer BufferDestino, SIZEOF BufferDestino,00h
mov si, Start
mov cx,Finish
xor di,di
Copiar:
mov al,BufferFuente[si]
mov BufferDestino[di],al
inc si
inc di
cmp si,cx
jb Copiar
endm



;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOGGEAR USUARIO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

LoggearUsuario macro
LOCAL SeguirComparando, ValidarPass,Loggear,Incremento
xor dx,dx
mov bx,offset Usuarios
SeguirComparando:
Comparar [bx].Usuario.Username, arregloID
je ValidarPass
Incremento:
add bx,SIZEOF Usuario
inc dx
cmp dx, TotalUsuarios
jbe SeguirComparando
jmp Error_Ingreso
ValidarPass:
Comparar [bx].Usuario.Password, arregloPASS
je Loggear
jmp Incremento
Loggear:
mov UsuarioAux,bx
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%% ORDENAMIENTO BURBUJA ASC %%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BurbujaAsc macro buffer, cadena
LOCAL PrimerFor, SegundoFor, Intercambio,NoIntercambio
mov Segundos,0
mov cx, TotalUsuarios
mov Contador3,cx
dec Contador3
PrimerFor:
GraficarArreglo buffer, cadena
inc Segundos
mov si,0
mov di,1
mov cx, TotalUsuarios
mov Contador4,cx
dec Contador4
SegundoFor:
mov al,buffer[si]
mov dl,buffer[di]
cmp al,dl
ja Intercambio
jmp NoIntercambio
Intercambio:
mov buffer[si],dl
mov buffer[di],al
NoIntercambio:
inc si
inc di
dec Contador4
mov cx,Contador4
cmp cx,0
ja SegundoFor
dec Contador3
mov cx,Contador3
cmp cx,0
ja PrimerFor
GraficarArreglo buffer, cadena
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%% ORDENAMIENTO BURBUJA DESC %%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BurbujaDec macro buffer, cadena
LOCAL PrimerFor, SegundoFor, Intercambio,NoIntercambio
mov Segundos,0
mov cx, TotalUsuarios
mov Contador3,cx
dec Contador3
PrimerFor:
GraficarArreglo buffer, cadena
inc Segundos
mov si,0
mov di,1
mov cx, TotalUsuarios
mov Contador4,cx
dec Contador4
SegundoFor:
mov al,buffer[si]
mov dl,buffer[di]
cmp al,dl
jb Intercambio
jmp NoIntercambio
Intercambio:
mov buffer[si],dl
mov buffer[di],al
NoIntercambio:
inc si
inc di
dec Contador4
mov cx,Contador4
cmp cx,0
ja SegundoFor
dec Contador3
mov cx,Contador3
cmp cx,0
ja PrimerFor
GraficarArreglo buffer, cadena
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PINTAR FONDO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PintarFondo macro color
LOCAL PrimerFor, SegundoFor
mov dl,color
mov cx,0
mov bx,0
SegundoFor:
mov di,cx
xor si,si
PrimerFor:
mov es:[di],dl
inc di
inc si
cmp si,320
jne PrimerFor
add cx,320
inc bx
cmp bx,178
jbe SegundoFor
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PINTAR CARRO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PintarCarro macro color
LOCAL PrimerFor, SegundoFor
mov dl,color
mov bx,54400
add bx,ColumnaCarro
mov cx,0
SegundoFor:
mov di,bx
xor si,si
PrimerFor:
mov es:[di],dl
inc di
inc si
cmp si,20
jne PrimerFor
add bx,320
inc cx
cmp cx,25
jbe SegundoFor
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% JUEGO SIN NIVELES  %%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

JuegoSN macro
LOCAL Reload, SumarColumna, RestarColumna, SalirJuego, Sumar, Restar, CompararValores, ReemplazarP, ReemplazarT, ContinuarExit, Pausa
mov ColumnaCarro, 10101010b
PintarEncabezadoJuego
mov PuntajeAux,0
mov TiempoAux,0
Reload:
PintarEncabezadoJuego
PintarCarro ColorCarro
getCharSE
	cmp al,4dh			;derecha
	je SumarColumna
	cmp al,4bh			;izquierda
    je RestarColumna
    cmp al,1bh			;ESC
    je Pausa
	jmp Reload

SumarColumna:
	mov ax, ColumnaCarro
	cmp ax,300
	jb Sumar
	jmp Reload

Sumar:
	inc PuntajeAux
	inc TiempoAux
	PintarEncabezadoJuego
	PintarCarro 0d
	mov ax,ColumnaCarro
	add ax,5
	mov ColumnaCarro,ax
	jmp Reload

RestarColumna:
	mov ax,ColumnaCarro
	cmp ax,0
	ja Restar	
	jmp Reload

Restar:
	PintarEncabezadoJuego
	PintarCarro 0d
	mov ax,ColumnaCarro
	sub ax,5
	mov ColumnaCarro,ax
	jmp Reload


Pausa:
mov dl, 0; Column
mov dh, 0 ; Row
mov bx, 0 ; Page number, 0 for graphics modes
mov ah, 2h
int 10h
mov ah, 09h
mov al, SPVar 
mov bh, 00h
mov bl, 15d
mov cx, 40d
int 10h
mov dl, 0; Column
mov dh, 0 ; Row
mov bx, 0 ; Page number, 0 for graphics modes
mov ah, 2h
int 10h
print titulo_pausa
getCharSE
cmp al,1bh			;ESC
je Reload
cmp al,20h			;SPACEBAR
je CompararValores
jmp Pausa


ReemplazarP:
mov [bx].Usuario.Punteo,cl
jmp ContinuarExit

ReemplazarT:
mov [bx].Usuario.Tiempo,cl
jmp SalirJuego

CompararValores:
mov bx,UsuarioAux
mov al,[bx].Usuario.Punteo
mov cl,PuntajeAux
cmp al,cl
jl ReemplazarP
ContinuarExit:
mov al,[bx].Usuario.Tiempo
mov cl,TiempoAux
cmp al,cl
jl ReemplazarT

SalirJuego:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%% OBTENER PUNTUACIONES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ObtenerPuntuaciones macro
LOCAL SeguirCopiando
xor dx,dx
xor si,si
mov bx, offset Usuarios
SeguirCopiando:
mov al,[bx].Usuario.Punteo
mov Valores[si],al
add bx,SIZEOF Usuario
inc dx
inc si
cmp dx,TotalUsuarios
jbe SeguirCopiando
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OBTENER TIEMPOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ObtenerTiempos macro
LOCAL SeguirCopiando
xor dx,dx
xor si,si
mov bx, offset Usuarios
SeguirCopiando:
mov al,[bx].Usuario.Tiempo
mov Valores[si],al
add bx,SIZEOF Usuario
inc dx
inc si
cmp dx,TotalUsuarios
jbe SeguirCopiando
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%% CONVERTIR A ASCII PARA ESCRIBIR EN ARCHIVO %%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DecToFile macro NumeroDec
    push ax     
    mov ax,NumeroDec
    call ConvertirNum
    pop ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% CONVERTIR A ASCII PARA IMPRIMIR %%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DecToPrint macro NumeroDec
    push ax     
    mov ax,NumeroDec
    call ConvertirPrint
    pop ax
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%$ IMPRIMIR PUNTUACIONES %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ImprimirPuntuaciones macro
LOCAL Imprimir, SeguirCopiando, OrdenarAntes, SeguirImpresion, SegundaValidacion, SeguirImprimiendo, SalirImp
mov dx,TotalUsuarios
cmp dx,0
ja Imprimir
print NoUsuarios
getCharSE
jmp SesionAdmin
Imprimir:
mov dx,TotalUsuarios
cmp dx,1
ja OrdenarAntes
xor dx,dx
mov bx,offset UsuariosAux
mov dl,[bx].Usuario.Punteo
mov ValorMax,dx
jmp SeguirImpresion
OrdenarAntes:
OrdenarUsuariosPunteo
SeguirImpresion:
print columnas_puntos
print salto
mov intCont,1
mov bx,offset UsuariosAux
mov OFFSETAux,bx
print salto
SeguirImprimiendo:
DecToPrint intCont
print espacio
print NumPrint
print punto
print espacio
mov bx,OFFSETAux
CopiarArreglo [bx].Usuario.Username, IDAux, 0, 10
print IDAux
print tabulacion
print tabulacion
xor ax,ax
mov al,[bx].Usuario.Nivel
mov NumeroAux,ax
DecToPrint NumeroAux
print NumPrint
print tabulacion
print tabulacion
xor ax,ax
mov al,[bx].Usuario.Punteo
mov NumeroAux,ax
DecToPrint NumeroAux
print NumPrint
print salto
add bx,SIZEOF Usuario
mov OFFSETAux,bx
inc intCont
mov cx,intCont
cmp cx,TotalUsuarios
jbe SegundaValidacion
jmp SalirImp
SegundaValidacion:
cmp cx,10
jbe SeguirImprimiendo
SalirImp:
ReportePuntos
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%$ IMPRIMIR TIEMPOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ImprimirTiempos macro
LOCAL Imprimir, SeguirCopiando, OrdenarAntes, SeguirImpresion, SegundaValidacion, SeguirImprimiendo, SalirImp
mov dx,TotalUsuarios
cmp dx,0
ja Imprimir
print NoUsuarios
getCharSE
jmp SesionAdmin
Imprimir:
mov dx,TotalUsuarios
cmp dx,1
ja OrdenarAntes
xor dx,dx
mov bx,offset UsuariosAux
mov dl,[bx].Usuario.Tiempo
mov ValorMax,dx
jmp SeguirImpresion
OrdenarAntes:
OrdenarUsuariosTiempo
SeguirImpresion:
print columnas_tiempo
print salto
mov intCont,1
mov bx,offset UsuariosAux
mov OFFSETAux,bx
print salto
SeguirImprimiendo:
DecToPrint intCont
print espacio
print NumPrint
print punto
print espacio
mov bx,OFFSETAux
CopiarArreglo [bx].Usuario.Username, IDAux, 0, 10
print IDAux
print tabulacion
print tabulacion
xor ax,ax
mov al,[bx].Usuario.Nivel
mov NumeroAux,ax
DecToPrint NumeroAux
print NumPrint
print tabulacion
print tabulacion
xor ax,ax
mov al,[bx].Usuario.Tiempo
mov NumeroAux,ax
DecToPrint NumeroAux
print NumPrint
print salto
add bx,SIZEOF Usuario
mov OFFSETAux,bx
inc intCont
mov cx,intCont
cmp cx,TotalUsuarios
jbe SegundaValidacion
jmp SalirImp
SegundaValidacion:
cmp cx,10
jbe SeguirImprimiendo
SalirImp:
ReporteTiempo
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%% NUMERO RANDOM (0,LimiteSuperior) %%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

obtenerRandom macro LimiteSuperior
        mov ax,LimiteSuperior
        push ax
        call Random
endm 


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Duplicar Usuarios %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DuplicarUsuarios macro
LOCAL SeguirDuplicando, Copiar, Copiar2
xor dx,dx
mov di, offset Usuarios ;Arreglo original.
mov si, offset UsuariosAux ;Copia del arreglo que será ordenado.
SeguirDuplicando:
	xor bx,bx
	Copiar:
	mov al,[di].Usuario.Username[bx]
	mov [si].Usuario.Username[bx],al
	inc bx
	cmp bx,10
	jb Copiar
	xor bx,bx
	Copiar2:
	mov al,[di].Usuario.Password[bx]
	mov [si].Usuario.Password[bx],al
	inc bx
	cmp bx,10
	jb Copiar2
	mov al,[di].Usuario.Punteo
	mov [si].Usuario.Punteo,al
	mov al,[di].Usuario.Tiempo
	mov [si].Usuario.Tiempo ,al
	mov al,[di].Usuario.Nivel
	mov [si].Usuario.Nivel,al
add di,SIZEOF Usuario
add si,SIZEOF Usuario
inc dx
cmp dx,TotalUsuarios
jbe SeguirDuplicando
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%% ORDENAMIENTO USUARIOS  PUNTOS %%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

OrdenarUsuariosPunteo macro
LOCAL PrimerFor, SegundoFor, Intercambio,NoIntercambio, Copiar, Copiar2, Copiar3, Copiar4, Copiar5, Copiar6
xor ax,ax
xor dx,dx
mov cx, TotalUsuarios
mov Contador1,cx
dec Contador1
PrimerFor:
mov di,offset UsuariosAux ;(j)
mov si,offset UsuariosAux
add si,SIZEOF Usuario    ; (j+1)
mov cx, TotalUsuarios
mov Contador2,cx
dec Contador2
SegundoFor:
mov al,[di].Usuario.Punteo 
mov dl,[si].Usuario.Punteo
cmp al,dl
jb Intercambio
jmp NoIntercambio
Intercambio:
	; aux = arreglo[j] 
	mov OFFSETAux,si ; guardamos Temporalmente el (offset) 
	mov si,offset UAuxiliar ; si se convierte en el apuntador al Usuario Auxiliar
	xor bx,bx
	Copiar:
		mov al,[di].Usuario.Username[bx]
		mov [si].Usuario.Username[bx],al
		inc bx
		cmp bx,10
		jb Copiar
	xor bx,bx
	Copiar2:
		mov al,[di].Usuario.Password[bx]
		mov [si].Usuario.Password[bx],al
		inc bx
		cmp bx,10
		jb Copiar2
	mov al,[di].Usuario.Punteo
	mov [si].Usuario.Punteo,al
	mov al,[di].Usuario.Tiempo
	mov [si].Usuario.Tiempo ,al
	mov al,[di].Usuario.Nivel
	mov [si].Usuario.Nivel,al
	mov si, OFFSETAux ;Regresamos el offset (j+1) original a si
	; aux[j] = arreglo[j+1] 
	xor bx,bx
	Copiar3:
		mov al,[si].Usuario.Username[bx]
		mov [di].Usuario.Username[bx],al
		inc bx
		cmp bx,10
		jb Copiar3
	xor bx,bx
	Copiar4:
		mov al,[si].Usuario.Password[bx]
		mov [di].Usuario.Password[bx],al
		inc bx
		cmp bx,10
		jb Copiar4
	mov al,[si].Usuario.Punteo
	mov [di].Usuario.Punteo,al
	mov al,[si].Usuario.Tiempo
	mov [di].Usuario.Tiempo ,al
	mov al,[si].Usuario.Nivel
	mov [di].Usuario.Nivel,al
	; aux[j+1] = aux 
	mov OFFSETAux,di ; guardamos Temporalmente el (offset) 
	mov di,offset UAuxiliar ; di se convierte en el apuntador al Usuario Auxiliar
	xor bx,bx
	Copiar5:
		mov al,[di].Usuario.Username[bx]
		mov [si].Usuario.Username[bx],al
		inc bx
		cmp bx,10
		jb Copiar5
	xor bx,bx
	Copiar6:
		mov al,[di].Usuario.Password[bx]
		mov [si].Usuario.Password[bx],al
		inc bx
		cmp bx,10
	jb Copiar6
	mov al,[di].Usuario.Punteo
	mov [si].Usuario.Punteo,al
	mov al,[di].Usuario.Tiempo
	mov [si].Usuario.Tiempo ,al
	mov al,[di].Usuario.Nivel
	mov [si].Usuario.Nivel,al
	mov di, OFFSETAux ;Regresamos el offset (j) original a di
NoIntercambio:
add di,SIZEOF Usuario
add si,SIZEOF Usuario
dec Contador2
mov cx,Contador2
cmp cx,0
ja SegundoFor
dec Contador1
mov cx,Contador1
cmp cx,0
ja PrimerFor
xor dx,dx
mov bx,offset UsuariosAux
mov dl,[bx].Usuario.Punteo
mov ValorMax,dx
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%% ORDENAMIENTO USUARIOS TIEMPO %%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

OrdenarUsuariosTiempo macro
LOCAL PrimerFor, SegundoFor, Intercambio,NoIntercambio, Copiar, Copiar2, Copiar3, Copiar4, Copiar5, Copiar6
xor ax,ax
xor dx,dx
mov cx, TotalUsuarios
mov Contador1,cx
dec Contador1
PrimerFor:
mov di,offset UsuariosAux ;(j)
mov si,offset UsuariosAux
add si,SIZEOF Usuario    ; (j+1)
mov cx, TotalUsuarios
mov Contador2,cx
dec Contador2
SegundoFor:
mov al,[di].Usuario.Tiempo 
mov dl,[si].Usuario.Tiempo
cmp al,dl
jb Intercambio
jmp NoIntercambio
Intercambio:
	; aux = arreglo[j] 
	mov OFFSETAux,si ; guardamos Temporalmente el (offset) 
	mov si,offset UAuxiliar ; si se convierte en el apuntador al Usuario Auxiliar
	xor bx,bx
	Copiar:
		mov al,[di].Usuario.Username[bx]
		mov [si].Usuario.Username[bx],al
		inc bx
		cmp bx,10
		jb Copiar
	xor bx,bx
	Copiar2:
		mov al,[di].Usuario.Password[bx]
		mov [si].Usuario.Password[bx],al
		inc bx
		cmp bx,10
		jb Copiar2
	mov al,[di].Usuario.Punteo
	mov [si].Usuario.Punteo,al
	mov al,[di].Usuario.Tiempo
	mov [si].Usuario.Tiempo ,al
	mov al,[di].Usuario.Nivel
	mov [si].Usuario.Nivel,al
	mov si, OFFSETAux ;Regresamos el offset (j+1) original a si
	; aux[j] = arreglo[j+1] 
	xor bx,bx
	Copiar3:
		mov al,[si].Usuario.Username[bx]
		mov [di].Usuario.Username[bx],al
		inc bx
		cmp bx,10
		jb Copiar3
	xor bx,bx
	Copiar4:
		mov al,[si].Usuario.Password[bx]
		mov [di].Usuario.Password[bx],al
		inc bx
		cmp bx,10
		jb Copiar4
	mov al,[si].Usuario.Punteo
	mov [di].Usuario.Punteo,al
	mov al,[si].Usuario.Tiempo
	mov [di].Usuario.Tiempo ,al
	mov al,[si].Usuario.Nivel
	mov [di].Usuario.Nivel,al
	; aux[j+1] = aux 
	mov OFFSETAux,di ; guardamos Temporalmente el (offset) 
	mov di,offset UAuxiliar ; di se convierte en el apuntador al Usuario Auxiliar
	xor bx,bx
	Copiar5:
		mov al,[di].Usuario.Username[bx]
		mov [si].Usuario.Username[bx],al
		inc bx
		cmp bx,10
		jb Copiar5
	xor bx,bx
	Copiar6:
		mov al,[di].Usuario.Password[bx]
		mov [si].Usuario.Password[bx],al
		inc bx
		cmp bx,10
	jb Copiar6
	mov al,[di].Usuario.Punteo
	mov [si].Usuario.Punteo,al
	mov al,[di].Usuario.Tiempo
	mov [si].Usuario.Tiempo ,al
	mov al,[di].Usuario.Nivel
	mov [si].Usuario.Nivel,al
	mov di, OFFSETAux ;Regresamos el offset (j) original a di
NoIntercambio:
add di,SIZEOF Usuario
add si,SIZEOF Usuario
dec Contador2
mov cx,Contador2
cmp cx,0
ja SegundoFor
dec Contador1
mov cx,Contador1
cmp cx,0
ja PrimerFor
xor dx,dx
mov bx,offset UsuariosAux
mov dl,[bx].Usuario.Tiempo
mov ValorMax,dx
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CREAR REPORTE PUNTOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ReportePuntos macro
LOCAL SeguirImprimiendo, SegundaValidacion, SalirRPuntos
	CrearArchivo bufferPuntos, handlerPuntos
	EscribirArchivo handlerPuntos, EncabezadoReporte, SIZEOF EncabezadoReporte
	EscribirArchivo handlerPuntos, TReporte, SIZEOF TReporte
	EscribirArchivo handlerPuntos, R_TPuntos, SIZEOF R_TPuntos
	EscribirArchivo handlerPuntos, Rcolumnas_puntos, SIZEOF Rcolumnas_puntos
	mov intCont,1
	mov bx,offset UsuariosAux
	mov OFFSETAux,bx
	SeguirImprimiendo:
		DecToFile intCont
		EscribirArchivo handlerPuntos, REspacio, SIZEOF REspacio
		getSize Num, 00h, SIZEOF Num
		mov StringSize,si
		EscribirArchivo handlerPuntos, Num, StringSize
		EscribirArchivo handlerPuntos, RPunto, SIZEOF RPunto
		EscribirArchivo handlerPuntos, REspacio, SIZEOF REspacio
		mov bx,OFFSETAux
		CopiarArreglo [bx].Usuario.Username, IDAux, 0, 10
	 	Reemplazar IDAux, 24h,20h,0, SIZEOF IDAux
		EscribirArchivo handlerPuntos, IDAux, SIZEOF IDAux
		EscribirArchivo handlerPuntos, RTabulacion, SIZEOF RTabulacion
		mov bx,OFFSETAux
		xor ax,ax
		mov al,[bx].Usuario.Nivel
		mov NumeroAux,ax
		DecToFile NumeroAux
		getSize Num, 00h, SIZEOF Num
		mov StringSize,si
		EscribirArchivo handlerPuntos, Num, StringSize
		EscribirArchivo handlerPuntos, RTabulacion, SIZEOF RTabulacion
		mov bx,OFFSETAux
		xor ax,ax
		mov al,[bx].Usuario.Punteo
		mov NumeroAux,ax
		DecToFile NumeroAux
		getSize Num, 00h, SIZEOF Num
		mov StringSize,si
		EscribirArchivo handlerPuntos, Num, StringSize
		EscribirArchivo handlerPuntos, RSalto, SIZEOF RSalto
	mov bx,OFFSETAux	
	add bx,SIZEOF Usuario
	mov OFFSETAux,bx
	inc intCont
	mov cx,intCont
	cmp cx,TotalUsuarios
	jbe SegundaValidacion
	jmp SalirRPuntos
	SegundaValidacion:
	cmp cx,10
	jbe SeguirImprimiendo
	SalirRPuntos:
	CerrarArchivo handlerPuntos
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CREAR REPORTE TIEMPO %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ReporteTiempo macro
LOCAL SeguirImprimiendo, SegundaValidacion, SalirRTiempo
	CrearArchivo bufferTiempo, handlerTiempo
	EscribirArchivo handlerTiempo, EncabezadoReporte, SIZEOF EncabezadoReporte
	EscribirArchivo handlerTiempo, TReporte, SIZEOF TReporte
	EscribirArchivo handlerTiempo, R_TTiempo, SIZEOF R_TTiempo
	EscribirArchivo handlerTiempo, Rcolumnas_tiempo, SIZEOF Rcolumnas_tiempo
	mov intCont,1
	mov bx,offset UsuariosAux
	mov OFFSETAux,bx
	SeguirImprimiendo:
		DecToFile intCont
		EscribirArchivo handlerTiempo, REspacio, SIZEOF REspacio
		getSize Num, 00h, SIZEOF Num
		mov StringSize,si
		EscribirArchivo handlerTiempo, Num, StringSize
		EscribirArchivo handlerTiempo, RPunto, SIZEOF RPunto
		EscribirArchivo handlerTiempo, REspacio, SIZEOF REspacio
		mov bx,OFFSETAux
		CopiarArreglo [bx].Usuario.Username, IDAux, 0, 10
	 	Reemplazar IDAux, 24h,20h,0, SIZEOF IDAux
		EscribirArchivo handlerTiempo, IDAux, SIZEOF IDAux
		EscribirArchivo handlerTiempo, RTabulacion, SIZEOF RTabulacion
		mov bx,OFFSETAux
		xor ax,ax
		mov al,[bx].Usuario.Nivel
		mov NumeroAux,ax
		DecToFile NumeroAux
		getSize Num, 00h, SIZEOF Num
		mov StringSize,si
		EscribirArchivo handlerTiempo, Num, StringSize
		EscribirArchivo handlerTiempo, RTabulacion, SIZEOF RTabulacion
		mov bx,OFFSETAux
		xor ax,ax
		mov al,[bx].Usuario.Tiempo
		mov NumeroAux,ax
		DecToFile NumeroAux
		getSize Num, 00h, SIZEOF Num
		mov StringSize,si
		EscribirArchivo handlerTiempo, Num, StringSize
		EscribirArchivo handlerTiempo, RSalto, SIZEOF RSalto
	mov bx,OFFSETAux	
	add bx,SIZEOF Usuario
	mov OFFSETAux,bx
	inc intCont
	mov cx,intCont
	cmp cx,TotalUsuarios
	jbe SegundaValidacion
	jmp SalirRTiempo
	SegundaValidacion:
	cmp cx,10
	jbe SeguirImprimiendo
	SalirRTiempo:
	CerrarArchivo handlerTiempo
endm




;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SETEAR VELOCIDAD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetearVelocidad macro
LOCAL AsignacionV, Asignar0, Asignar1, Asignar2, Asignar3, Asignar4, Asignar5, Asignar6, Asignar7, Asignar8, Asignar9, Fin
AsignacionV:
clear_Screen
print titulo_velocidad
print salto
print salto
print ingreseVelocidad
getChar
	cmp al,30h			;0
	je Asignar0
	cmp al,31h			;1
	je Asignar1
	cmp al,32h			;2
    je Asignar2
	cmp al,33h			;3
	je Asignar3
	cmp al,34h			;4
    je Asignar4
    cmp al,35h			;5
	je Asignar5
	cmp al,36h			;6
    je Asignar6
	cmp al,37h			;7
    je Asignar7
	cmp al,38h			;8
    je Asignar8
	cmp al,39h			;9
    je Asignar9
	print salto
	print salto
	print valor_invalido
	getCharSE
	jmp AsignacionV

Asignar0:
	mov Velocidad,0
	print salto
	print salto
	print  asigTerminada
	getCharSE
	jmp Fin

Asignar1:
	mov Velocidad,1
	print salto
	print salto
	print  asigTerminada
	getCharSE
	jmp Fin

Asignar2:
	mov Velocidad,2
	print salto
	print salto
	print  asigTerminada
	getCharSE
	jmp Fin

Asignar3:
	mov Velocidad,3	
	print salto
	print salto
	print  asigTerminada
	getCharSE
	jmp Fin

Asignar4:
	mov Velocidad,4
	print salto
	print salto
	print  asigTerminada
	getCharSE
	jmp Fin

Asignar5:
	mov Velocidad,5
	print salto
	print salto
	print  asigTerminada
	getCharSE
	jmp Fin

Asignar6:
	mov Velocidad,6
	print salto
	print salto
	print  asigTerminada
	getCharSE
	jmp Fin

Asignar7:
	mov Velocidad,7
	print salto
	print salto
	print  asigTerminada
	getCharSE
	jmp Fin

Asignar8:
	mov Velocidad,8
	print salto
	print salto
	print  asigTerminada
	getCharSE
	jmp Fin

Asignar9:
	mov Velocidad,9
	print salto
	print salto
	print  asigTerminada
	getCharSE

Fin:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SETEAR DELAY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetearDelay macro
mov ax,1100100000b
mov bx,Velocidad
mul bx
add ax,1100100000b
mov ValorDelay,ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SETEAR ANCHO DE BARRA %%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetearAncho macro
mov ax,TotalUsuarios
dec ax
mov bx,5
mul bx
mov bx,ax
mov ax,100101011b ;299
sub ax,bx
xor dx,dx
mov bx,TotalUsuarios
div bx
mov AnchoBarra,ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ASIGNAR ALTURA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AsignarAltura macro Puntaje
mov ax,Puntaje
mov bx,AlturaMax
mul bx
xor dx,dx
mov bx,ValorMax
div bx
mov AlturaAux,ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ASIGNAR COLOR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AsignarColorYHz macro Puntaje
LOCAL FinAsignacion, AsignarRojo, AsignarAzul, AsignarAmarillo, AsignarVerde
mov ax,Puntaje
cmp ax,20d
jbe AsignarRojo
cmp ax,40d
jbe AsignarAzul
cmp ax,60d
jbe AsignarAmarillo
cmp ax,80d
jbe AsignarVerde
mov ColorAux,15d ; Color Blanco
mov HzAux,1207d
jmp FinAsignacion
AsignarRojo:
	mov ColorAux,4d ;Color Rojo
	mov HzAux,9121d
	jmp FinAsignacion
AsignarAzul:
	mov ColorAux,1d ;Color Azul
	mov HzAux,4063d
	jmp FinAsignacion
AsignarAmarillo:
	mov ColorAux,14d ;Color Amarillo
	mov HzAux,2280d
	jmp FinAsignacion
AsignarVerde:
	mov ColorAux,2d ; Color Verde
	mov HzAux,1715d
FinAsignacion:
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PINTAR MARGEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PintarMargen macro color
LOCAL PrimerLinea, SegundaLinea, TerceraLinea, CuartaLinea
mov dl,color
mov di,8010 ;inicio en la columna 10
mov cx,300
PrimerLinea:
mov es:[di],dl
inc di
Loop PrimerLinea
mov di,61450 ;inicio en la columna 10
mov cx,300
SegundaLinea:
mov es:[di],dl
inc di
Loop SegundaLinea
mov di,8010 ;inicio en la columna 10
mov cx,167
TerceraLinea:
mov es:[di],dl
add di,320
Loop TerceraLinea
mov di,8310 ;inicio en la columna 10
mov cx,168
CuartaLinea:
mov es:[di],dl
add di,320
Loop CuartaLinea
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PINTAR NUMEROS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PintarNumeros macro buffer
LOCAL SeguirImpresion
mov dl, 0; Column
mov dh, 22 ; Row
mov bx, 0 ; Page number, 0 for graphics modes
mov ah, 2h
int 10h
mov ah, 09h
mov al, SPVar 
mov bh, 00h
mov bh, 0d
mov cx, 40d
int 10h
mov dl, 0; Column
mov dh, 24 ; Row
mov bx, 0 ; Page number, 0 for graphics modes
mov ah, 2h
int 10h
mov ah, 09h
mov al, SPVar 
mov bh, 00h
mov bh, 0d
mov cx, 40d
int 10h
mov dl, 1; Column
mov dh, 23 ; Row
mov bx, 0 ; Page number, 0 for graphics modes
mov ah, 2h
int 10h
mov ah, 09h
mov al, SPVar 
mov bh, 00h
mov bh, 0d
mov cx, 39d
int 10h
xor dx,dx
mov ax,AnchoBarra
mov bx,8d
div bx
mov Separacion,al ; x
xor dx,dx
xor ax,ax
mov al,Separacion
mov bx,2d
div bx
mov Separacion2,al ; x/2
xor cx,cx
mov cl,1d
mov al,Separacion2
add cl,al
mov SeparacionAux,cl
mov Contador1,0
SeguirImpresion:
mov dl, SeparacionAux; Column
mov dh, 23 ; Row
mov bx, 0 ; Page number, 0 for graphics modes
mov ah, 2h
int 10h
xor cx,cx
mov si, Contador1
mov cl,buffer[si]
DecToPrint cx
print NumPrint
inc Contador1
mov cl, SeparacionAux
add cl,Separacion
inc cl
mov SeparacionAux,cl
mov dx,Contador1
cmp dx,TotalUsuarios
jb SeguirImpresion
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PINTAR TIEMPO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PintarTiempo macro
LOCAL SeguirImpresion
mov dl, 0; Column
mov dh, 1 ; Row
mov bx, 0 ; Page number, 0 for graphics modes
mov ah, 2h
int 10h
mov ah, 09h
mov al, SPVar 
mov bh, 00h
mov bh, 0d
mov cx, 40d
int 10h
mov dl, 0; Column
mov dh, 1 ; Row
mov bx, 0 ; Page number, 0 for graphics modes
mov ah, 2h
int 10h
print GTiempo
DecToPrint Segundos
print NumPrint
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GRAFICAR ARREGLO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GraficarArreglo macro buffer, cadena
LOCAL InicioGrafica, PrimerFor, SegundoFor, SeguirGraficando
SetearDelay
SetearAncho
PintarFondo 0d
mov dl, 0; Column
mov dh, 0 ; Row
mov bx, 0 ; Page number, 0 for graphics modes
mov ah, 2h
int 10h
InicioGrafica:
print cadena
print TVelocidad
DecToPrint Velocidad
print NumPrint
print salto
PintarTiempo
PintarNumeros buffer
PintarMargen 15d
mov Contador1,0
mov InicioBarra,57611d
SeguirGraficando:
xor cx,cx
mov si,Contador1
mov cl,buffer[si]
AsignarAltura cx
AsignarColorYHz cx
mov dl, ColorAux
mov bx,InicioBarra
mov cx,0
SegundoFor:
mov di,bx
xor si,si
PrimerFor:
mov es:[di],dl
inc di
inc si
cmp si,AnchoBarra
jne PrimerFor
sub bx,320
inc cx
cmp cx,AlturaAux
jbe SegundoFor
Sonido HzAux
Delay ValorDelay
mov ax,InicioBarra
mov bx,AnchoBarra
add ax,bx ;Sumamos el ancho de barra
add ax,5 ;Sumamos 5 pixeles para separar la siguiente barra
mov InicioBarra,ax
inc Contador1
mov dx,Contador1
cmp dx,TotalUsuarios
jb SeguirGraficando
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUICKSORT  ASC. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

QuickSortAsc macro buffer, cadena
LOCAL Do1, Do2, Do3, Verificar1, Verificar2, Incrementar, Decrementar, SegundoIF, FinSegundoIF, VDo2, VDo3, Pushear, Igualar, Cambio
mov Segundos,0
mov subArray,0
mov dx,0
mov cx,TotalUsuarios
dec cx
push dx ;izquierda
push cx ;derecha
Do1:
	pop cx
	pop dx
	mov right,cx
	mov left,dx
	dec subArray
	Do2:
		mov dx,left
		mov _left,dx
		mov dx,right
		mov _right,dx
		mov ax,left
		mov cx,right
		add ax,cx
		mov bx,2
		xor dx,dx
		div bx
		mov si,ax
		mov al,buffer[si]
		mov pivot,al
		Do3:
			jmp Verificar1
			Decrementar:
				dec _right
			Verificar1:
				mov al,pivot
				mov si,_right
				mov dl,buffer[si]
				cmp al,dl
				jl Decrementar
				jmp Verificar2
			Incrementar:
				inc _left
			Verificar2:
				mov al,pivot
				mov si,_left
				mov dl,buffer[si]
				cmp al,dl
				jg Incrementar
			;PrimerIF:
				mov ax,_left
				mov dx,_right
				cmp ax,dx
				jle SegundoIF
				jmp VDo3
			SegundoIF:
				cmp ax,dx
				jne Cambio
				jmp FinSegundoIF
				Cambio:
				mov si,_left
				mov di,_right
				mov al,buffer[si]
				mov dl,buffer[di]
				mov buffer[si],dl
				mov buffer[di],al
				FinSegundoIF:
				dec _right
				inc _left
			VDo3:
				mov ax,_right
				mov dx,_left
				cmp ax,dx
				jge Do3
	
	;TercerIF:
	mov ax,_left
	mov dx,right
	cmp ax,dx
	jl Pushear
	jmp Igualar
	Pushear:
	inc subArray
	mov dx,	_left
	mov cx, right
	push dx
	push cx
	Igualar:
	mov ax,_right
	mov right,ax
	VDo2:
		mov ax,left
		mov dx,right
		cmp ax,dx
		jl Do2
;VDo1
GraficarArreglo buffer, cadena
inc Segundos
mov ax,subArray
mov dx,1111111111111111b
cmp ax,dx
jg Do1
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUICKSORT DESC. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

QuickSortDesc macro buffer, cadena
LOCAL Do1, Do2, Do3, Verificar1, Verificar2, Incrementar, Decrementar, SegundoIF, FinSegundoIF, VDo2, VDo3, Pushear, Igualar, Cambio
mov Segundos,0
mov subArray,0
mov dx,0
mov cx,TotalUsuarios
dec cx
push dx ;izquierda
push cx ;derecha
Do1:
	pop cx
	pop dx
	mov right,cx
	mov left,dx
	dec subArray
	Do2:
		mov dx,left
		mov _left,dx
		mov dx,right
		mov _right,dx
		mov ax,left
		mov cx,right
		add ax,cx
		mov bx,2
		xor dx,dx
		div bx
		mov si,ax
		mov al,buffer[si]
		mov pivot,al
		Do3:
			jmp Verificar1
			Decrementar:
				dec _right
			Verificar1:
				mov al,pivot
				mov si,_right
				mov dl,buffer[si]
				cmp al,dl
				jg Decrementar
				jmp Verificar2
			Incrementar:
				inc _left
			Verificar2:
				mov al,pivot
				mov si,_left
				mov dl,buffer[si]
				cmp al,dl
				jl Incrementar
			;PrimerIF:
				mov ax,_left
				mov dx,_right
				cmp ax,dx
				jle SegundoIF
				jmp VDo3
			SegundoIF:
				cmp ax,dx
				jne Cambio
				jmp FinSegundoIF
				Cambio:
				mov si,_left
				mov di,_right
				mov al,buffer[si]
				mov dl,buffer[di]
				mov buffer[si],dl
				mov buffer[di],al
				FinSegundoIF:
				dec _right
				inc _left
			VDo3:
				mov ax,_right
				mov dx,_left
				cmp ax,dx
				jge Do3
	
	;TercerIF:
	mov ax,_left
	mov dx,right
	cmp ax,dx
	jl Pushear
	jmp Igualar
	Pushear:
	inc subArray
	mov dx,	_left
	mov cx, right
	push dx
	push cx
	Igualar:
	mov ax,_right
	mov right,ax
	VDo2:
		mov ax,left
		mov dx,right
		cmp ax,dx
		jl Do2
;VDo1
GraficarArreglo buffer, cadena
inc Segundos
mov ax,subArray
mov dx,1111111111111111b
cmp ax,dx
jg Do1
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SHELLSORT ASC. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ShellSortAsc macro buffer, cadena
LOCAL Validacion1, Validacion2, Validacion3, ContinuarShell, FORR, FinFOR, Intercambio, ValidarFor, SegundoIF, SetearCero, SetearMitad
mov Segundos,0
mov increment,3
jmp Validacion1
ContinuarShell:
	GraficarArreglo buffer, cadena
	inc Segundos
	mov ValorI,0
	jmp ValidarFor
	FORR:
		mov ax,ValorI
		mov ValorJ,ax
		mov si,ValorI
		mov cl,buffer[si]
		mov temp,cl
		jmp Validacion2
		Intercambio:
			mov ax,ValorJ
			mov dx,increment
			sub ax,dx
			mov si,ax
			mov di,ValorJ
			mov al,buffer[si]
			mov buffer[di],al
			mov ValorJ,si
		Validacion2:
		mov ax,ValorJ
		mov dx,increment
		cmp ax,dx
		jge Validacion3
		jmp FinFOR
		Validacion3:
		mov ax,ValorJ
		mov dx,increment
		sub ax,dx
		mov si,ax
		mov cl,buffer[si]
		mov dl,temp
		cmp cl,dl
		jg Intercambio
		FinFOR:
		mov si,ValorJ
		mov al,temp
		mov buffer[si],al
	inc ValorI
	ValidarFor:
	mov ax,ValorI
	mov dx,TotalUsuarios
	cmp ax,dx
	jl FORR

;IF
mov ax,increment
xor dx,dx
mov bx,2
div bx
cmp ax,0
jne SetearMitad
jmp SegundoIF
SetearMitad:
mov increment,ax
jmp Validacion1
SegundoIF:
mov ax,increment
cmp ax,1
je SetearCero
mov increment,1
jmp Validacion1
SetearCero:
mov increment,0
Validacion1:
	mov ax,increment
	cmp ax,0
	jg ContinuarShell
GraficarArreglo buffer, cadena
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SHELLSORT DESC. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ShellSortDesc macro buffer, cadena
LOCAL Validacion1, Validacion2, Validacion3, ContinuarShell, FORR, FinFOR, Intercambio, ValidarFor, SegundoIF, SetearCero, SetearMitad
mov Segundos,0
mov increment,3
jmp Validacion1
ContinuarShell:
	GraficarArreglo buffer, cadena
	inc Segundos
	mov ValorI,0
	jmp ValidarFor
	FORR:
		mov ax,ValorI
		mov ValorJ,ax
		mov si,ValorI
		mov cl,buffer[si]
		mov temp,cl
		jmp Validacion2
		Intercambio:
			mov ax,ValorJ
			mov dx,increment
			sub ax,dx
			mov si,ax
			mov di,ValorJ
			mov al,buffer[si]
			mov buffer[di],al
			mov ValorJ,si
		Validacion2:
		mov ax,ValorJ
		mov dx,increment
		cmp ax,dx
		jge Validacion3
		jmp FinFOR
		Validacion3:
		mov ax,ValorJ
		mov dx,increment
		sub ax,dx
		mov si,ax
		mov cl,buffer[si]
		mov dl,temp
		cmp cl,dl
		jl Intercambio
		FinFOR:
		mov si,ValorJ
		mov al,temp
		mov buffer[si],al
	inc ValorI
	ValidarFor:
	mov ax,ValorI
	mov dx,TotalUsuarios
	cmp ax,dx
	jl FORR

;IF
mov ax,increment
xor dx,dx
mov bx,2
div bx
cmp ax,0
jne SetearMitad
jmp SegundoIF
SetearMitad:
mov increment,ax
jmp Validacion1
SegundoIF:
mov ax,increment
cmp ax,1
je SetearCero
mov increment,1
jmp Validacion1
SetearCero:
mov increment,0
Validacion1:
	mov ax,increment
	cmp ax,0
	jg ContinuarShell
GraficarArreglo buffer, cadena
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%% PINTAR ENCABEZADO JUEGO %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PintarEncabezadoJuego macro
LOCAL PintarLinea
mov dl, 0; Column
mov dh, 0 ; Row
mov bx, 0 ; Page number, 0 for graphics modes
mov ah, 2h
int 10h
mov ah, 09h
mov al, SPVar 
mov bh, 00h
mov bl, 15d
mov cx, 40d
int 10h
mov dl, 0; Column
mov dh, 0 ; Row
mov bx, 0 ; Page number, 0 for graphics modes
mov ah, 2h
int 10h
print IDAux
print TNivel
xor cx,cx
mov cl,NivelGeneral
DecToPrint cx
print NumPrint
print EPuntos
xor cx,cx
mov cl,PuntajeAux
DecToPrint cx
print NumPrint
print ETiempo
mov di,3200
mov cx,320
mov dl,9d
PintarLinea:
mov es:[di],dl
inc di
Loop PintarLinea
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SETEAR JUEGO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetearJuego macro
LOCAL Linea, Error, FinLinea, CopiarID, CopiarT, CopiarTO, CopiarTP, CopiarPP, CopiarPO, VR, VV, VA, VB, FinSJ
mov TotalNiveles,0
mov bx, offset Niveles
mov NivelAux,bx
mov si,0

Linea:
mov al,bufferInformacion[si]
cmp al,4eh ; N
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,49h ; I
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,56h ; V
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,45h ; E
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,4ch ; L
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,3bh
jne Error
inc si
mov bx,NivelAux
xor di,di
CopiarID: ;ID del nivel
mov al,bufferInformacion[si]
mov [bx].Level.ID[di],al
inc si
inc di
mov al,bufferInformacion[si]
cmp al,3bh
jne CopiarID
inc si
mov NumeroAux,si
LimpiarBuffer bufferAuxiliar, SIZEOF bufferAuxiliar,24h
mov si,NumeroAux
xor di,di
CopiarT: ;Tiempo de duracion del nivel
mov al,bufferInformacion[si]
mov bufferAuxiliar[di],al
inc si
inc di
mov al,bufferInformacion[si]
cmp al,3bh
jne CopiarT
mov NumeroAux,si
AsciiToNum bufferAuxiliar
mov si,NumeroAux
mov bx,NivelAux
mov [bx].Level.Tiempo,ax
inc si
mov NumeroAux,si
LimpiarBuffer bufferAuxiliar, SIZEOF bufferAuxiliar,24h
mov si,NumeroAux
xor di,di
CopiarTO: ;Frecuencia Obstaculos
mov al,bufferInformacion[si]
mov bufferAuxiliar[di],al
inc si
inc di
mov al,bufferInformacion[si]
cmp al,3bh
jne CopiarTO
mov NumeroAux,si
AsciiToNum bufferAuxiliar
mov si,NumeroAux
mov bx,NivelAux
mov [bx].Level.TiempoO,ax
inc si
mov NumeroAux,si
LimpiarBuffer bufferAuxiliar, SIZEOF bufferAuxiliar,24h
mov si,NumeroAux
xor di,di
CopiarTP: ;Frecuencia Premios
mov al,bufferInformacion[si]
mov bufferAuxiliar[di],al
inc si
inc di
mov al,bufferInformacion[si]
cmp al,3bh
jne CopiarTP
mov NumeroAux,si
AsciiToNum bufferAuxiliar
mov si,NumeroAux
mov bx,NivelAux
mov [bx].Level.TiempoP,ax
inc si
mov NumeroAux,si
LimpiarBuffer bufferAuxiliar, SIZEOF bufferAuxiliar,24h
mov si,NumeroAux
xor di,di
CopiarPP: ;Puntos Premios
mov al,bufferInformacion[si]
mov bufferAuxiliar[di],al
inc si
inc di
mov al,bufferInformacion[si]
cmp al,3bh
jne CopiarPP
mov NumeroAux,si
AsciiToNum bufferAuxiliar
mov si,NumeroAux
mov bx,NivelAux
mov [bx].Level.PuntosP,ax
inc si
mov NumeroAux,si
LimpiarBuffer bufferAuxiliar, SIZEOF bufferAuxiliar,24h
mov si,NumeroAux
xor di,di
CopiarPO: ;Puntos Obstaculos
mov al,bufferInformacion[si]
mov bufferAuxiliar[di],al
inc si
inc di
mov al,bufferInformacion[si]
cmp al,3bh
jne CopiarPO
mov NumeroAux,si
AsciiToNum bufferAuxiliar
mov si,NumeroAux
mov bx,NivelAux
mov [bx].Level.PuntosO,ax
inc si
mov al,bufferInformacion[si]
cmp al,72h ; r (rojo)
je VR
cmp al,76h ; v (verde)
je VV
cmp al,61h ; a (azul) 
je VA
cmp al,62h ; b (blanco)
je VB
jmp Error


VR:
inc si
mov al,bufferInformacion[si]
cmp al,6fh ; o 
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,6ah ; j 
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,6fh ; o 
jne Error
mov bx,NivelAux
mov [bx].Level.ColorC,4d
jmp FinLinea

VV:
inc si
mov al,bufferInformacion[si]
cmp al,65h ; e 
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,72h ; r 
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,64h ; d 
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,65h ; e 
jne Error
mov bx,NivelAux
mov [bx].Level.ColorC,2d
jmp FinLinea

VA:
inc si
mov al,bufferInformacion[si]
cmp al,7ah ; z 
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,75h ; u 
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,6ch ; l 
jne Error
mov bx,NivelAux
mov [bx].Level.ColorC,1d
jmp FinLinea

VB:
inc si
mov al,bufferInformacion[si]
cmp al,6ch ; l 
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,61h ; a
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,6eh ; n
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,63h ; c
jne Error
inc si
mov al,bufferInformacion[si]
cmp al,6fh ; o
jne Error
mov bx,NivelAux
mov [bx].Level.ColorC,15d

FinLinea:
inc TotalNiveles
inc si
mov cl,bufferInformacion[si]
cmp cl,24h
je FinSJ
cmp cl,0dh
jne Error
inc si
mov cl,bufferInformacion[si]
cmp cl,0ah
jne Error
inc si
mov bx,NivelAux
add bx,SIZEOF Level
mov NivelAux,bx
jmp Linea

Error:
mov TotalNiveles,0
CerrarArchivo handlerEntrada
jmp Error_Entrada

FinSJ:
CerrarArchivo handlerEntrada
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% JUEGO CON NIVELES  %%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

JuegoCN macro
LOCAL Reload, SumarColumna, RestarColumna, SalirJuego, Sumar, Restar, CompararValores, ReemplazarP, ReemplazarT, ContinuarExit, Pausa
mov ColumnaCarro, 10101010b
PintarEncabezadoJuego
mov PuntajeAux,0
mov TiempoAux,0
Reload:
PintarEncabezadoJuego
PintarCarro ColorCarro
getCharSE
	cmp al,4dh			;derecha
	je SumarColumna
	cmp al,4bh			;izquierda
    je RestarColumna
    cmp al,1bh			;ESC
    je Pausa
	jmp Reload

SumarColumna:
	mov ax, ColumnaCarro
	cmp ax,300
	jb Sumar
	jmp Reload

Sumar:
	inc PuntajeAux
	inc TiempoAux
	PintarEncabezadoJuego
	PintarCarro 0d
	mov ax,ColumnaCarro
	add ax,5
	mov ColumnaCarro,ax
	jmp Reload

RestarColumna:
	mov ax,ColumnaCarro
	cmp ax,0
	ja Restar	
	jmp Reload

Restar:
	PintarEncabezadoJuego
	PintarCarro 0d
	mov ax,ColumnaCarro
	sub ax,5
	mov ColumnaCarro,ax
	jmp Reload


Pausa:
mov dl, 0; Column
mov dh, 0 ; Row
mov bx, 0 ; Page number, 0 for graphics modes
mov ah, 2h
int 10h
mov ah, 09h
mov al, SPVar 
mov bh, 00h
mov bl, 15d
mov cx, 40d
int 10h
mov dl, 0; Column
mov dh, 0 ; Row
mov bx, 0 ; Page number, 0 for graphics modes
mov ah, 2h
int 10h
print titulo_pausa
getCharSE
cmp al,1bh			;ESC
je Reload
cmp al,20h			;SPACEBAR
je CompararValores
jmp Pausa


ReemplazarP:
mov [bx].Usuario.Punteo,cl
jmp ContinuarExit

ReemplazarT:
mov [bx].Usuario.Tiempo,cl
jmp SalirJuego

CompararValores:
mov bx,UsuarioAux
mov al,[bx].Usuario.Punteo
mov cl,PuntajeAux
cmp al,cl
jl ReemplazarP
ContinuarExit:
mov al,[bx].Usuario.Tiempo
mov cl,TiempoAux
cmp al,cl
jl ReemplazarT

SalirJuego:
endm