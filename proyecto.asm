
;------------------------ MAIN------------------------------------------------------

.model small
.stack 100h 
.data
 prueba db 'FIN','$'
 barra db 170
 posPelota dw 35420
 direccion db 0,'$'
 numeros db '$$$$$$','$'

;------------------------ COLORES ------------------------------
 verdeLimon equ 2eh
 blanco equ 0fh
 naranja1 equ 2ah
 naranja2 equ 2bh
 celesteClaro equ 0bh
 azulOscuro equ 36h
 lila equ 3ah
 negro equ 00h

;verdes
 verde1 equ 5fh
 verde2 equ 60h
 verde3 equ 61h
 verde4 equ 62h

; amarillos
 amarillo1 equ 5bh
 amarillo2 equ 5ch
 amarillo3 equ 5dh
 amarillo4 equ 5eh 

;morados
 morado1 equ 50h
 morado2 equ 51h
 morado3 equ 52h
 morado4 equ 53h

;azules
 azul1 equ 64h
 azul2 equ 65h
 azul3 equ 66h
 azul4 equ 67h
 

.code 
    
    include macros.asm
    main proc
    videoModeON
    mov barra[0],100
   ; mov direccion[0],0;35354 IDEAL NIVEL 1
    mov posPelota[0],35354
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
                imprimirBloque1
                imprimirBloque2
               jugar      
                jmp MENU
            
            IZQUIERDA:
               printBarra 1
               jmp MENU

            
            DERECHA:
               printBarra 0
               jmp MENU
        SALIR: 
           videoModeOFF
			MOV ah,4ch
			int 21h
        ;proce
    
    include procs.asm
    main endp
end
