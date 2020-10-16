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

    
	MOV ah,09h 
	MOV dx,@data
	MOV ds,dx

	mov dx,offset string
	mov ah,9h
	int 21h
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
	mov ah,0ch		
	mov al, color
	mov bh,0h
	mov dx,y		
	mov cx,x		
	int 10h
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
    printBloque bx, 170, 120, 3, celestePastel
	
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



