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

	mov ah,02h
	mov dh,x
	mov dl,y
	int 10h

    push ds
	MOV ah,09h 
	MOV dx,@data
	MOV ds,dx

	mov dx,offset string
	mov ah,9h
	int 21h
	pop ds
    popear
endm


moverCursor macro x,y 
pushear
	xor ax,ax
    xor dx,dx

	mov ah,02h
	mov dh,x
	mov dl,y
	int 10h
popear
endm
printPixel macro x,y, color
	pushear
	mov ax,y
	mov bx,320
	mul bx
	xor bx, bx
	mov bx, x
	add ax,bx
	mov di, ax
	mov dl, color
	mov [di],dl

	;mov ah,0ch		
	;mov al, color
	;mov bh,0h
	;mov dx,y		
	;mov cx,x		
	;int 10h
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
    cmp bl,190
    ja  salto
	add bl,2
	mov barra[0], bl
    salto:	
	pop bx
endm

disminuirBarra macro 
    LOCAL salto
    push bx
	xor bx, bx
	mov bl, barra[0]
    cmp bl,9
    jb salto
	sub bl,2
	mov barra[0], bl	
    salto:
	pop bx
endm

videoModeON macro
  	mov ax,13h
 	int 10h
	mov ax, 0A000h
  	mov ds, ax  ;
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
  	mov dl,[di-639]
	cmp dl, negro
	jne arriba

  	mov dl,[di+324]	
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
  	mov dl,[di-639]
	cmp dl, negro
	jne arriba

  	mov dl,[di+318]	
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
  	mov dl,[di+1281]
	cmp dl, negro
	jne abajo

  	mov dl,[di+324]	
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
  	mov dl,[di+1281]
	cmp dl, negro
	jne abajo

  	mov dl,[di+318]	
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
	local mo1, mo2, mo3, mo4,fin,ve1,ve2,ve3, ve4, am1, am2, am3, am4,gris, az1,az2,az3,az4, fin2
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
	cmp dl, 1dh
	je gris

	jmp fin2


	mo1:
	printBloque 13, 50, 70,10, negro
	jmp fin
	mo2:
	printBloque 88, 50, 70,10, negro
	jmp fin
	mo3:
	printBloque 163, 50, 70,10, negro
	jmp fin
	mo4:
	printBloque 238, 50, 70,10, negro
	jmp fin

	ve1:
	printBloque 13, 35, 70,10, negro
	jmp fin

	ve2:
	printBloque 88, 35, 70,10, negro
	jmp fin

	ve3:
	printBloque 163, 35, 70,10, negro
	jmp fin

	ve4:
	printBloque 238, 35, 70,10, negro
	jmp fin

	am1:
	printBloque 13, 20, 70,10, negro
	jmp fin
	am2:
	printBloque 88, 20, 70,10, negro
	jmp fin

	am3:
	printBloque 163, 20, 70,10, negro
	jmp fin

	am4:
	printBloque 238, 20, 70,10, negro	
	jmp fin

	az1:
	printBloque 13, 65, 70,10, negro
	jmp fin

	az2:
	printBloque 88, 65, 70,10, negro
	jmp fin

	az3:
	printBloque 163, 65, 70,10, negro
	jmp fin

	az4:
	printBloque 238, 65, 70,10, negro
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

	pop ds
	pop dx
	jmp fin2
	fin:
	;printVideo 0,0,prueba
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

endm



printPelota macro pos, color	 
  
	pushear
	mov di, pos
	mov dl, color
	mov [di],dl
  	mov [di+1],dl
  	mov [di+2],dl
	mov [di+320],dl
  	mov [di+321],dl
  	mov [di+322],dl
	mov [di+640],dl
  	mov [di+641],dl
  	mov [di+642],dl

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

jugar macro 
	local cicloActual, fin, IZQ, DER, actual, salto, salto2
	
    mov barra[0],100
	mov direccion1[0],0;35354 IDEAL NIVEL 1
    mov direccion2[0],1;35354 IDEAL NIVEL 1
	mov direccion1[1],0;35354 IDEAL NIVEL 1
    mov direccion2[1],0;35354 IDEAL NIVEL 1
    mov posPelota1[0],35354
    mov punteo[0],0
    mov posPelota2[0],35145
	printVideo 0,20, punteo 
	
	printBarra 1   
	cicloActual: 
	cmp direccion1[1],0
	jne salto	
	moverPelota direccion1[0], posPelota1
	salto:
	cmp direccion2[1],0
	jne salto2
	moverPelota direccion2[0], posPelota2
	
	salto2:
	ganar

	call Delay
	call HasKey
	jz cicloActual
	
	call GetCh        ; si hay, leer cual es
  
  	cmp al, '3'       
 	je fin  
	cmp al, 'A'       
 	je IZQ
	cmp al, 'D'       
 	je DER
		jmp cicloActual
	IZQ:
	printBarra 1   	
	jmp cicloActual 
	DER:   
	printBarra 0     
	 
	         ; sino comprobar movimientos
	jmp cicloActual   
	fin:
	videoModeOFF

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
	local gano, continuar
	push ax
	push dx
	push ds
	xor ax,ax
	mov dx,@data
	MOV ds,dx
	mov al, punteo[0]
	cmp al, 12
	je gano
	jmp continuar

	gano:
	printVideo 15,17, terminar
	getChar
	jmp WIN
	continuar:

	pop ds
	pop dx
	pop ax
endm