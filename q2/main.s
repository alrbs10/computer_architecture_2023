    AREA text, CODE
    ENTRY
main
;initialization part    
    mov     r0, #0          ; register for getting input from scan
    mov     r1, #0x80000000 ; address for 5 number inputs(=r0)
    mov     r2, #0          ; counter for 5 number inputs(=r2)
    mov     r3, #0          ; init for initial input(=r3)
    mov     r11, #0         ; final counter for prime nums(=r11)
    mov     r12, #10        ; r12 = 10 for making decimal num(=r12)
    bl      scan_nums
    bl      check_prime
    b       finish

scan_nums
    stmfd   sp!, {lr}
scan_each_num
    bl      scan            ; get keyboard input
    sub     r0, r0, #'0'    ; ASCII -> decimal
    cmp     r0, #(-16)      ; if space is detected, go to next input
    beq     after_space     
    mul     r3, r12, r3     ; multiply 10 for before num
    add     r3, r0, r3      ; add recently scanned number
    b       scan_each_num        ; loop
after_space
    add     r2, r2, #1      ; counter +1 for 5 num inputs
    str     r3, [r1], #4    ; store
    mov     r3, #0          ; return r3=0
    cmp     r2, #5          ; if we get 5 input, finish function & go to sort
    bne     scan_each_num
    ldmfd   sp!, {pc}

check_primes
    stmfd   sp!, {lr}
    mov     r0, #0          ; counter for cheked prime(max 5)
    cmp     r0, #5          ; if checked all r0, return
    bne     check_each_prime
    ldmfd   sp!, {pc}

check_each_prime
    ldr     r3, [r1, r0, lsl #2] ; load data from memory (check num=r3)
    and     r4, r3, #1           ; check if number is even
    cmp     r4, #0               ; if num is even
    addeq   r0, r0, #1      ; i++, break
    ldmfd   sp!, {pc}
    bl      find_sqrt
find_sqrt
    mov     r4, #0


print_sorted_num
    mov     r7, #0
    mov     r2, #0
divide_for_decimal
 	cmp     r0, r12         ; if r0<10, r0 now be remainder
 	blt     end_divide      
 	sub     r0, r0, r12     ; r0 = r0-10,
 	add     r2, r2, #1      ; quotient ++
 	bl      divide_for_decimal 	
end_divide
	stmfd   sp!, {r0}       ; as division makes digit from end, need to put in stack
	add     r7, r7, #1      ; check for number of digits to pop from stack
	cmp     r2, #0          ; if quotient become 0, time to print
	beq     check_before_print
	mov     r0, r2          ; r2 -> r0 (r0 = quoitent, do for next digit)
	mov     r2, #0          ; initialize quoitent before re-division
	bl      divide_for_decimal

print_num    
    ldmfd   sp!,{r0}
    add     r0, r0, #'0'    ; decimal to ascii
    bl      print_char
    sub     r7, r7, #1
    CMP     r7, #0
   	moveq	r0, #(32)       ; for seperate, add ' ' before numbers
    bleq	print_char
    beq     get_sorted_num
    bne     print_num
print_char
    stmfd   sp!, {r0, lr}   
    adr     r1, char
    strb    r0, [r1]
    mov     r0, #3
    swi     0x123456
    ldmfd   sp!, {r0,pc}
finish  
    mov     r0, #0x18
    mov     r1, #0x20000        
    add     r1, r1, #0x26       
    SWI     0x123456           
scan   
    stmfd	sp!, {lr}       ; Push onto a Full Descending Stack
	mov		r0, #7          ; r0 = 7
	swi		0x123456
	ldmfd	sp!, {pc}       ; Pop from a Full Descending Stack

char       
    DCB      0
    END