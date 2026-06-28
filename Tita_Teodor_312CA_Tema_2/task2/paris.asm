; you can declare any helper variables in .data or .bss

section .text

;; DO NOT MODIFY
global solve_labyrinth

solve_labyrinth:
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15

    mov     r12, rdi
    mov     r13, rsi
    mov     r14, rdx
    mov     r15, rcx
    mov     rbx, r8
    ;; DO NOT MODIFY
    ;; YOUR CODE STARTS HERE
    xor r9, r9 ; index pentru linie
    xor r10, r10 ; index pentru coloana
    xor r11, r11
    mov rax, [rbx + 8 * r9] ; primul pointer din vectorul de pointeri
    mov byte [rax + r10], 0x31

check_size:
    mov rax, r14
    dec rax
    cmp r9, rax
    je found
    mov rax, r15
    dec rax
    cmp r10, rax
    je found
verify_next_down:
    inc r9
    mov rax, [rbx + 8 * r9] ; verificare cu acel vector de pointeri
    cmp byte [rax + r10], 0x30
    je mark_with_one
    dec r9
verify_next_right:
    inc r10
    mov rax, [rbx + 8 * r9] ; verificare cu acel vector de pointeri
    cmp byte [rax + r10], 0x30
    je mark_with_one
    dec r10
verify_next_up:
    dec r9
    mov rax, [rbx + 8 * r9] ; verificare cu acel vector de pointeri
    cmp byte [rax + r10], 0x30
    je mark_with_one
    inc r9
verify_next_left:
    dec r10
    mov rax, [rbx + 8 * r9] ; verificare cu acel vector de pointeri
    cmp byte [rax + r10], 0x30
    je mark_with_one
    inc r10
    jmp check_size
mark_with_one:
    ; pun in rax la toate verificarile 
    mov rax, [rbx + 8 * r9] ; verificare cu acel vector de pointeri
    mov byte [rax + r10], 0x31
    jmp check_size
found:
    mov DWORD [r12], r9d
    mov DWORD [r13], r10d
    ;; YOUR CODE ENDS HERE
    ;; DO NOT MODIFY
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    pop     rbp
    ret
    ;; DO NOT MODIFY