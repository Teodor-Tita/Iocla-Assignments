section .note.GNU-stack

section .data
invalid_length db "Error: len <= %d", 10, 0 ; stirng, 10 newline, 0 caracter null
empty_array db "The vector is empty", 10, 0 ; string, 10 newline, 0 caracter null

print1 db "v -> {(", 0 ; partea de inceput + caracterul null
print2 db "[%d]", 0 ; elementele vectorului + caracterul null
print3 db "[]", 0 ; elemente nealocate + caracterul null
print4 db "), %d, %d}", 10, 0 ; partea de final, 10 newline, 0 null

section .text
extern malloc
extern free
extern realloc
extern printf

global new_vector
global set_element
global get_element
global push_element
global pop_element
global print_vector
global free_vector

;	struct vector {
;		int *arr;
;		int len;
;		int cap;
;	}

struc vector 
	.arr: resq 1
	.len: resd 1
	.cap: resd 1
endstruc

new_vector:
push rbp
mov rbp, rsp
xor rax, rax

push r14
push r15

movsxd r14, edi ; salvez capacitatea
mov rdi, 16 ; cat are structul
call malloc

mov r15, rax ; salvez pointerul la structura

mov rdi, r14
mov rax, rdi
xor rdx, rdx
mov rcx, 4 ; inmultesc cu DWORD
mul rcx

mov rdi, rax ; inmultesc nr elemente cu bytes
call malloc 

mov qword [r15], rax  
mov dword [r15 + vector.len], 0 ; clarific vectorul dinamic prin struct
mov dword [r15 + vector.cap], r14d ; capacitatea

mov rax, r15 ; bag in rax adresa vectorului

pop r15
pop r14

leave
ret
set_element:
push rbp
mov rbp, rsp
xor rax, rax

push r13
push r14

mov r13, [rdi]
mov r14d, [rdi + vector.len] ; length
cmp edx, r14d
jge failed
movsxd rdx, edx
mov [r13 + 4 * rdx], esi ; 4 DWORD, salvez unde vreau
mov rax, rdx
jmp skip_failed

failed:
mov rdi, invalid_length
mov esi, edx
mov al, 0 ; printf
call printf
mov rax, -1 ; eroare
skip_failed:
pop r14
pop r13

leave
ret

get_element:
push rbp
mov rbp, rsp
xor rax, rax

push r13
push r14
push r15

mov r13, [rdi]
mov r14d, [rdi + vector.len] ; lenght
cmp esi, r14d
jge failed1
movsxd rsi, esi
mov r15d, [r13 + rsi * 4] ; 4 DWORD, salvare element
mov eax, r15d
jmp skip_failed1

failed1:
mov rdi, invalid_length
mov al, 0 ; printf
call printf
mov rax, -1 ; eroare
skip_failed1:
pop r15
pop r14
pop r13
leave
ret

push_element:
push rbp
mov rbp, rsp
xor rax, rax

push r12
push r13
push r14
push r15

mov r15, rdi
mov r13d, esi
mov r14d, [rdi + vector.len] ; lungimea
mov r12d, [rdi + vector.cap] ; capacitatea

cmp r12d, r14d
jne same_capacity

double_capacity:
add r12d, r12d ; dublarea capacitatii
mov rdi, [r15]
mov rsi, r12
mov [r15 + vector.cap], r12d ; capacitatea
mov rax, rsi
xor rdx, rdx
mov r8, 4 ; cu cat voi inmulti, 4 DWORD
mul r8
mov rsi, rax
call realloc
mov [r15], rax
jmp same_capacity

same_capacity:
mov rcx, [r15]
movsxd r14, r14d
mov [rcx + r14 * 4], r13d ; 4 DWORD, se baga la final
mov eax, r14d

mov r11d, [r15 + vector.len] ; length
inc r11d
mov [r15 + vector.len], r11d ; salvare nou length

pop r15
pop r14
pop r13
pop r12

leave
ret

pop_element:
push rbp
mov rbp, rsp
xor rax, rax
push r12
push rbx
push r13
push r14
push r15

mov r15, [rdi]
mov r13, rdi
mov r14d, [rdi + vector.len] ; lungimea
mov r12d, [rdi + vector.cap] ; capacitatea

cmp r14d, 0 ; e gol??
je no_elements

dec r14d
mov [r13 + vector.len], r14d ;; length
movsxd r14, r14d
mov ebx, [r15 + r14 * 4] ;; 4 DWORD, ultimul element

xor rdx, rdx
mov eax, r12d
mov ecx, 2 ; impart la 2
div ecx

mov r8d, eax

cmp r8d, 1 ;; minim noua capacitate
jl has_elements

cmp r8d, r14d
jge half_capacity
has_elements:
mov eax, ebx
jmp finish
half_capacity:
mov rdi, r15
mov r12d, r8d
mov rsi, r12
mov [r13 + vector.cap], r12d ; noua capacitate
add rsi, rsi
add rsi, rsi
call realloc
mov [r13], rax
jmp has_elements
no_elements:
mov rdi, empty_array
mov al, 0 ; printf
call printf
mov rax, -1 ; eroare
finish:
pop r15
pop r14
pop r13
pop rbx
pop r12

leave
ret

print_vector:
push rbp
mov rbp, rsp
xor rax, rax
push r12
push r13
push r14
push r15

mov r15, [rdi]
mov r14d, [rdi + vector.len] ; length
mov r12d, [rdi + vector.cap] ; capacitatea

mov rdi, print1
mov al, 0 ; printf
call printf

sub r13d, r13d ; index parcurgere vector

go_through_array:
cmp r13d, r14d
je add_blank_cases_if_there_are

mov rdi, print2
movsxd r13, r13d
mov esi, DWORD [r15 + r13 * 4] ; 4 DWORD, salvare elem
mov al, 0 ; printf
call printf

inc r13d
jmp go_through_array
add_blank_cases_if_there_are:
cmp r13d, r12d
je no_elements_or_reached_length

mov rdi, print3
mov al, 0 ; printf
call printf

inc r13d
jmp add_blank_cases_if_there_are
no_elements_or_reached_length:
mov rdi, print4
mov esi, r14d
mov edx, r12d
mov al, 0 ; printf
call printf

pop r15
pop r14
pop r13
pop r12

leave
ret

free_vector:
push rbp
mov rbp, rsp
xor rax, rax

push r14
push r13

mov r14, rdi

cmp r14, 0 ; e pointerul strucuturii null??
je finished

mov r13, [r14]
cmp r13, 0 ; e pointerul null?
je finished

mov rdi, [r13]
call free

mov rdi, r13
call free
mov QWORD [r14], 0 ;; pointerul structurii devine null
finished:
pop r13
pop r14

leave
ret
