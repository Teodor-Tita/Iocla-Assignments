section .text

;; DO NOT MODIFY
global fix_lap_times


fix_lap_times:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    ;; DO NOT MODIFY
    ;; YOUR CODE STARTS HERE

    xor r9, r9
    mov r10, rdx
    dec r10

    mov DWORD [r8], 0 ; erorile la 0

loop_for_err_arr:
    cmp byte [rsi + r9], 0 ; verifica daca e data valida
    jz error_0
    cmp byte [rsi + r9], 1 ; verifica daca e data corupta
    jz error_1
error_0:
    mov r15d, [rdi + r9 * 4] ; incarca timpul in 4 bytes
    mov [rcx + r9 * 4], r15d ; salveaza timpul in output, tot 4 bytes
    inc r9
    cmp r9, r10 
    jle loop_for_err_arr
    jmp end_loop
error_1:
    cmp r9, 0 ; verificam daca suntem la primul index
    je error_1_start
    cmp r9, r10
    je error_1_finish
    mov r11, r9
    dec r11
    mov r12, r9
    inc r12
    xor edx, edx
    mov eax, [rdi + r11 * 4] ; iau timpul de dinainte 
    add eax, [rdi + r12 * 4] ; adaug timpul urmator
    mov ebx, 2 ; media aritmetica
    div ebx
    mov [rcx + r9 * 4], eax ; salvez acest timp
    inc r9
    inc DWORD [r8]
    cmp r9, r10
    jle loop_for_err_arr
    jmp end_loop
error_1_start:
    cmp r9, r10
    je error_1_1driver
    inc r9
    mov r13d, [rdi + r9 * 4] ; extrag urmatorul timp 
    dec r9
    mov [rcx + r9 * 4], r13d ; salvez urmatorul timp la output
    inc r9
    inc DWORD [r8]
    cmp r9, r10
    jle loop_for_err_arr
    jmp end_loop
error_1_finish:
    dec r9
    mov r14d, [rdi + r9 * 4] ; extrag timpul de dinainte
    inc r9
    mov [rcx + r9 * 4], r14d ; salvez timpul de dinainte la output
    inc DWORD [r8]
    jmp end_loop
error_1_1driver:
    inc DWORD [r8]
    xor r9, r9
    mov r11d, [rdi + r9 * 4] ; extrag timpul daca e un singur driver
    mov [rcx + r9 * 4], r11d ; salvez acest timp la output
end_loop:
    ;; YOUR CODE ENDS HERE
    ;; DO NOT MODIFY
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
    ;; DO NOT MODIFY