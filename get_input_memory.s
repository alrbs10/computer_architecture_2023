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
    SUB     r2, r2, #1      ; Decrease array length by 1

outer_loop
    MOV     r4, #0          ; Flag indicating if any swaps occurred
    MOV     r5, r2          ; Loop counter for inner loop

inner_loop
    LDR     r6, [r1]        ; Load current element
    LDR     r7, [r1, #4]    ; Load next element

    CMP     r6, r7          ; Compare current element with next element
    bleq    no_swap         ; If less than or equal, no swap needed

    STR     r7, [r1]        ; Swap current element with next element
    STR     r6, [r1, #4]

    MOV     r4, #1          ; Set the swap flag to indicate a swap occurred

no_swap
    ADD     r1, r1, #4      ; Increment array pointer
    SUB     r5, r5, #1      ; Decrement inner loop counter

    CMP     r5, #0          ; Check if inner loop counter reached 0
    bgt     inner_loop      ; If greater than, repeat the inner loop

    CMP     r4, #0          ; Check if any swaps occurred
    beq     end_sort        ; If equal, exit the outer loop

    SUB     r1, r1, #1      ; Decrease array length by 1
    B       outer_loop      ; Repeat the outer loop

end_sort
    ldmfd   sp!,{r4-r7, pc}    ; Register restoration and return

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

    END