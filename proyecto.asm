
;------------------------ MAIN------------------------------------------------------

.model small,c
.stack 100h 
.data
 prueba db 'FIN','$'
 barra db 170
 posPelota1 dw 35420
 posPelota2 dw 35354
 posPelota3 dw 35354
 direccion1 db 0,1
 direccion2 db 1,1
 direccion3 db 1,0
 contadorPelotas db 2
 punteo db 0, '$'
 numeros db '$$$$$$','$'
 banderaPelota db 0,'$'
 terminar db 'WIN ',1,'$'
 siEsNumero db '0'
 intro1 db 'UNIVERSIDAD DE SAN CARLOS',0ah,0dh,'FACULTAD DE INGENIERIA',0ah,0dh,'CIENCIAS Y SISTEMAS',0ah,0dh,'$'
 intro2 db 'ARQUITECTURA DE COMPUTADORAS 1',0ah,0dh,'JOSE EDUARDO MORAN REYES',0ah,0dh,'201807455',0ah,0dh,'SECCION A',0ah,0dh,'$'
 opciones db 0ah,0dh,'1) INGRESAR',0ah,0dh,'2) REGISTRAR',0ah,0dh,'3) SALIR',0ah,0dh,'$' 
 pedirUsuario db 'Ingrese el nombre de usuario:',0ah,0dh,'$'
 pedirContrasena db 'Ingrese la contrasena:',0ah,0dh,'$'
 errorUsuario db 'El usuario ya existe',0ah,0dh,'$'
 usuarioCreado db 'El usuario fue creado con exito',0ah,0dh,'$'
 usuario db 10 dup('$')
 contrasena db 10 dup('$')
 newln db 0ah,0dh,'$' 
 rutaArchivo db 'user.txt',00h
 rutaPunteos db 'puntos.txt',00h
 handleFichero dw ?
 handlePunteos dw ?
 msmError2 db 0ah,0dh,'Error al leer archivo','$'
 msmError3 db 0ah,0dh,'Error al crear archivo','$'
 msmError4 db 0ah,0dh,'Error al Escribir archivo','$'
 msmError5 db 0ah,0dh,'Error al abrir archivo','$'
 msmError6 db 0ah,0dh,'Error al cerrar el archivo','$'
 errorLogin db 'Usuario no encontrado',0ah,0dh,'$'
 bienvenido db 'Bienvenido','$' 
 bufferUsuarios db 1000 dup('$')
 bufferPunteos db 1000 dup('$')
 userAux db 10 dup('$')
 contraAux db 10 dup('$')
 igual1 db '0','$'
 igual2 db '0','$'
 jala db 'jala','$'
 adminUser db 'adminAI','$'
 adminBienvenido db 'Bienvindo Admin',0ah,0dh,'1) TOP TIEMPOS',0ah,0dh,'2) TOP PUNTOS',0ah,0dh,'$'
 adminPass db '4321','$'
 retornoExiste db '0','$'
 pressEnter db 'PRESIONA ENTER PARA EMPEZAR','$'
 meta db 12
 nivel db 1
 siguiente db 0
 terminarJuego db 0
 constrasenaFormato db 'Contrasena con formato incorrecto','$'
;------------------------ COLORES ------------------------------
 verdeLimon equ 2eh
 blanco equ 0fh
 naranja2 equ 2bh
 azulOscuro equ 36h
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

 rosa1 equ 54h
 rosa2 equ 55h
 rosa3 equ 56h
 rosa4 equ 57h
 

 ;------------------------- CRONOMETRO  -------------------------------------------------
 init db 0 				
 contador dw 0				
 segundos dw 0				
 minutos dw 0				
 separador db ':','$'		
 cero db '0','$'			
 impnivel db 'N1','$'	
 tiempoInit db '00:00','$'		

.code 
    
    include macros.asm
    
    
    main proc
    push dx
    mov dx,@data
	MOV ds,dx
    pop dx

    mov barra[0],100
    mov direccion2[0],1;35354 IDEAL NIVEL 1
    mov posPelota1[0],35354
    mov punteo[0],0
    mov posPelota2[0],35145
    mov contadorPelotas[0],2
        print intro1
        print intro2
      MENU:
        print opciones
            getChar
            ;call ClearScreen 
            cmp al,49
            je OPCION1
            cmp al,50
            je OPCION2
            cmp al,51
            je SALIR
            jmp MENU 

            OPCION1: 
                print newln
                ingresar 
                getChar 
                jmp MENU           
            OPCION2: 
                print newln
                registro
                jmp MENU
            

            WIN:
            videoModeOFF
                guardarPunteos
                jmp MENU

            
            LOSS:
                getChar
                videoModeOFF
                guardarPunteos
                Sound 100
                jmp MENU

             ErrorLeer:
	    	print msmError2
	    	getChar
	    	jmp MENU
	        ErrorCrear:
	    	print msmError3
	    	jmp MENU
		    ErrorEscribir:
	    	print msmError4
	    	getChar
	    	jmp MENU   
            
	        ErrorAbrir:
	    	print msmError5
	    	jmp MENU

            
            CloseError:
            print msmError6
	    	getChar
            jmp MENU  
        SALIR: 
			MOV ah,4ch
			int 21h
            
        ;proce
    
    include procs.asm
    main endp
end
