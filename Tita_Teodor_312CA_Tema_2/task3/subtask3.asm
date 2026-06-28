; write the structure
struc flight
	.destination: resb 32
	.departingTime.day: resb 1
	.departingTime.hour: resb 1
	.departingTime.minutes: resb 1
	.arrivingTime.day: resb 1
	.arrivingTime.hour: resb 1
	.arrivingTime.minutes: resb 1
	.bag_weight: resb 2
	.delayMinutes: resb 1
	.delayHours: resb 1
endstruc


section .text

;; DO NOT MODIFY
global sort_and_return

; int sort_and_return(struct flight* flights, int nrFlights, 
;                      struct flight* bestFlight, char destination[32])
; rdi = flights (pointer)
; rsi = nrFlights (value)
; rdx = bestFlight (pointer to pre-allocated struct)
; rcx = destination (pointer to 32-byte string)
sort_and_return:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here
	xor r8, r8
	xor r9, r9
	xor r10, r10
	xor r11, r11
verify_flights_number:
	mov rax, rsi
	dec rax
	cmp r8, rax
	je finished_sorting
	mov r9, r8
	inc r9
	mov r11, r10
	add r11, 42 ; trec la urmatorul struct
next_r9:
	cmp r9, rsi
	jge continue_outer_loop
compare_arrival_time:
	mov al, [rdi + r10 + flight.arrivingTime.day]
	cmp al, [rdi + r11 + flight.arrivingTime.day]
	jg construct_if_greater
	jl continue_inner_loop
compare_arrival_time_hours:
	mov al, [rdi + r10 + flight.arrivingTime.hour]
	cmp al, [rdi + r11 + flight.arrivingTime.hour]
	jg construct_if_greater
	jl continue_inner_loop
compare_arrival_time_minutes:
	mov al, [rdi + r10 + flight.arrivingTime.minutes]
	cmp al, [rdi + r11 + flight.arrivingTime.minutes]
	jg construct_if_greater
	jl continue_inner_loop
compare_bag_weight:
	mov ax, [rdi + r10 + flight.bag_weight]
	cmp ax, [rdi + r11 + flight.bag_weight]
	jl construct_if_greater
	jmp continue_inner_loop
construct_if_greater:
	mov r12, QWORD [rdi + r10] ; trimite 8 bytes
	mov r13, QWORD [rdi + r11] ; trimite 8 bytes
	mov QWORD [rdi + r10], r13 ; primeste 8 bytes
	mov QWORD [rdi + r11], r12 ; primeste 8 bytes
	mov r12, QWORD [rdi + r10 + 8] ; trimite 8 bytes
	mov r13, QWORD [rdi + r11 + 8] ; trimite 8 bytes
	mov QWORD [rdi + r10 + 8], r13 ; primeste 8 bytes
	mov QWORD [rdi + r11 + 8], r12 ; primeste 8 bytes
	mov r12, QWORD [rdi + r10 + 16] ; trimite 8 bytes
	mov r13, QWORD [rdi + r11 + 16] ; trimite 8 bytes
	mov QWORD [rdi + r10 + 16], r13 ; primeste 8 bytes
	mov QWORD [rdi + r11 + 16], r12 ; primeste 8 bytes
	mov r12, QWORD [rdi + r10 + 24] ; trimite 8 bytes
	mov r13, QWORD [rdi + r11 + 24] ; trimite 8 bytes
	mov QWORD [rdi + r10 + 24], r13 ; primeste 8 bytes
	mov QWORD [rdi + r11 + 24], r12 ; primeste 8 bytes
	mov r12, QWORD [rdi + r10 + 32] ; trimite 8 bytes
	mov r13, QWORD [rdi + r11 + 32] ; trimite 8 bytes
	mov QWORD [rdi + r10 + 32], r13 ; primeste 8 bytes
	mov QWORD [rdi + r11 + 32], r12 ; primeste 8 bytes
	mov r12w, WORD [rdi + r10 + 40] ; trimite 2 bytes
	mov r13w, WORD [rdi + r11 + 40] ; trimite 2 bytes
	mov WORD [rdi + r10 + 40], r13w ; primeste 2 bytes
	mov WORD [rdi + r11 + 40], r12w ; primeste 2 bytes
continue_inner_loop:
	inc r9
	add r11, 42 ; trec la urmatorul struct
	jmp next_r9
continue_outer_loop:
	inc r8
	add r10, 42 ; trec la urmatorul struct
	jmp verify_flights_number
finished_sorting:
	xor r8, r8
	xor r10, r10
search_loop:
	cmp r8, rsi
	jge not_found
	lea r11, [rdi + r10]
	xor r9, r9
compare_string:
	cmp r9, 32 ; marimea string ului destinatie 
	jge string_matched
	mov al, [r11 + flight.destination + r9] 
	mov bl, [rcx + r9]                            
	cmp al, bl
	jne next_flight
	cmp al, 0 ; compar cu caracterul NULL pentru string uri
	je string_matched
	inc r9
	jmp compare_string
next_flight:
	inc r8
	add r10, 42 ; trec la urmatorul struct
	jmp search_loop
string_matched:
	mov r12, QWORD [rdi + r10]
	mov QWORD [rdx], r12 ; primeste 8 bytes
	mov r12, QWORD [rdi + r10 + 8] ; trimite 8 bytes
	mov QWORD [rdx + 8], r12 ; primeste 8 bytes
	mov r12, QWORD [rdi + r10 + 16] ; trimite 8 bytes
	mov QWORD [rdx + 16], r12 ; primeste 8 bytes
	mov r12, QWORD [rdi + r10 + 24] ; trimite 8 bytes
	mov QWORD [rdx + 24], r12 ; primeste 8 bytes
	mov r12, QWORD [rdi + r10 + 32] ; trimite 8 bytes
	mov QWORD [rdx + 32], r12 ; primeste 8 bytes
	mov r12w, WORD [rdi + r10 + 40] ; trimite 2 bytes
	mov WORD [rdx + 40], r12w ; primeste 2 bytes
	mov rax, 1 ; succes, a mers
	jmp finished
not_found:
	mov rax, 0 ; fals, nu s-a gasit
finished:
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