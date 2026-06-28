section .note.GNU-stack

section .data
type_string db "%s", 0 ; printare de string, cu caracterul null
type_long db "%ld", 10, 0 ; printare de long cu newline si caracterul null

section .text
extern scanf
extern printf
extern atol

global reverse_polish_notation

reverse_polish_notation:
	push rbp
	mov rbp, rsp
	push r13
	push r12
	xor rax, rax
	xor rcx, rcx
	xor r8, r8
	sub rsp, 32 ; imi iau spatiu pe stiva
	mov r12, rsp
scanf_function:
	mov rax, rsp
	xor rdx, rdx
	mov rcx, 16 ; impart cu 16 pentru aliniere corecta
	div rcx

	mov r13, rdx ; restul
	sub rsp, r13

	mov rdi, type_string
	mov rsi, r12
	xor rax, rax
	call scanf

	add rsp, r13

	cmp eax, 1 ; 1 daca a citit scanf
	jne finished_eof

	mov al, byte [r12]

operation_add:
	cmp al, 43 ; +
	jne operation_minus
	pop r8
	pop rax
	add rax, r8
	jmp push_and_read
operation_minus:
	cmp al, 45 ; -
	jne operation_mul
	pop r8
	pop rax
	sub rax, r8
	jmp push_and_read
operation_mul:
	cmp al, 42 ; *
	jne operation_div
	pop r8
	pop rax
	xor rdx, rdx
	mul r8
	jmp push_and_read
operation_div:
	cmp al, 47 ; /
	jne convert_with_atol
	pop r8
	pop rax
	xor rdx, rdx
	div r8
	jmp push_and_read
convert_with_atol:
	mov rax, rsp
	xor rdx, rdx
	mov rcx, 16 ; impart din nou pentru aliniere cu 16
	div rcx

	mov r13, rdx
	sub rsp, r13

	mov rdi, r12
	call atol
	add rsp, r13
push_and_read:
	push rax
	jmp scanf_function
finished_eof:
	pop rsi

	mov rax, rsp
	xor rdx, rdx
	mov rcx, 16 ; din nou impart
	div rcx
	mov r13, rdx
	sub rsp, r13

	mov rdi, type_long
	xor rax, rax
	call printf

	add rsp, r13
	add rsp, 32 ; eliberarea stivei

	pop r12
	pop r13

	leave
	ret
