    AREA text, CODE
    ENTRY
main
init    
    mov     r12, #10 ; r12 = 10
    mov     r0, #0
    mov     r1, #0x80000000 ;address for 5 number inputs
    mov     r2, #0 ;counter for 5 number inputs
    mov     r3, #0 ;init for initial input

scan_num
    bl      scan
    sub     r0, r0, #'0' ; ASCII -> decimal
    cmp     r0, #(-16) ; if space is detected, go to next input
    beq     after_space
    mul     r3, r12, r3 ; multiply 10 for before num
    add     r3, r0, r3 ; add recently scanned number
    b      scan_num 
after_space
    add     r2, r2, #1
    str     r3, [r1], #4
    mov     r3, #0
    cmp     r2, #5
    beq     bubble_sort
    b       scan_num

bubble_sort
    sub     r1, r1, #(20)
    stmfd   sp!,{r4-r7, lr}    ; Register preservation
    mov     r10, #(0)       ; j=0
    sub 	r2, r2, #1
    MOV     r5, r2          ; Loop counter for inner loop initial
outer_loop
    MOV     r4, #0          ; Flag indicating if any swaps occurred
    cmp     r5, #0
    beq     print_sorted_num
inner_loop
	mov		r8, r10, lsr #2 
    cmp     r8, r5 ; if(j>i)
    moveq   r10, #0
    subeq   r5, r5, #1
    beq     outer_loop     
    LDR     r6, [r1, r10]        ; Load current element
    add 	r11, r10, #4
    LDR     r7, [r1, r11]    ; Load next element
    cmp     r6, r7 ;cmp r6, r7 : ascending(123), r7, r6: descending(321)
    bgt     swap 
    add     r10, r10,#4
    b       inner_loop

print_sorted_num
    mov     r1, #0x80000000
    mov     r3, #10
    mov     r2, #0
    mov     r7, #0 ;for num of decimal bits
	mov		r8, #0 ;counter for how many number printed
    mov     r9, #0 ;flag for minus
get_sorted_num
    cmp     r8, #5
    beq     finish
	mov	    r1, #0x80000000
    ldr     r0, [r1, r8, lsl #2]
	add		r8, r8, #1
    cmp     r0, #0
    sublt   r0, r7, r0
    ldmfd   sp!, #45
    movlt   r7, #1
divide_for_decimal
 	cmp     r0, r3  ; if i-10<10
 	blt     end_divide
 	sub     r0, r0, r3  ; r0 = i-10
 	add     r2, r2, #1  ;  share++
 	bl      divide_for_decimal
 	
end_divide
	stmfd   sp!,{r0}
	add     r7, r7, #1
	cmp     r2, #0 ;if) share ==0
	beq     PRINT_NUM
	mov     r0, r2 ;r2 -> r0 (r0 = share)
	mov     r2, #0  ; initialize share
	bl      divide_for_decimal

PRINT_NUM    
    ldmfd   sp!,{r0}
    add     r0, r0, #'0' ;decimal to ascii
    bl      print_char
    sub     r7, r7, #1
    CMP     r7, #0
   	moveq	r0, #(32)
    bleq	print_char
    beq     get_sorted_num
    bne     PRINT_NUM

print_char
    stmfd   sp!, {r0, lr}   ; push the registers that
    adr     r1, char
    strb    r0, [r1]
    mov     r0, #3
    swi     0x123456
    ldmfd   sp!, {r0,pc}

swap
    str     r7, [r1, r10]
    add 	r11, r10, #4
    str     r6, [r1, r11]
    add 	r10, r10, #4
    b 		inner_loop
finish  
    mov     r0, #0x18
    mov     r1, #0x20000        
    add     r1, r1, #0x26       
    SWI     0x123456           
scan   
    stmfd	sp!, {lr} ; Push onto a Full Descending Stack
	mov		r0, #7 ; r0 = 7
	swi		0x123456
	ldmfd	sp!, {pc} ; Pop from a Full Descending Stack

char       
    DCB      0
    END