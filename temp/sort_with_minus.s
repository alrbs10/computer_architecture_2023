    AREA text, CODE
    ENTRY
main
init    
    mov     r12, #10 ; r12 = 10
    mov     r0, #0
    mov     r1, #0x80000000 ;address for 5 number inputs
    mov     r2, #0 ;counter for 5 number inputs
    mov     r3, #0 ;init for initial input
    mov     r7, #0
scan_num
    bl      scan
    sub     r0, r0, #'0' ; ASCII -> decimal
    cmp     r0, #(-16) ; if space is detected, go to next input
    beq     after_space
    cmp     r0, #(-3) ; if - is detected, make flag
    moveq   r7, #1
    mul     r3, r12, r3 ; multiply 10 for before num
    add     r3, r0, r3 ; add recently scanned number
    b      scan_num 
after_space
    cmp     r7, #1 ; if minus was detected
    moveq   r7, #0 ;
    subeq   r3, r7, r3 ; r3 = 0 - r3, same with multiplying -1
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
    beq     finish
inner_loop
	mov		r8, r10, lsr #2 
    cmp     r8, r5 ; if(j>i)
    moveq   r10, #0
    subeq   r5, r5, #1
    beq     outer_loop     
    LDR     r6, [r1, r10]        ; Load current element
    add 	r11, r10, #4
    LDR     r7, [r1, r11]    ; Load next element
    cmp     r6, r7
    blt     swap
    add     r10, r10,#(4)
    b       inner_loop
finish  
    mov       r0, #0x18
    mov       r1, #0x20000        
    add       r1, r1, #0x26       
    SWI       0x123456           
scan   
    stmfd	sp!, {lr} ; Push onto a Full Descending Stack
	mov		r0, #7 ; r0 = 7
	swi		0x123456
	ldmfd	sp!, {pc} ; Pop from a Full Descending Stack
swap
    str     r7, [r1, r10]
    add 	r11, r10, #4
    str     r6, [r1, r11]
    add r10, r10, #4
    b inner_loop
    END