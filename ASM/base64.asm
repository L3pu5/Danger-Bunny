;nasm -fwin32-g b64.asm
;gcc -m32 b64.o -o b64

;extern printf

;FS is a snapshot of the filesystem.
; section .data:
;     format db "%s", 0
;     chars db "Hello World!", 0
; Define variables in the data section
section .bss
    buff_len EQU 3
    buff:   resb buff_len
    res:    resb 64
    index:  resb 4
	myBuff: resb 30

section .data
    chars:   db "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    pad:     db "="
    src:     db "This is some text"
	srcleN:  dw 1

; Code goes in the text section
section .text
	global _start 



performB64:
	;This performs b64 encoding for a 3 byte block.
	;Load the first byte
	mov ebx, [index]
	mov al, byte [src + ebx]
	and al, 0xFC
	shr al, 2
	mov cl, byte [chars + eax]
	mov [myBuff + ebx], cl
	;Load the second byte
	;Check to see +f the second byte is bigger than the size
	mov ecx, [esp - 4]
	cmp ecx, ebx
	;If ecx == ebx, we should just do padding.
	jne byte2
	push 2
	call padding
	ret
	byte2:
		mov al, byte [src + ebx]
		and al, 0x3
		shl al, 4
		;Get the next byte 
		inc ebx
		mov dl, byte [src + ebx]
		and dl, 0xF0
		shr dl, 4
		or al, dl
		mov cl, byte [chars + eax]
		mov [myBuff + ebx], cl
		;Grab the last four bits of of byte 2
		mov al, byte [src + ebx]
		and al, 0x0F
		shl al, 2
		;Grab the next byte (3)
		inc ebx
		mov dl, byte [src + ebx]
		and dl, 0xC0
		shr dl, 6
		or al, dl
		mov cl, byte [chars + eax]
		mov [myBuff + ebx], cl
		mov dl, byte [src + ebx]
		and dl, 0x3F
		inc ebx
		mov cl, byte [chars + edx]
		mov [myBuff + ebx], cl


		;Print the string

		mov eax, 4            		; 'write' system call = 4
		mov ebx, 1            		; file descriptor 1 = STDOUT
		mov ecx, myBuff        		; string to write
		mov edx, 4     				; length of string to write
		int 80h              		; call the kernel
		jmp exit
	ret
	
padding:
	pop ecx
	pushpadding:
		inc dword [index]
		mov ebx, [index]
		mov dl, byte [pad]
		mov [myBuff + ebx], dl
		loop pushpadding 

		mov eax, 4            		; 'write' system call = 4
		mov ebx, 1            		; file descriptor 1 = STDOUT
		mov ecx, myBuff        		; string to write
		mov edx, 4     				; length of string to write
		int 80h              		; call the kernel
		jmp exit
	ret


exit:
	mov eax,1            ; 'exit' system call
	mov ebx,0            ; exit with error code 0
	int 80h              ; call the kernel

_start:
	;Move the index to 0
	xor eax, eax
	mov [index], eax
	push 1
	call performB64
	 ;mov [myBuff + 1], byte 0xA 
    
	;mov eax, 4            		; 'write' system call = 4
	;mov ebx, 1            		; file descriptor 1 = STDOUT
	;mov ecx, myBuff        		; string to write
	;mov edx, dword srcleN     	; length of string to write
	;int 80h              		; call the kernel

	; Terminate program
	mov eax,1            ; 'exit' system call
	mov ebx,0            ; exit with error code 0
	int 80h              ; call the kernel