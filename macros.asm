Pushear macro
        push ax
        push bx
        push cx
        push dx
        push si
        push di
    endm

Popear macro                    
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
endm


print macro cadena 
 LOCAL ETIQUETA 
 pushear 
 ETIQUETA: 
	MOV ah,09h 
	MOV dx,@data
	MOV ds,dx 
	MOV dx, offset cadena
	int 21h 

popear
endm

;-----

getChar macro
    mov ah,01h
    int 21h
endm

;-------------------------------  IMPRIMIR -------------------------------
printVideo macro x, y, string 		;x0,y0,cadena
    pushear
	xor ax,ax
    xor dx,dx
	xor bx, bx
	xor cx, cx
	mov ah,02h
	mov dh,x
	mov dl,y
	int 10h


	mov dx,offset string
	mov ah,9h
	int 21h
    popear
endm


moverCursor macro x,y 
pushear
	xor ax,ax
    xor dx,dx
	xor bx, bx
	mov ah,02h
	mov dh,x
	mov dl,y
	int 10h
popear
endm
	printPixel macro x,y, color
		pushear
		mov ax,y;y*320 + 
		mov bx,320
		mul bx
		xor bx, bx
		mov bx, x
		add ax,bx
		mov di, ax
		mov dl, color
		mov es:[di],dl

		
		popear
	endm

printBloque macro x, y, tamX, tamY, color		;x0,y0,tamX,tamY,color
	LOCAL ejex, ejey, fin
    pushear
	xor di,di
	xor si,si
	mov di,x	
	mov si,y
	ejex:
		printPixel di,si,color
		inc di
		xor dx,dx
		mov dx,x
		add dx,tamX
		cmp di,dx
		jne ejex
	ejey:
		inc si
		xor di,di
		mov di,x
		xor dx,dx
		mov dx,y
		add dx, tamY
		cmp si,dx
		jne ejex
	fin:
        popear
endm


printLinea macro x,y,color,tamanio, direccion;direccion(1=horizontal,0=vertical)
	LOCAL dic, ejex, ejey, fin
    push di
	push si
	push bx
	push cx
	xor di,di
	xor si,si
	mov di,x 	;x
	mov si,y	;y
	mov cx,direccion  	;direccion	

	dic:
		cmp cx,1
		je ejex
		cmp cx,0
		je ejey
		jmp fin

	ejex:
		printPixel di,si,color
		inc di
		xor bx,bx
		mov bx,x
		add bx,tamanio
		cmp di,bx
		je fin
		jmp ejex

	ejey:
		printPixel di,si, color
		inc si
		xor bx,bx
		mov bx,y
		add bx,tamanio
		cmp si,bx
		je fin
		jmp ejey

	fin:
		pop di  
		pop si
		pop bx
		pop cx
		
endm

printCuadrado macro x,y,tamX, tamY, color
pushear
 printLinea x,y, color, tamX,1
 printLinea x,y, color, tamY,0 
 xor dx,dx
 mov dx,y
 add dx,tamY
 sub dx,1
 printLinea x,dx,color,tamX,1
 xor dx,dx
 mov dx,x
 add dx,tamX
 sub dx,1
 printLinea dx,y,color,tamY,0 

 ;printLinea tamX,tamY, color, tamY, 0
 popear
endm




printBarra macro lado
 LOCAL disminuir, imprimir
 pushear
    xor ax, ax
    mov al, lado
    xor bx,bx
    mov bl, barra 
    printBloque bx, 170, 120, 3, negro

    cmp al, 1
    je disminuir
    aumentarBarra
    jmp imprimir
    disminuir:
    disminuirBarra

    imprimir:
    xor bx,bx
    mov bl, barra 
    printBloque bx, 170, 120, 3, azulOscuro
	
 popear 
endm

aumentarBarra macro 
    LOCAL salto
    push bx
	xor bx, bx
	mov bl, barra[0]
    cmp bl,186
    ja  salto
	add bl,6
	mov barra[0], bl
    salto:	
	pop bx
endm

disminuirBarra macro 
    LOCAL salto
    push bx
	xor bx, bx
	mov bl, barra[0]
    cmp bl,13
    jb salto
	sub bl,6
	mov barra[0], bl	
    salto:
	pop bx
endm

videoModeON macro
  	mov ax,13h
 	int 10h
	mov ax, 0A000h
  	mov es, ax  ;
endm

videoModeOFF macro
 push dx
 MOV dx,@data
 MOV ds,dx
 pop dx
 mov ah,00h
 mov al,3h
 int 10h
endm

moverPelota macro direccion, pelota ;0:arriba derecha 1: arriba izquierda;2:abajo derecha; 3:abajo izquierda
	LOCAL AD, BD, BI, AI, fin
	pushear
    mov dx, pelota[0] 
    printPelota dx,negro

	xor ax, ax
	mov al, direccion
	cmp al, 0
	je AD
	cmp al, 1
	je AI
	cmp al, 2
	je BD
	cmp al, 3
	je BI
	jmp fin
	AD:
    sub dx, 318
	cambiarAD dx, direccion
	jmp fin
	AI:
    sub dx, 322
    cambiarAI dx, direccion
	jmp fin
	BD:
    add dx, 322
	cambiarBD dx, direccion
	jmp fin
	BI:
    add dx, 318
    cambiarBI dx, direccion

	fin:
	mov pelota[0],dx
	popear
endm


cambiarAD macro pos, direccion;0:arriba derecha 1: arriba izquierda;2:abajo derecha; 3:abajo izquierda
	LOCAL arriba, derecha, fin, pintar, fin2
	pushear
	mov di, pos
  	mov dl,es:[di-639]
	cmp dl, negro
	jne arriba

  	mov dl,es:[di+324]	
	cmp dl, negro
	jne derecha
	jmp pintar
	arriba:
	mov direccion[0],2;abajo derecha
	jmp fin

	derecha:
	mov direccion[0],1;arriba izquirda
	jmp fin

	pintar:	
    printPelota di,naranja2
	jmp fin2
	fin:
	destruirBloque direccion
	fin2:
	popear
endm


cambiarAI macro pos, direccion;0:arriba derecha 1: arriba izquierda;2:abajo derecha; 3:abajo izquierda
	LOCAL arriba, izquierda, fin, pintar,fin2
	pushear
	mov di, pos
  	mov dl,es:[di-639]
	cmp dl, negro
	jne arriba

  	mov dl,es:[di+318]	
	cmp dl, negro
	jne izquierda 
	jmp pintar
	arriba:
	mov direccion[0],3;abajo izquierda
	jmp fin

	izquierda:
	mov direccion[0],0;arriba derecha
	jmp fin

	pintar:	
    printPelota di,naranja2
	jmp fin2
	fin:
	destruirBloque direccion
	fin2:
	popear
endm

cambiarBD macro pos, direccion;0:arriba derecha 1: arriba izquierda;2:abajo derecha; 3:abajo izquierda
	LOCAL abajo, derecha, fin, pintar, fin2
	pushear
	mov di, pos
  	mov dl,es:[di+1281]
	cmp dl, negro
	jne abajo

  	mov dl,es:[di+324]	
	cmp dl, negro
	jne derecha
	jmp pintar
	abajo:
	mov direccion[0],0;arriba derecha
	jmp fin

	derecha:
	mov direccion[0],3;abajo izquirda
	jmp fin

	pintar:	
    printPelota di,naranja2
	jmp fin2
	fin:
	destruirBloque direccion
	fin2:
	popear
endm

cambiarBI macro pos,direccion;0:arriba derecha 1: arriba izquierda;2:abajo derecha; 3:abajo izquierda
	LOCAL abajo, izquierda, fin, pintar, fin2
	pushear
	mov di, pos
  	mov dl,es:[di+1281]
	cmp dl, negro
	jne abajo

  	mov dl,es:[di+318]	
	cmp dl, negro
	jne izquierda
	jmp pintar
	abajo:
	mov direccion[0],1;arriba izquierda	
	jmp fin

	izquierda:
	mov direccion[0],2;abajo derecha
	jmp fin

	pintar:	
    printPelota di,naranja2
	jmp fin2
	fin:
	destruirBloque direccion
	fin2:

	popear
endm

destruirBloque macro direccion
	local mo1, mo2, mo3, mo4,fin,ve1,ve2,ve3, ve4, am1, am2, am3, am4,gris, az1,az2,az3,az4, fin2, ro1,ro2,ro3,ro4
	pushear 
	cmp dl, morado1
	je mo1
	cmp dl, morado2
	je mo2
	cmp dl, morado3
	je mo3
	cmp dl, morado4
	je mo4

	cmp dl, verde1
	je ve1
	cmp dl, verde2
	je ve2
	cmp dl, verde3
	je ve3
	cmp dl, verde4
	je ve4

	cmp dl, amarillo1
	je am1
	cmp dl, amarillo2
	je am2
	cmp dl, amarillo3
	je am3
	cmp dl, amarillo4
	je am4

	cmp dl, azul1
	je az1
	cmp dl, azul2
	je az2
	cmp dl, azul3
	je az3
	cmp dl, azul4
	je az4

	cmp dl, rosa1
	je ro1
	cmp dl, rosa2
	je ro2
	cmp dl, rosa3
	je ro3
	cmp dl, rosa4
	je ro4


	cmp dl, 1dh
	je gris

	jmp fin2


	mo1:
	mov ax,13
	mov bx,50
	jmp fin
	mo2:
	
	mov ax,88
	mov bx,50
	jmp fin
	mo3:
	
	mov ax,163
	mov bx,50
	jmp fin
	mo4:
	mov ax,238
	mov bx,50
	jmp fin

	ve1:
	mov ax,13
	mov bx,35
	jmp fin

	ve2:
	mov ax,88
	mov bx,35
	jmp fin

	ve3:
	mov ax,163
	mov bx,35
	jmp fin

	ve4:
	mov ax,238
	mov bx,35
	jmp fin

	am1:
	mov ax,13
	mov bx,20
	jmp fin
	am2:
	mov ax,88
	mov bx,20
	jmp fin

	am3:
	mov ax,163
	mov bx,20
	jmp fin

	am4:
	mov ax,238
	mov bx,20
	jmp fin

	az1:
	mov ax,13
	mov bx,65
	jmp fin

	az2:
	mov ax,88
	mov bx,65
	jmp fin

	az3:
	mov ax,163
	mov bx,65
	jmp fin

	az4:
	mov ax,238
	mov bx,65
	jmp fin

	ro1:
	mov ax,13
	mov bx,80
	jmp fin

	ro2:
	mov ax,88
	mov bx,80
	jmp fin

	ro3:
	mov ax,163
	mov bx,80
	jmp fin

	ro4:
	mov ax,238
	mov bx,80
	jmp fin



	gris:
	mov direccion[1],1
	mov dh,contadorPelotas[0]
	dec dh
	mov contadorPelotas[0], dh
	cmp dh,0
	jne fin2


	push dx
	push ds
	mov dx,@data
	MOV ds,dx

	printVideo 15,17, prueba
	mov terminarJuego, 1
	pop ds
	pop dx
	jmp fin2
	fin:
	
	printBloque ax, bx, 70,10, negro
	push ax
	push dx
	push ds
	xor ax,ax
	mov dx,@data
	MOV ds,dx
	mov al, punteo[0]
	add al,1
	mov punteo[0], al
	toString numeros
	printVideo 0,20, numeros 
	pop ds
	pop dx
	pop ax

	fin2:
	popear
endm



printPelota macro pos, color	 
  
	pushear
	mov di, pos
	mov dl, color	
	mov es:[di],dl  
  	mov es:[di+1],dl
  	mov es:[di+2],dl
	mov es:[di+320],dl
  	mov es:[di+321],dl
  	mov es:[di+322],dl
	mov es:[di+640],dl
  	mov es:[di+641],dl
  	mov es:[di+642],dl

  popear
endm

;==========================================================================================
;===================================JUEGO =================================================
;==========================================================================================


imprimirBloque1 macro
	printCuadrado 5,12, 310,180,azulOscuro
	printCuadrado 6,13, 308,178,blanco
	printBloque 7, 189, 307, 1,1dh

	printBloque 13, 20, 70,10, amarillo1
	printBloque 13, 35, 70,10, verde1
	printBloque 13, 50, 70,10, morado1

	printBloque 88, 20, 70,10, amarillo2
	printBloque 88, 35, 70,10, verde2
	printBloque 88, 50, 70,10, morado2
	
	printBloque 163, 20, 70,10, amarillo3
	printBloque 163, 35, 70,10, verde3
	printBloque 163, 50, 70,10, morado3

	printBloque 238, 20, 70,10, amarillo4
	printBloque 238, 35, 70,10, verde4
	printBloque 238, 50, 70,10, morado4

endm

imprimirBloque2 macro
	printBloque 13, 65, 70,10, azul1
	printBloque 88, 65, 70,10, azul2
	printBloque 163, 65, 70,10, azul3
	printBloque 238, 65, 70,10, azul4
endm

imprimirBloque3 macro
	printBloque 13, 80, 70,10, rosa1
	printBloque 88, 80, 70,10, rosa2
	printBloque 163, 80, 70,10, rosa3
	printBloque 238, 80, 70,10, rosa4
endm


jugar macro
	call tiempo_inicial
	videoModeON
	moverCursor 15,15
	printVideo 12,6,pressEnter
	getChar
	videoModeOFF
	videoModeON
	;nivel1
	videoModeOFF
	videoModeON
	;nivel2
	videoModeOFF
	videoModeON
	nivel3
	videoModeOFF

endm

nivel1 macro 
	local cicloActual, fin, IZQ, DER, actual, salto, salto2, pausar
	
	mov impnivel[1],'1'
	printVideo 0,25, impnivel
	printVideo 0,7, usuario+2
    imprimirBloque1
	
    mov barra[0],100
	mov punteo[0],0
	mov direccion1[0],0;35354 IDEAL NIVEL 1
    mov direccion2[0],1;35354 IDEAL NIVEL 1
	mov direccion1[1],0;35354 IDEAL NIVEL 1
    mov direccion2[1],0;35354 IDEAL NIVEL 1
    mov posPelota1[0],35354
    mov punteo[0],0
    mov posPelota2[0],35445
    mov posPelota3[0],32219
	mov contadorPelotas[0],1
	mov terminarJuego, 0
	mov siguiente, 0
	printVideo 0,20, punteo 
	mov siguiente, 0
	
	printBarra 1   
	cicloActual: 
	cmp siguiente, 1
	je fin
	cmp terminarJuego, 1
	je LOSS
	cmp direccion1[1],0
	jne salto	
	moverPelota direccion1[0], posPelota1
	salto:
	cmp direccion2[1],0
	jne salto2
	;moverPelota direccion2[0], posPelota2
	
	salto2:
	ganar

	 Delay 05fffh
	call cronometro
	call HasKey
	jz cicloActual
	
	call GetCh        ; si hay, leer cual es
  
  	cmp al, '3'       
 	je LOSS  
	cmp al, 'A'       
 	je IZQ
	cmp al, 'D'       
 	je DER
	cmp al, 27       
 	je pausar
		jmp cicloActual
	IZQ:
	printBarra 1   	
	jmp cicloActual 
	DER:   
	printBarra 0   
	jmp cicloActual

	pausar:
	pause  
	 
	         ; sino comprobar movimientos
	jmp cicloActual   
	fin:
endm


nivel2 macro 
	local cicloActual, fin, IZQ, DER, actual, salto, salto2, pausar
	mov nivel,2
	mov siguiente, 0
	mov meta,28
	mov impnivel[1],'2'
	printVideo 0,25, impnivel
	printVideo 0,7, usuario+2
    imprimirBloque1
	imprimirBloque2
    mov barra[0],100
	mov direccion1[0],1;35354 IDEAL NIVEL 1
    mov direccion2[0],0;35354 IDEAL NIVEL 1
	mov direccion1[1],0;35354 IDEAL NIVEL 1
    mov direccion2[1],1;35354 IDEAL NIVEL 1
    mov posPelota1[0],33150
    mov posPelota2[0],32219
	mov contadorPelotas[0],1
	printVideo 0,20, punteo 
	
	printBarra 1   
	cicloActual: 
	cmp siguiente, 1
	je fin
	cmp terminarJuego, 1
	je LOSS
	cmp direccion1[1],0
	jne salto	
	moverPelota direccion1[0], posPelota1
	salto:
	cmp direccion2[1],0
	jne salto2
	moverPelota direccion2[0], posPelota2
	
	salto2:
	ganar

	 Delay 04fffh
	call cronometro
	call HasKey
	jz cicloActual
	
	call GetCh        ; si hay, leer cual es
  
  	cmp al, '3'       
 	je LOSS  
	cmp al, 'A'       
 	je IZQ
	cmp al, 'D'       
 	je DER
	cmp al, 27       
 	je pausar
		jmp cicloActual
	IZQ:
	printBarra 1   	
	jmp cicloActual 
	DER:   
	printBarra 0   
	jmp cicloActual

	pausar:
	pause
	 
	         ; sino comprobar movimientos
	jmp cicloActual   
	fin:
endm




nivel3 macro 
	local cicloActual, fin, IZQ, DER, actual, salto, salto2,salto3, pausar
	mov nivel,3
	mov siguiente, 0
	mov meta,48
	mov punteo[0],28
    imprimirBloque1
	imprimirBloque2
	imprimirBloque3
	mov impnivel[1],'3'
	printVideo 0,25, impnivel
	printVideo 0,7, usuario+2
    mov barra[0],100
	mov direccion1[0],1;35354 IDEAL NIVEL 1
    mov direccion2[0],0;35354 IDEAL NIVEL 1
    mov direccion3[0],0;35354 IDEAL NIVEL 1
	mov direccion1[1],0;35354 IDEAL NIVEL 1
    mov direccion2[1],1;35354 IDEAL NIVEL 1
    mov direccion3[1],1;35354 IDEAL NIVEL 1
    mov posPelota1[0],33150
    mov posPelota2[0],32219
    mov posPelota3[0],32219
	mov contadorPelotas[0],1
	printVideo 0,20, punteo 
	
	printBarra 1   
	cicloActual: 
	cmp siguiente, 1
	je fin
	cmp terminarJuego, 1
	je LOSS
	cmp direccion1[1],0
	jne salto	
	moverPelota direccion1[0], posPelota1
	salto:
	cmp direccion2[1],0
	jne salto2
	moverPelota direccion2[0], posPelota2
	
	salto2:
	cmp direccion3[1],0
	jne salto3
	moverPelota direccion3[0], posPelota3

	salto3:
	ganar

	Delay 03fffh
	call cronometro
	call HasKey
	jz cicloActual
	
	call GetCh        ; si hay, leer cual es
  
  	cmp al, '3'       
 	je LOSS  
	cmp al, 'A'       
 	je IZQ
	cmp al, 'D'       
 	je DER
	cmp al, 27       
 	je pausar
		jmp cicloActual
	IZQ:
	printBarra 1   	
	jmp cicloActual 
	DER:   
	printBarra 0   
	jmp cicloActual

	pausar:
	pause
	 
	         ; sino comprobar movimientos
	jmp cicloActual   
	fin:
endm




toString macro string
	local Divide, Divide2, EndCr3, Negative, End2, EndGC
        Push si
        xor si, si
        xor cx, cx
        xor bx, bx
        xor dx, dx
        mov di, 0ah
        test ax, 1000000000000000b
            jnz Negative
        jmp Divide2
        Negative:
            neg ax
            mov string[si], 45
            inc si
            jmp Divide2
        
        Divide:
            xor dx, dx
        Divide2:
            div di
            inc cx
            Push dx
            cmp ax, 00h
                je EndCr3
            jmp Divide
        EndCr3:
            pop dx
            add dx, 30h
            mov string[si], dl
            inc si
        Loop EndCr3
        mov dx, 24h
        mov string[si], dl
        inc si
        EndGC:
            Pop si
endm

ganar macro
	local gano, continuar,n1,n2,n3,continuar2,pel3
	push ax
	push dx
	push ds
	xor ax,ax
	mov dx,@data
	MOV ds,dx
	mov al, punteo[0]
	cmp al, meta
	je gano
	jmp continuar

	gano:
	printVideo 15,17, terminar
	getChar
	mov siguiente, 1
	jmp continuar2
	continuar:
	cmp nivel,1
	je n1
	cmp nivel,2
	je n2
	jmp n3
	n1:
		jmp continuar2
	n2:
		cmp al, 20
		jne continuar2
		cmp direccion2[1],1
		jne continuar2
		mov direccion2[1],0
		push dx
		mov dh,contadorPelotas[0]
		add dh,1
		mov contadorPelotas[0], dh
		pop dx
	n3:
		cmp al, 34
		jne pel3
		cmp direccion2[1],1
		jne pel3
		mov direccion2[1],0
		push dx
		mov dh,contadorPelotas[0]
		add dh,1
		mov contadorPelotas[0], dh
		pop dx
		pel3:
		cmp al, 41
		jne continuar2
		cmp direccion3[1],1
		jne continuar2
		mov direccion3[1],0

		push dx
		mov dh,contadorPelotas[0]
		add dh,1
		mov contadorPelotas[0], dh
		pop dx
	continuar2:
	pop ds
	pop dx
	pop ax
endm

registro macro
	LOCAL fin, falso, noEsNumero
	limpiarCadena usuario, 10
	limpiarCadena contrasena, 10
	abrirArchivo rutaArchivo,handleFichero
	leerArchivo 1000, bufferUsuarios,handleFichero
	closefile handleFichero
	print pedirUsuario
	getTexto2 usuario, 8
	print newln
	print pedirContrasena
	getTexto2 contrasena, 5
	print newln
	verificarNumeros contrasena+2, 4
	cmp siEsNumero[0],'0'
	je noEsNumero
	comprobacion usuario+2, contrasena+2
	cmp retornoExiste[0],'1'
	je falso
	escribirUsuario usuario+2, contrasena+2
	print usuarioCreado
	jmp fin
	falso:
	print errorUsuario
	jmp fin

	noEsNumero:   
	print constrasenaFormato
	fin:
endm

ingresar macro
	LOCAL fin, falso, noEsNumero, siguiente
	limpiarCadena usuario, 10
	limpiarCadena contrasena, 10
	abrirArchivo rutaArchivo,handleFichero
	leerArchivo 1000, bufferUsuarios,handleFichero
	closefile handleFichero
	print pedirUsuario
	getTexto2 usuario, 8
	print newln
	print pedirContrasena
	getTexto2 contrasena, 5
	print newln
	verificarNumeros contrasena+2, 4
	cmp siEsNumero[0],'0'
	je noEsNumero

	
	compararCadenas adminUser, usuario+2, igual1
	cmp igual1[0], '0'
	je siguiente
	;print jala
	compararCadenas adminPass, contrasena+2, igual1
	cmp igual1[0], '0'
	je siguiente
	print adminBienvenido
	getChar
	jmp fin
	siguiente:
	comprobacion usuario+2, contrasena+2
	cmp retornoExiste[0],'1'
	je falso
	print errorLogin
	jmp fin
	falso:
	print bienvenido
    jugar
	jmp fin

	noEsNumero:   
	print constrasenaFormato
	fin:

endm

escribirUsuario macro usuario, contra
 LOCAL CICLO, escribirUsuario, mientras, mientras2
 pushear
 mov di,0
 mov cx,1000
 mov si,1

 CICLO:
	cmp bufferUsuarios[di],	'$'
	je escribirUser
	add di,12
	inc si
	dec cx
	jne CICLO

	escribirUser:
		mov ax, si
		mov bufferUsuarios[di],al
		mov cx,7
		mov si,0
		inc di
		mientras:
			mov al,usuario[si]
			mov bufferUsuarios[di],al
			inc si
			inc di
			loop mientras

		mov cx,4
		mov si,0
		mientras2:
			mov al,contra[si]
			mov bufferUsuarios[di],al
			inc si
			inc di
			loop mientras2
		
		abrirArchivo rutaArchivo,handleFichero
		obtenerIndice bufferUsuarios
 		escribirArchivo 1000, bufferUsuarios,handleFichero
 		closefile handleFichero
endm

comprobacion macro usuario, contra
 LOCAL escribirUser, mientras, mientras2,siguiente, fin
 pushear
 mov di,0
 mov bx,1000
 mov si,1
 mov retornoExiste[0],'0'
	
escribirUser:
		mov cx,7
		mov si,0
		inc di
			limpiarCadena userAux, 9
		mientras:
			mov al,bufferUsuarios[di]
			mov userAux[si],al
			inc si
			inc di
			loop mientras
		
		;print userAux
		mov cx,4
		mov si,0
		limpiarCadena contraAux, 9
		mientras2:
			mov al,bufferUsuarios[di]
			mov contraAux[si],al
			inc si
			inc di
			loop mientras2
		compararCadenas userAux, usuario, igual1
		cmp igual1[0],'1'
		jne siguiente

		compararCadenas contraAux, contra, igual2
		cmp igual2[0],'1'
		jne siguiente
		mov retornoExiste[0],'1'

		siguiente:
			sub bx, 12
			cmp bx, 0
		jg escribirUser

		fin:
endm


compararCadenas macro cadena1,cadena2,bandera
	LOCAL comp,fin,igual1, igual2
	push di
	push bx
	mov bandera[0],'0'
	xor di,di
	sub di,1
	comp:
		inc di
		cmp cadena1[di],'$'
		je igual1
		cmp cadena2[di],'$'
		je igual2
		mov bl,cadena2[di]
		cmp cadena1[di],bl
		je comp
		jmp fin
	igual1:
		cmp cadena2[di],'$'
		jne fin
		mov bandera[0],'1'
		jmp fin
	igual2:
		cmp cadena1[di],'$'
		jne fin
		mov bandera[0],'1'
	fin:
	pop bx
	pop di
endm

obtenerIndice macro string
	LOCAL mientras, fin
	xor di, di
	mov di,0
	mientras:
		cmp string[di],'$'
		je fin
		inc di
		jmp mientras
	fin:
endm

limpiarCadena macro buffer, length
	LOCAL CICLO
	pushear
	xor cx,cx
	mov cx, length
	xor di, di
	mov di,0
	CICLO:
		mov buffer[di],'$'
		inc di
	LOOP CICLO
	popear			
endm
getTexto2 macro buffer, sz
    push ax
    push dx
    push bx
    xor bx,bx
    mov buffer[0],sz
    mov buffer[1],0
    Mov AH, 0Ah
    Mov DX, Offset buffer
    INT 21H
    mov bl, buffer[1]
    mov buffer[bx+2],'$'

    pop bx
    pop dx
    pop ax
    print newln
endm


guardarPunteos macro
	LOCAL CICLO, escribir, salto
	pushear
	abrirArchivo rutaPunteos,handlePunteos
	leerArchivo 1000, bufferPunteos,handlePunteos
	closefile handlePunteos
	print bufferPunteos
 	mov di,0
 	mov bx,1000
	
	CICLO:
	cmp bufferPunteos[di],	'$'
	je salto

	add di,9
	jmp CICLO
	salto:
	mov si, 2
	mov cx, 7
	escribir:
		mov al, usuario[si]
		mov bufferPunteos[di],al 
		inc si
		inc di
		loop escribir
	
	mov al, punteo[0]
	mov bufferPunteos[di], al
	inc di

	mov al, nivel[0]
	mov bufferPunteos[di],al

	abrirArchivo rutaPunteos,handlePunteos
	escribirArchivo 1000, bufferPunteos,handlePunteos
	closefile handlePunteos

	popear
endm

verificarNumeros macro buffer, length
	LOCAL salir, omitir, ciclo
	mov siEsNumero[0],'0'
	mov cx, length
	mov si, 0
	ciclo:
		cmp buffer[si],48
		jl salir
		cmp buffer[si],57
		jg salir
		
		omitir:
			inc si

		loop ciclo
	mov siEsNumero[0],'1'
	salir:
		
endm


;=================================== ABRIR ARCHIVO ================================

crearArchivo macro buffer,handle
    mov ah,3ch
    mov cx,00h
    lea dx,buffer
    int 21h
    jc ErrorCrear
    mov handle,ax
endm


escribirArchivo macro numbytes,buffer,handle
    pushear
    escribir numbytes,buffer,handle
    popear
endm


escribir macro numbytes,buffer,handle
	mov ah, 40h
	mov bx,handle
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc ErrorEscribir
endm


abrirArchivo macro ruta,handle
    mov ah,3dh
    mov al,10b
    lea dx,ruta
    int 21h
    mov handle,ax
    jc ErrorAbrir
endm


leerArchivo macro numbytes, buffer, handle
    PUSH cx
    leer numbytes, buffer, handle
    POP cx
endm
leer macro numbytes,buffer,handle
    mov ah,3fh
    mov bx,handle
    mov cx,numbytes
    lea dx,buffer
    int 21h
    jc ErrorLeer
endm

closefile macro handler
    LOCAL Inicio
    xor ax, ax
    Inicio:
        mov ah, 3eh
        mov bx, handler
        int 21h
        jc CloseError
endm

Delay macro tiempo
  PUSH CX
  PUSH DX
  PUSH AX
  mov cx,0000h 	;tiempo del delay
  mov dx,tiempo 	;tiempo del delay
  mov ah,86h
  int 15h 
  POP AX
  POP DX
  POP CX
endm

pause macro
 LOCAL seguir
	seguir:
	moverCursor 0, 0
	getChar
	printBloque 0,0,10,10,00h
	cmp al,27
	jne seguir
	
endm


Sound macro hz
    push ax
    push bx
    push cx
    push dx
    xor cx,cx
    xor dx,dx

    mov al, 86h
    out 43h, al
    mov ax, 1193180 ;numero de hz
    mov bx,hz
    div bx
    out 42h, al
    mov al, ah
    out 42h, al 
    in al, 61h
    or al, 00000011b
    out 61h, al
    delay 0ffffh
    in al, 61h
    and al, 11111100b
    out 61h, al

    pop dx
    pop cx
    pop bx
    pop ax
   
endm