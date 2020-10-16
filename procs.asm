ClearScreen proc
  mov ah,0
  mov al, 13h
  int 10h
ret
ClearScreen endp