section .text

;; DO NOT MODIFY
global check_column
global check_row
global check_box

; int check_row(int **array, int size, int rowNr)
; rdi = int **array
; rsi = int size
; rdx = int rowNr
check_row:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here
	xor r9, r9
	xor r10, r10
verify_array_col_with_add:
	mov rax, [rdi + rdx * 8] ; pointer to row
	add r10d, [rax + r9 * 4] ; calcul suma
	inc r9
	cmp r9, rsi
	jl verify_array_col_with_add
	xor r9, r9
	mov r12, rdx
	mov r14, 1 ; elementul pentru inmultire
verify_array_col_with_mul:
	mov r15, [rdi + r12 * 8] ; salvez un pointer
	xor rcx, rcx
	mov ecx, [r15 + r9 * 4] ; pregatirea inmultirii
	mov rax, r14
	mul rcx
	mov r14, rax
	inc r9
	cmp r9, rsi
	jl verify_array_col_with_mul
comparison_of_values:
	mov r14, rax
	mov r13, rsi
	xor rdx, rdx
	inc r13
	mov rax, r13
	mov rbx, 2 ; suma lui gauss
	mul rsi
	xor rdx, rdx
	div rbx
	mov r13, rax
	mov rax, 1 ; fact = 1
	mov rbx, 1 ; i = 1
factorial:
	mul rbx
	inc rbx
	cmp rbx, rsi
	jle factorial
	cmp r10, r13
	je finished_good_partial
	jmp finished_bad
finished_bad:
	mov rax, 0 ; a dat fail
	jmp done
finished_good_partial:
	cmp rax, r14
	je finished_good
	jmp finished_bad
finished_good:
	mov rax, 1 ; success
done:
	;; Your code ends here
	;; DO NOT MODIFY
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
	;; DO NOT MODIFY

;; DO NOT MODIFY
; int check_column(int **array, int size, int columnNr)
; rdi = int **array
; rsi = int size
; rdx = int columnNr
check_column:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here
	xor r9, r9
	xor r10, r10
verify_array_col_with_add_1:
	mov rax, [rdi + r9 * 8] ; pointer
	add r10d, [rax + rdx * 4] ; calcul suma
	inc r9
	cmp r9, rsi
	jl verify_array_col_with_add_1
	xor r9, r9
	mov r12, rdx
	mov r14, 1 ; elementul pentru inmultire
verify_array_col_with_mul_1:
	mov r15, [rdi + r9 * 8] ; get pointer
	xor rcx, rcx
	mov ecx, [r15 + r12 * 4] ; pregatirea inmultirii
	mov rax, r14
	mul rcx
	mov r14, rax
	inc r9
	cmp r9, rsi
	jl verify_array_col_with_mul_1
comparison_of_values_1:
	mov r14, rax
	mov r13, rsi
	xor rdx, rdx
	inc r13
	mov rax, r13
	mov rbx, 2 ; suma lui gauss
	mul rsi
	xor rdx, rdx
	div rbx
	mov r13, rax
	mov rax, 1 ; fact = 1
	mov rbx, 1 ; i = 1
factorial_1:
	mul rbx
	inc rbx
	cmp rbx, rsi
	jle factorial_1
	cmp r10, r13
	je finished_good_partial_1
	jmp finished_bad_1
finished_bad_1:
	mov rax, 0 ; a dat fail
	jmp done_1
finished_good_partial_1:
	cmp rax, r14
	je finished_good_1
	jmp finished_bad_1
finished_good_1:
	mov rax, 1 ; success
done_1:
	;; Your code ends here
	;; DO NOT MODIFY
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
	;; DO NOT MODIFY

;; DO NOT MODIFY
; int check_box(int **array, int size, int boxNr)
; rdi = int **array
; rsi = int size
; rdx = int boxNr
check_box:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here
	xor r9, r9
	xor r10, r10
	xor rbx, rbx
	xor rcx, rcx
verify_size:
	cmp rsi, 4 ; verify if 4x4
	je calculate_box_coordinates_4
	cmp rsi, 9 ; verify if 9x9
	je calculate_box_coordinates_9
	cmp rsi, 16 ; verify if 16x16
	je calculate_box_coordinates_16
calculate_box_coordinates_4:
	mov r10, rdx
	xor rdx, rdx
	mov rax, r10
	mov r8, 2 ; sqrt(4) daca size e 4
	div r8
	mov r11, rdx
	mul r8
	mov r12, rax
	mov rax, r11
	mul r8
	mov r13, rax
	jmp multiply_set
calculate_box_coordinates_9:
	mov r10, rdx
	xor rdx, rdx
	mov rax, r10
	mov r8, 3 ; sqrt(9) daca size e 9
	div r8
	mov r11, rdx
	mul r8
	mov r12, rax
	mov rax, r11
	mul r8
	mov r13, rax
	jmp multiply_set
calculate_box_coordinates_16:
	mov r10, rdx
	xor rdx, rdx
	mov rax, r10
	mov r8, 4 ; sqrt(16) daca size e 16
	div r8
	mov r11, rdx
	mul r8
	mov r12, rax
	mov rax, r11
	mul r8
	mov r13, rax
multiply_set:
	mov r10, 1 ; valoarea initiala pentru inmultire
verify_index_size:
	cmp r9, r8
	jge finish
	xor r15, r15
go_through_box:
	cmp r15, r8
	je increment_i
	mov rax, r12
	add rax, r9
	mov r14, [rdi + 8 * rax] ; pointer la linie
	mov rax, r13
	add rax, r15
	mov ebx, [r14 + 4 * rax] ; salvez elementul din matrice
	add ecx, ebx ; adaug la suma
	mov rax, r10
	mul rbx
	mov r10, rax
	inc r15
	jmp go_through_box
increment_i:
	inc r9
	jmp verify_index_size
finish:
	mov r14, r10 ; mutam produsul in r14
	mov r10, rcx ; mutam suma in r10
comparison_of_values_2:
	mov r13, rsi
	xor rdx, rdx
	inc r13
	mov rax, r13
	mov rbx, 2 ; suma lui gauss
	mul rsi
	xor rdx, rdx
	div rbx
	mov r13, rax
	mov rax, 1 ; fact = 1
	mov rbx, 1 ; i = 1
factorial_2:
	mul rbx
	inc rbx
	cmp rbx, rsi
	jle factorial_2
	cmp r10, r13
	je finished_good_partial_2
	jmp finished_bad_2
finished_bad_2:
	mov rax, 0 ; a dat fail
	jmp done_2
finished_good_partial_2:
	cmp rax, r14
	je finished_good_2
	jmp finished_bad_2
finished_good_2:
	mov rax, 1 ; success
done_2:
	;; Your code ends here
	;; DO NOT MODIFY
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret