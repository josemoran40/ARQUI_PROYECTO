
Delay proc 
  PUSH CX
  PUSH DX
  PUSH AX
  mov cx,0000h 	;tiempo del delay
	mov dx,05fffh 	;tiempo del delay
  mov ah,86h
  int 15h 
  POP AX
  POP DX
  POP CX
  
  ret
Delay endp


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