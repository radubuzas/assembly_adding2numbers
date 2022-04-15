section .data

section .bss
	x_buffer: resd 1
	x: resd 8
	y: resd 8
	p: resd 1
	cnt: resd 1
	ok: resd 1
	zero: resd 1

section .text
	global _start
_start:
	
	xor eax, eax	; eax = 0
	
	mov [x], eax	; x = eax = 0
	mov [cnt], eax	; cnt = eax = 0
	mov [ok], eax	; ok = eax = 0
	
	mov eax, 10	; eax = 10
	mov [p], eax	; p = 10
	
	mov eax, 0x30	; eax = ascii code of '0' - 48 - 0x30
	mov [zero], eax	; zero = ascii code of '0' - 48 - 0x30
	
	;reading x
	et_citire:
	    xor edx, edx	; edx = 0
	    mov [x_buffer], edx	; x_buffer = 0
	    
    	mov eax, 0x3		; eax = 3 - code for reading
    	xor ebx, ebx		; ebx = 0 - iostream
    	mov ecx, x_buffer	; ecx = &x_buffer (the address of x_buffer)
    	mov edx, 0x1		; edx = 1 - the lenght of the text to be read
    	int 0x80		; sys int - reading a char and putting it in x_buffer
    	
    	mov eax, 0x30 		; eax = 48
    	
	;verifies if the read character is a digit
    	cmp eax, [x_buffer]     ; '0' = eax <= x_buffer
    	jle verif_mai_mic	; jump if less or equal
    	jmp et_citire_y		; skipping the rest of the reading
    	
    	verif_mai_mic:3
    	    mov eax, 0x39	; eax = ascii code of '9'
    	    cmp eax, [x_buffer]	; '9' = eax >= x_buffer
    	    jge et_construire_numar ; '0' <= x_buffer <= '9'
    	
    	jmp et_citire_y
    	
    	et_construire_numar:

            mov ecx, [p]    	; ecx = p = 10
    	    xor edx, edx	; edx = 0
    	    xor eax, eax	; eax = 0
    	   
    	    mov eax, [x_buffer] ;   eax = 'n' - caracterul citit
    	    sub eax, 0x30       ;   eax contine o cifra [0,9]
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
    add [y], eax		; y = y + x
    
    
    xor eax, eax		; eax = 0
    mov [x], eax                ; x = 0
    
    
    et_oglindit:
        
        xor edx, edx            ;   pregatire edx pentru impartire
	    mov [x_buffer], edx     ;   initializare x_buffer = 0
	    
	    mov eax, [y]            ;   eax = y
	    mov ecx, 10             ;   ecx = 10
	    div ecx                 ;   edx = y%10;     eax = y/10
	    
	    cmp edx, 0
	    mov ebx, 1
	    mov [ok], ebx
	    je zero_in_coada
	    jmp resume
	    
	    zero_in_coada:
	        xor ebx, ebx
	        cmp ebx, [ok]
	        je inc_cnt
	        
	        jmp resume
	        
	        inc_cnt:
	            mov ebx, [cnt]
	            inc ebx
	            mov [cnt], ebx
	    
	    resume:
	    
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
    	je afis_zero
    	
    	jmp et_print
    	
    afis_zero:
	
	    xor ebx, ebx
	    cmp [cnt], ebx
	    je terminate
	    
	    mov eax, 0x4
    	mov ebx, 0x1
    	mov ecx, zero
    	mov edx, 0x1
    	int 0x80
    	
    	mov eax, [cnt]
    	dec eax
    	mov [cnt], eax
    	
    	jmp afis_zero
	
	terminate:
    	mov eax, 0x1
    	xor ebx, ebx
    	int 0x80
