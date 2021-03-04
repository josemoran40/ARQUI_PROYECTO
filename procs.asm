



HasKey:
    push ax            

    mov ah, 01h        ; funcion 1
    int 16h            ; interrupcion bios

    pop ax            

    ret   
    
;======================================================================
    ; funcion GetCh
    ; ascii tecla presionada
    ; Salida en al codigo ascii sin eco, via BIOS
  GetCh:    
      xor ah,ah        
      int 16h            
      ret  
  
ClearScreen proc
  pushear
	mov di, 0
  mov cx, 160000
  mov dl, 00h
  ciclo:
  
    mov es:[di],dl
    inc di
    loop ciclo
	
	popear
	ret
ClearScreen endp



;   / ____/ __ \/ __ \/ | / / __ \/  |/  / ____/_  __/ __ \/ __ \
; / /   / /_/ / / / /  |/ / / / / /|_/ / __/   / / / /_/ / / / /
;/ /___/ _, _/ /_/ / /|  / /_/ / /  / / /___  / / / _, _/ /_/ / 
;\____/_/ |_|\____/_/ |_/\____/_/  /_/_____/ /_/ /_/ |_|\____/ 

cronometro proc		
  pushear
	xor dx,dx
	xor cx,cx
	xor ax,ax

	mov ah,02h				
	int 1Ah					

	cmp dh,init[0]			
	je FIN					

	xor ax,ax
	mov init[0],ah		
	mov init[0],dh		

	xor ax,ax
	mov ax,1
	add contador[0],ax	

	xor ax,ax
	xor bx,bx
	xor dx,dx

	mov ax,contador[0]	
	mov bx,60
	div bx	

	mov cx,cx
	mov segundos[0],cx		
	mov segundos[0],dx		


	xor cx,cx
	mov minutos[0],cx		
	mov minutos[0],ax		

	call pintar_cronometro	

	FIN:
  popear
	ret
cronometro endp
pintar_cronometro proc 
  mov ax, minutos[0]
	toString numeros

	xor ax,ax
	mov ax,'$'
	cmp al,numeros[1]
	je pintarMin				
	printVideo 0,30,numeros	
	pintarMin:			
	printVideo 0,30,cero			
	printVideo 0,31,numeros	

	pintarSeparador:
	printVideo 0,32,separador	


	
  mov ax, segundos[0]
	toString numeros
	xor ax,ax				
	mov ax,'$'
	cmp al,numeros[1]		
	je pintarSeg
	printVideo 0,33,numeros
	jmp FIN
	pintarSeg:
	printVideo 0,33,cero
	printVideo 0,34,numeros

	FIN:
		ret
  pintar_cronometro endp

tiempo_inicial: 	;asigna los valores iniciales o de referencia a init y pone contador en 0
	xor ax,ax
	mov ah,02h
	int 1Ah
	mov init[0],dh		;se le asignan los segundos actuales a init
	xor ax,ax
	mov contador[0],ax	;se limpia el contador

	ret

