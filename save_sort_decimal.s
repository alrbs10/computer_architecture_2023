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
    beq     make_decimal
inner_loop
	mov		r8, r10, lsr #2 
    cmp     r8, r5 ; if(j>i)
    moveq   r10, #0
    subeq   r5, r5, #1
    beq     outer_loop     
    LDR     r6, [r1, r10]        ; Load current element
    add 	r11, r10, #4
    LDR     r7, [r1, r11]    ; Load next element
    cmp     r7, r6 ;cmp r6, r7 : ascending(123), r7, r6: descending(321)
    bgt     swap 
    add     r10, r10,#4
    b       inner_loop


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
	;ENTRY
print_start
	mov		r1, r0
	mov 	r0, #3
print_num
	ldrb	r2, [r1]
	cmp 	r2, #0
	beq 	finish
	add		r2, r2, #'0'
	strb	r2, [r1], #1
	swi 	0x123456
	b		print_num
swap
    str     r7, [r1, r10]
    add 	r11, r10, #4
    str     r6, [r1, r11]
    add 	r10, r10, #4
    b 		inner_loop
make_decimal
	mov		r0, #0x80000030
	mov		r3, #0
	mov		r9, #(-16)
	sub		r0, r0, #1
get_number
	cmp 	r3, #5
	beq		print_start
	ldr 	r2, [r1], #4
	mov		r12, #10
	strb	r9, [r0], #1
division_init
	mov		r4, #0
	mov		r5, r2
division_loop
	cmp 	r5, r12
	blt 	division_done
	sub 	r5, r5, r12
	add 	r4, r4, #1
	b 		division_loop
division_done
	strb 	r5, [r0], #1
	cmp 	r4, r10
	movgt 	r2, r4
	addgt	r10, r10, #2
	bgt 	division_init
	cmp		r4, #0
	addeq	r3, r3, #1
	beq		get_number
	strb	r4, [r0], #1
	add		r3, r3, #1
	b		get_number
    END