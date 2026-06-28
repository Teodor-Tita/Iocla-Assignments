; write the structures
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
global filter_flights

; void filter_flights(struct flight* origFlights, struct flight* finalFlights
;						 int* nrFlights, int min_bag_weight)
; rdi = struct flight *origFlights
; rsi = struct flight *finalFlights
; rdx = int *nrFlights
; rcx = int min_bag_weight
filter_flights:
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
	xor r11, r11
	xor r12, r12
	xor r14, r14
size_flight_cmp:
	cmp r9d, DWORD [rdx]
	je finished
go_through_array:
	xor r8, r8
	mov r8w, WORD [rdi + r11 + flight.bag_weight]
	cmp r8d, ecx
	jge add_to_final_array
	inc r9
	add r11, 42 ; fiind pointer de structuri, trec la urmatorul struct
	jmp size_flight_cmp
add_to_final_array:
	; se transfera datele din origflights in finalflights
	mov r8, QWORD [rdi + r11]
	mov QWORD [rsi + r14], r8 ; primeste 8 bytes
	mov r8, QWORD [rdi + r11 + 8] ; trimite 8 bytes
	mov QWORD [rsi + r14 + 8], r8 ; primeste 8 bytes
	mov r8, QWORD [rdi + r11 + 16] ; trimite 8 bytes
	mov QWORD [rsi + r14 + 16], r8 ; primeste 8 bytes
	mov r8, QWORD [rdi + r11 + 24] ; trimite 8 bytes
	mov QWORD [rsi + r14 + 24], r8 ; primeste 8 bytes
	mov r8, QWORD [rdi + r11 + 32] ; trimite 8 bytes
	mov QWORD [rsi + r14 + 32], r8 ; primeste 8 bytes
	mov r8w, WORD [rdi + r11 + 40] ; trimite 2 bytes
	mov WORD [rsi + r14 + 40], r8w ; primeste 2 bytes
	inc r10
	inc r12
	inc r9
	add r11, 42 ; trec la urmatorul struct
	add r14, 42 ; trec la urmatorul struct
	jmp size_flight_cmp
finished:
	mov DWORD [rdx], r12d
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

	leave
	ret