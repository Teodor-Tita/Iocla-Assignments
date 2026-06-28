section .note.GNU-stack

section .text
extern putc
extern stdout

global my_printf

my_printf:
	push rbp
	mov rbp, rsp
	xor rax, rax

	sub rsp, 40 ; spatiu pe stiva

	mov [rbp - 8], rsi ; salvare la 8
	mov [rbp - 16], rdx ; salvare la 16
	mov [rbp - 24], rcx ; salvare la 24
	mov [rbp - 32], r8 ; salvare la 32
	mov [rbp - 40], r9 ; salvare la 40

	push rbx
	push r15
	push r13
	push r14
	push r12

	mov r15, rdi
	sub r13, r13
	sub r14, r14

go_through_format_string:
	mov al, byte [r15]
	cmp al, 0 ; a atins caracterul null?
	je finish

	cmp al, 37 ; 37 in ascii e %
	je find_out_format

	movzx edi, al
	mov rsi, [stdout]
	call putc
	inc r14
	inc r15
	jmp go_through_format_string
find_out_format:
	inc r15
	mov al, byte [r15]

	cmp al, 115 ;; s
	je format_string

	cmp al, 99 ;; c
	je format_char

	cmp al, 108 ; l
	je format_long_verify_u_next

	mov edi, 37 ; %
	mov rsi, [stdout]
	call putc
	inc r14

	mov al, byte [r15]
	cmp al, 0 ; e final de sir?
	je finish

	movzx edi, al
	mov rsi, [stdout]
	call putc
	inc r14
	inc r15
	jmp go_through_format_string

format_string:
	cmp r13, 5 ; a depasit cele 5 registre??
	jge format_stack2

	mov rax, r13
	mov rcx, 8 ; inmultesc cu 8 QWORD
	mul rcx
	mov rcx, rbp
	sub rcx, 8 ; baza
	sub rcx, rax
	mov rax, QWORD [rcx]
	jmp print_format_string
format_stack2:
	mov rax, r13
	sub rax, 5 ; scad argumentele
	mov rcx, 8 ; inmultesc cu 8 bytes
	mul rcx
	mov rcx, rbp
	add rcx, 16 ; vreau sa interactionez cu argumentele mele
	add rcx, rax
	mov rax, QWORD [rcx]
print_format_string:
	inc r13

	cmp rax, 0 ; e un pointer nulL?
	je string_end
	mov rbx, rax
print_string:
	mov al, byte [rbx]
	cmp al, 0 ; a atins caracterul null?
	je string_end

	movzx edi, al
	mov rsi, [stdout]
	call putc
	inc r14
	inc rbx
	jmp print_string
string_end:
	inc r15
	jmp go_through_format_string
format_char:
	cmp r13, 5 ; a depasit cele 5 registre?
	jge format_stack1

	mov rax, r13
	mov rcx, 8 ; inmultesc cu cat are un registru 
	mul rcx
	mov rcx, rbp
	sub rcx, 8 ; baza
	sub rcx, rax
	mov rax, QWORD [rcx]
	jmp print_format_char
format_stack1:
	mov rax, r13
	sub rax, 5 ; scad cele 5 argumente
	mov rcx, 8 ; inmultesc cu QWORD
	mul rcx
	mov rcx, rbp
	add rcx, 16 ;; salt pentru a interactiona cu argumentele mele
	add rcx, rax
	mov rax, QWORD [rcx]
print_format_char:
	inc r13
	mov edi, eax
	mov rsi, [stdout]
	call putc
	inc r14
	inc r15
	jmp go_through_format_string
format_long_verify_u_next:
	inc r15
	mov al, byte [r15]
	cmp al, 117 ; u
	je inspect_format_lu

	mov edi, 37 ; %
	mov rsi, [stdout]
	call putc
	inc r14
	mov edi, 108 ; l
	mov rsi, [stdout]
	call putc
	inc r14

	mov al, byte [r15]

	cmp al, 0 ; verificare caracter null
	je finish
	movzx edi, al
	mov rsi, [stdout]
	call putc
	inc r14
	inc r15
	jmp go_through_format_string
inspect_format_lu:
	cmp r13, 5 ; a depasit cele 5 registre?
	jge format_stack3

	mov rax, r13
	mov rcx, 8 ; inmultesc cu QWORD
	mul rcx
	mov rcx, rbp
	sub rcx, 8 ;; baza
	sub rcx, rax
	mov rax, QWORD [rcx]
	jmp format_lu
format_stack3:
	mov rax, r13
	sub rax, 5 ; scad cele 5 argumente
	mov rcx, 8 ; inmultesc cu 8 QWORD
	mul rcx
	mov rcx, rbp
	add rcx, 16 ; interactionez cu argumentele mele
	add rcx, rax
	mov rax, QWORD [rcx]
format_lu:
	inc r13

	cmp rax, 0 ; compar cu 0
	jne setup_lu_div
	mov edi, 48 ; 0 ascii
	mov rsi, [stdout]
	call putc
	inc r14
	inc r15
	jmp go_through_format_string
setup_lu_div:
	mov rbx, 10 ; impartitor pentru scos elemente
	xor r12, r12 ; index stiva 
format_lu_div:
	cmp rax, 0 ; compar cand devine catul 0
	je lu_print

	xor rdx, rdx
	div rbx

	mov byte [rsp + r12], dl
	inc r12
	jmp format_lu_div
lu_print:
	cmp r12, 0 ; s-a terminat??
	je lu_end

	dec r12
	movzx edi, byte [rsp + r12]
	add rdi, 48 ; 0 ascii, adunat ca sa-mi devina caracter
	mov rsi, [stdout]
	call putc
	inc r14
	jmp lu_print
lu_end:
	add r15, 1 ; mareste index
	jmp go_through_format_string
finish:
	mov rax, r14

	pop r12
	pop r14
	pop r13
	pop r15
	pop rbx
	add rsp, 40 ; eliberarea stivei
	leave
	ret
