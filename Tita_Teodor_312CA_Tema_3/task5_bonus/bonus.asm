section .note.GNU-stack

section .data
succes db "The number is heavy", 10, 0 ; string, 10 newline si 0 caracter null
failure db "The number is not heavy", 10, 0 ; string, 10 newline si 0 caracter null
for_flat_matrix db "%d", 10, 0 ; printare de intreg, 10 newline si 0 caracter null

section .text
extern printf

global ave
global switch_cases
global heavy
global flat_matrix

ave:
    push rbp
    mov rbp, rsp
    xor rax, rax
    mov r10d, edx
    push rbx
    xor r8, r8
go_through_array:
    mov bl, byte [rdi + r8]
    cmp bl, 0 ; caracterul null
    je end_of_src
    cmp bl, 10 ; caracterul newline
    je end_of_src
    movzx ebx, bl
    sub ebx, 65 ;; litera A
    add ebx, r10d
    mov eax, ebx
    cdq
    mov ecx, 31 ; cu ce impart
    idiv ecx
    add edx, 31 ; cu ce adun
    mov eax, edx
    cdq
    idiv ecx
    add edx, 65 ; litera A
    mov byte [rsi + r8], dl
    inc r8
    jmp go_through_array
end_of_src:
    mov byte [rsi + r8], 0 ; adaug caracterul null
    mov rax, rsi
    pop rbx
    leave
    ret
switch_cases:
    push rbp
    mov rbp, rsp
    push rbx
    xor rax, rax
    sub r14, r14
go_through_array1:
    mov bl, byte [rdi + r14]
    cmp bl, 0 ; caracterul null
    je end_of_src1
    cmp bl, 10 ; caracterul newline
    je end_of_src1
mark_non_letters:
    cmp bl, 65 ; litera A
    jl not_a_letter
    cmp bl, 122 ; litera z
    jg not_a_letter
    cmp bl, 97 ; litera a
    jl maybe_a_letter
    jge is_a_letter
maybe_a_letter:
    cmp bl, 90 ; litera Z
    jg not_a_letter
is_a_letter:
    cmp bl, 90 ; litera Z
    jle was_lowercase
    cmp bl, 97 ; litera a
    jge was_uppercase
was_lowercase:
    add bl, 32 ; conversia
    jmp replace_now
was_uppercase:
    sub bl, 32 ; conversia
replace_now:
    mov byte [rsi + r14], bl
    inc r14
    jmp go_through_array1
not_a_letter:
    mov byte [rsi + r14], bl
    inc r14
    jmp go_through_array1
end_of_src1:
    mov byte [rsi + r14], 0 ; adaug caracterul null
    mov rax, rsi
    pop rbx
    leave
    ret
heavy:
    push rbp
    mov rbp, rsp
    xor rax, rax
    mov r9d, edi
    mov r10d, edi
    push rbx
    cmp r10d, 0 ; verificare negativ
    jl msb_is_1
    jmp is_not_heavy
msb_is_1:
    mov eax, r10d
    shr eax, 16 ; 16 biti la dreapta
    mov bl, al
    mov al, ah
    mov ah, bl
    movzx eax, ax
    cmp eax, 255 ; cu cat cere cerinta sa compar
    jg is_heavy
is_not_heavy:
    lea rdi, [rel failure]
    xor rax, rax
    call printf
    jmp finished
is_heavy:
    lea rdi, [rel succes]
    xor rax, rax
    call printf
finished:
    pop rbx
    leave
    ret
flat_matrix:
    push rbp
    mov rbp, rsp
    xor rax, rax
    push r12
    push r13
    push r14
    push r15
    push rbx
    mov r12, rdi
    movsxd r13, esi
    cmp r13, 0 ; ordin 0??
    jle finished1

    mov rax, r13
    mov r15, 4 ;; inmultesc cu DWORD
    mul r15
    mov r15, rax

    mov r14, 0 ; ia valoarea 0 (indexul)
choose_column:
    cmp r14, r13
    jge finished1

    mov rax, r13
    dec rax

    imul rax, r15

    push rax
    mov rax, r14
    mov rcx, 4 ; inmultesc cu DWORD
    mul rcx
    mov rcx, rax
    pop rax

    add rax, rcx

    lea rdx, [r12 + rax]
    mov ebx, DWORD [rdx]

    mov r11, r13
    dec r11
find_max:
    cmp r11, 0 ; s-a terminat?
    jle show_maximum

    sub rdx, r15

    mov eax, DWORD [rdx]
    cmp eax, ebx
    jle go_next
    mov ebx, eax
go_next:
    dec r11
    jmp find_max
show_maximum:
    push r11
    lea rdi, [rel for_flat_matrix]
    mov esi, ebx
    sub rax, rax
    call printf
    pop r11
    inc r14
    jmp choose_column
finished1:
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    leave
    ret
