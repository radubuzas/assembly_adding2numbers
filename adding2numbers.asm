section .data


section .bss
	x_buffer: resd 1
	x: resd 4
	y: resd 8
	p: resd 1
	cnt: resd 1

section .text
	global _start
_start:
	
	xor eax, eax
	mov [x], eax
	mov [cnt], eax
	
	mov eax, 10
	mov [p], eax
	
	;citire numar x
	et_citire:
	    xor edx, edx
	    mov [x_buffer], edx
	    
    	mov eax, 0x3
    	mov ebx, 0x0
    	mov ecx, x_buffer
    	mov edx, 0x1
    	int 0x80
    	
    	mov eax, 0x30 ;
    	
    	cmp eax, [x_buffer]     ;   '0' = eax <= x_buffer
    	jle verif_mai_mic
    	jmp et_citire_y
    	
    	verif_mai_mic:
    	    mov eax, 0x39
    	    cmp eax, [x_buffer]
    	    jge et_construire_numar
    	
    	jmp et_citire_y
    	
    	et_construire_numar:

            mov ecx, [p]    	
    	    xor edx, edx
    	    xor eax, eax
    	   
    	    mov eax, [x_buffer] ;   eax = 'n' - caracterul citit
    	    sub eax, 0x30        ;   eax contine o cifra [0,9]
    	    mov ebx, eax        ;   ebx = cifra
    	    mov eax, [x]        ;   eax = x; x = numarul citit
    	    mul ecx             ;   ecx = p; eax * ecx = x * p
    	    add eax, ebx        ;   eax + ebx = x * p + ebx
    	    
    	    mov [x], eax
    	
    	    
    	    jmp et_citire
    	    
    et_citire_y:
    
    xor eax, eax
    mov [y], eax
	
	et_citire_y_1:
	    xor edx, edx
	    mov [x_buffer], edx
    
        mov eax, 0x3
    	mov ebx, 0x0
    	mov ecx, x_buffer
    	mov edx, 0x1
    	int 0x80            ; s-a citit caracterul in x_buffer
    	
    	mov eax, 0x30 ;
    	
    	cmp eax, [x_buffer]
    	jle verif_mai_mic_y
    	jmp continue
    	
    	verif_mai_mic_y:
    	    mov eax, 0x39
    	    cmp eax, [x_buffer]
    	    jge et_construire_numar_y       ; x_buffer = cifra
    	
    	jmp continue
    	
    	et_construire_numar_y:

            mov ecx, [p]    	
    	    xor edx, edx
    	    xor eax, eax
    	   
    	    mov eax, [x_buffer] ;   eax = 'n' - caracterul citit
    	    sub eax, 0x30        ;   eax contine o cifra [0,9]
    	    mov ebx, eax        ;   ebx = cifra
    	    mov eax, [y]        ;   eax = y; y = numarul citit
    	    mul ecx             ;   ecx = p; eax * ecx = y * p
    	    add eax, ebx        ;   eax + ebx = y * p + ebx
    	    
    	    mov [y], eax
    	
    	    
    	    jmp et_citire_y_1
    	    
    continue:
    
    mov eax, [x]
    add [y], eax
    
    
    xor eax, eax
    mov [x], eax                ;   x = 0
    
    et_oglindit:
        
        xor edx, edx            ;   pregatire edx pentru impartire
	    mov [x_buffer], edx     ;   initializare x_buffer = 0
	    
	    mov eax, [y]            ;   eax = y
	    mov ecx, 10             ;   ecx = 10
	    div ecx                 ;   edx = y%10;     eax = y/10
	    
	    mov [x_buffer], edx     ;   cifra este pusa in x_buffer
	    mov [y], eax            ;   y = y/10
	    
	    xor edx, edx
	    mov eax, [x]            ;   eax = x
	    mul ecx                 ;   eax = x * 10
	    add eax, [x_buffer]     ;   eax = x * 10 + cif
	    
	    mov [x], eax
	    
	    
	    mov eax, [y]            ; 
	    cmp eax, 0
	    jne et_oglindit
	    
	
	et_print:
	    
	    xor edx, edx            ;   pregatire edx pentru impartire
	    mov [x_buffer], edx     ;   initializare x_buffer = 0
	    
	    mov eax, [x]            ;   eax = x
	    mov ecx, 10             ;   ecx = 10
	    div ecx                 ;   edx = x%10;     eax = x/10
	    
	    add edx, 0x30           ;   transformam cifra in caracter
	    mov [x_buffer], edx     ;   cifra caracter este pusa in x_buffer
	    
	    mov [x], eax            ;   y = y/10
	    
	
    	mov eax, 0x4
    	mov ebx, 0x1
    	mov ecx, x_buffer
    	mov edx, 0x1
    	int 0x80
    	
    	mov eax, [x]
    	cmp eax, 0
    	je terminate
    	
    	jmp et_print
    	


	terminate:
	
    	mov eax, 0x1
    	xor ebx, ebx
    	int 0x80
