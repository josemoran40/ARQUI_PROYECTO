
;------------------------ MAIN------------------------------------------------------

.model small
.stack 100h 
.data
 prueba db 'hola','$'
 barra db 170
;;------------------------ COLORES ------------------------------
 verdeLimon equ 2eh
 blanco equ 0fh
 naranja1 equ 2ah
 naranja2 equ 2bh
 amarillo1 equ 2ch
 amarillo2 equ 0eh
 celesteClaro equ 0bh
 celestePastel equ 66h
 lila equ 3ah
 negro equ 00h
.code 
    include macros.asm
    ;include procs.asm

    main proc
    mov ax,13h
	int 10h
    mov barra[0],100

      MENU:
            
	moverCursor 0,0
            getChar
    ;call ClearScreen 
            cmp al,49
            je OPCION1
            cmp al,50
            je OPCION2
            cmp al,51
            je SALIR
            cmp al,65
            je IZQUIERDA
            cmp al,68
            je DERECHA
            jmp MENU 

            OPCION1:  
                printVideo 10,10, prueba
                jmp MENU           
            OPCION2:
                printCuadrado 5,12, 310,180,lila
                printCuadrado 6,13, 308,178,celesteClaro

                printBloque 13, 20, 70,10, naranja1
                printBloque 13, 35, 70,10, naranja2
                printBloque 13, 50, 70,10, amarillo1
                printBloque 13, 65, 70,10, amarillo2
                
                printBloque 88, 20, 70,10, naranja1
                printBloque 88, 35, 70,10, naranja2
                printBloque 88, 50, 70,10, amarillo1
                printBloque 88, 65, 70,10, amarillo2
                
                printBloque 163, 20, 70,10, naranja1
                printBloque 163, 35, 70,10, naranja2
                printBloque 163, 50, 70,10, amarillo1
                printBloque 163, 65, 70,10, amarillo2
                
                printBloque 238, 20, 70,10, naranja1
                printBloque 238, 35, 70,10, naranja2
                printBloque 238, 50, 70,10, amarillo1
                printBloque 238, 65, 70,10, amarillo2     
                printBarra 0           
                jmp MENU
            
            IZQUIERDA:
               printBarra 1
               jmp MENU

            
            DERECHA:
               printBarra 0
               jmp MENU
        SALIR: 
            mov ax,3h
	        int 10h
			MOV ah,4ch
			int 21h
    main endp
end
