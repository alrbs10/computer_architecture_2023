    AREA text, CODE
    ENTRY
main
    mov     r1, #0      ; final answer, number of primes
    mov     r3, #0      ; counter for 5 inputs (for i=0;i<5;i++)
    mov     r10, #0     ; flag for non prime(i*i=temp)
    mov     r12, #10    ; for decimal
for_loop
    bl      scan_num
    bl      check_prime
for_non_prime_break
    add     r3, r3, #1  ; i++
    cmp     r3, #5
    beq     finish
    bne		for_loop	
    ;bleq    print_char
scan_num
    stmfd   sp!, {lr}
    mov     r2, #0      ; main check num at all trial, temp
scan_loop
    bl      scan            ; get keyboard input
    sub     r0, r0, #'0'    ; ASCII -> decimal
    cmp     r0, #(-16)      ; if space is detected, go to next input
    beq     return_scan     
    mul     r2, r12, r2     ; multiply 10 for before num
    add     r2, r0, r2      ; add recently scanned number
    b       scan_loop       ; loop
return_scan
    ldmfd   sp!, {pc}
check_prime
    stmfd   sp!, {lr}
    ; quick break for 0,1 -> not prime / 2->prime, r1++ / other even->not prime
    cmp     r2, #2          ; if r2<2 (r2=0,1), break
    blt     return_check
    addeq   r1, r1, #1      ; if r=2, only even prime, r1++ and break
    beq     return_check
    
    and     r4, r2, #1      ; except 2, all even is not prime, break
    cmp     r4, #0
    beq     return_check

    bl      find_sqrt
    cmp     r10, #1
    moveq   r10, #0         ; refresh when flag is used
    beq     return_check

    mov     r6, #3          ; divide with r6, starting from 3~r5
from_3_sqrt
    cmp     r6, r5
    addeq   r1, r1, #1
    beq     return_check
    mov     r7, r2          ; copy original r2 to r7
    bl      divide
    add     r6, r6, #1
    b       from_3_sqrt

find_sqrt                   ; after some special case, find square root of temp(r2)
    stmfd   sp!, {lr}
    mov     r5, #2          ; for(i=2;i*i<temp, i++)
for_loop_sqrt
    mul     r6, r5, r5
    cmp     r6, r2          
    addlt   r5, r5, #1      ; if i^2<temp, i++
    blt 	for_loop_sqrt
    moveq   r10, #1
    beq     return_sqrt     ; if i^2=temp, temp is not prime, break
    bgt     return_sqrt 
return_sqrt
    ldmfd   sp!, {pc}

return_check
    ldmfd   sp!, {pc}

divide
 	cmp     r7, r6         ; if r7(dividend)<r6(divider), r7 now be remainder
    ldrlt   lr, {pc}       ; go back to divide
    beq     return_check
 	sub     r7, r7, r6     ; r7 = r7-10,
 	b       divide         ; loop

print_char
    stmfd   sp!, {r0,r1,lr}   
    adr     r1, char
    strb    r0, [r1]
    mov     r0, #3
    swi     0x123456
    b       finish
    ldmfd   sp!, {r0,r1,pc}
scan   
    stmfd	sp!, {lr}    ; Push onto a Full Descending Stack
	mov		r0, #7          ; r0 = 7
	swi		0x123456
	ldmfd	sp!, {pc}    ; Pop from a Full Descending Stack

finish  
    mov     r0, #0x18
    mov     r1, #0x20000        
    add     r1, r1, #0x26       
    SWI     0x123456 
char       
    DCB      0
    END