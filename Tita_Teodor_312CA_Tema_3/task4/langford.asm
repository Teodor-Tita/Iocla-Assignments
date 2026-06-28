section .note.GNU-stack

section .text
extern malloc
extern free

global check_langford
global generate_langford_sequences

struc vector 
	.arr: resq 1
	.len: resd 1
	.cap: resd 1
endstruc

new_vector:
push rbp
mov rbp, rsp
push r14
push r15

movsxd r14, edi ; salvez capacitatea
mov rdi, 16 ; cat e strucutra
call malloc

mov r15, rax ; salvez pointerul la structura

mov rdi, r14
mov rax, rdi
xor rdx, rdx
mov rcx, 4 ; inmultesc cu DWORD
mul rcx

mov rdi, rax ; inmultesc nr elemente cu bytes
call malloc 

mov QWORD [r15], rax
mov DWORD [r15 + vector.len], 0 ; clarific vectorul dinamic prin struct
mov DWORD [r15 + vector.cap], r14d ; capacitatea

mov rax, r15 ; bag in rax adresa vectorului

pop r15
pop r14
leave
ret

free_vector:
push rbp
mov rbp, rsp
xor rax, rax

push r14
sub rsp, 8 ; aliniere stiva
mov r14, rdi

cmp r14, 0 ; pointerul structurii e null??
je finish2

mov rdi, [r14]
cmp rdi, 0 ; e pointerul null??
je free_struct
call free

free_struct:
mov rdi, r14
call free

finish2:
add rsp, 8 ; aliniere stiva
pop r14

leave
ret

check_langford:
push rbp
mov rbp, rsp
xor rax, rax
sub r8, r8
push r12
push r13
push r14
push r15
push rbx
sub rsp, 8 ; ma mut 8 bytes pe stiva
sub r13, r13

mov r15d, esi
mov r14, rdi

mov eax, esi
mov edx, 0 ; ia valoarea 0
mov ecx, 2 ; cu cat impart
div ecx

cmp edx, 0 ;; verific cu restul
jne finished_bad

mov r12d, eax

mov edi, r12d
inc edi
call new_vector
mov r13, rax
mov rbx, [rax]

xor rax, rax
mov ecx, r12d
inc ecx
zeros_in_frequency_array:
mov DWORD [rbx + rax * 4], 0 ; initiez cu zero tot, 4 DWORD
inc rax
cmp rax, rcx
jl zeros_in_frequency_array

mov r9, r14
xor r8, r8
go_through_array:
cmp r8d, r15d
je finished_good

mov r10d, DWORD [r9 + r8 * 4] ; salvez elem, 4 DWORD

cmp r10d, 1 ; limita
jl finished_bad
cmp r10d, r12d
jg finished_bad

movsxd r11, r10d
mov eax, DWORD [rbx + r11 * 4] ; verificare vector frecventa, 4 DWORD

cmp eax, 0 ; nu a aparut inainte
je first_appearance
cmp eax, 1 ; a aparut inainte
je second_appearance

jmp finished_bad

second_appearance:
mov DWORD [rbx + r11 * 4], 2 ; marchez 2 aparitii, 4 DWORD
go_next:
inc r8
jmp go_through_array
first_appearance:
mov DWORD [rbx + r11 * 4], 1 ; marchez 1, 4 DWORD

mov ecx, r8d
add ecx, r10d
inc ecx

cmp ecx, r15d
jge finished_bad

movsxd rcx, ecx
mov edx, DWORD [r9 + rcx * 4] ; accesez un element, 4 DWORD
cmp edx, r10d
jne finished_bad

jmp go_next
finished_good:
mov r12d, 1 ; true
jmp free_frequency_array

finished_bad:
mov r12d, 0 ; false

free_frequency_array:
cmp r13, 0 ; e null??
je finished
mov rdi, r13
call free_vector
finished:
mov eax, r12d

add rsp, 8 ;; refacere stiva
pop rbx
pop r15
pop r14
pop r13
pop r12

leave
ret

generate_langford_sequences:
push rbp
mov rbp, rsp
xor rax, rax
; TODO - write the generate_langford_sequences function
leave
ret

