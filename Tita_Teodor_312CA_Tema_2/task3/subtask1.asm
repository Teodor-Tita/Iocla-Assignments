; write the structures. make sure it fits the layour in the README
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
global apply_delay

; void apply_delay(struct flight* flights, int nrFlights)
; rdi = struct flight *flightss
; rsi = int nrFlights
apply_delay:
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
compare_number_flights:
	cmp r9, rsi
	jl go_through_array
	cmp r9, rsi
	jz finished
go_through_array:
	mov r10b, byte [rdi + flight.delayMinutes]
	mov r11b, byte [rdi + flight.delayHours]
	add byte [rdi + flight.departingTime.minutes], r10b
	; verific overflow minute
	cmp byte [rdi + flight.departingTime.minutes], 60
	jge recalculate_min
verify_arrive_min:
	add byte [rdi + flight.arrivingTime.minutes], r10b
	; verific overflow minute
	cmp byte [rdi + flight.arrivingTime.minutes], 60
	jge recalculate_min_arrive
verify_depart_hour:
	add byte [rdi + flight.departingTime.hour], r11b
	; verific overflow ore
	cmp byte [rdi + flight.departingTime.hour], 24
	jge recalculate_hour
verify_arrive_hour:
	add byte [rdi + flight.arrivingTime.hour], r11b
	; verific overflow ore
	cmp byte [rdi + flight.arrivingTime.hour], 24
	jge recalculate_hour_arrive
	jmp increment
increment:
	inc r9
	add rdi, 42 ; urmatorul struct (flight)
	jmp compare_number_flights
recalculate_min:
	; daca e overflow
	sub byte [rdi + flight.departingTime.minutes], 60
	inc byte [rdi + flight.departingTime.hour]
	jmp verify_arrive_min
recalculate_hour:
	; daca e overflow
	sub byte [rdi + flight.departingTime.hour], 24
	inc byte [rdi + flight.departingTime.day]
	jmp verify_arrive_hour
recalculate_min_arrive:
	; daca e overflow
	sub byte [rdi + flight.arrivingTime.minutes], 60
	inc byte [rdi + flight.arrivingTime.hour]
	jmp verify_depart_hour
recalculate_hour_arrive:
	; daca e overflow
	sub byte [rdi + flight.arrivingTime.hour], 24
	inc byte [rdi + flight.arrivingTime.day]
	jmp increment
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
