    AREA text, CODE
    ENTRY
MAIN
;initialization part    
    mov     r1, #0x80000000 ; r1 = main address for input array
    mov     r12, #10        ; r12 = 10 for making decimal num(=r12)
    bl      SCAN_NUMS       ; get 5 inputs first
    bl      BUBBLE_SORT     ; sort by using bubble algorithm
    bl      PRINT_SORTED_NUMS ; print sorted numbers
    b       FINISH
SCAN_NUMS
    stmfd   sp!, {r0-r3, r7, lr} ; Register preservation
    mov     r2, #0          ; counter for 5 number inputs(=r2)
    mov     r3, #0          ; init for initial input(=r3)
    mov     r7, #0          ; flag for minus(=r7)
SCAN_NUM
    bl      scan            ; get keyboard input
    sub     r0, r0, #'0'    ; ASCII -> decimal
    cmp     r0, #(-16)      ; if space is detected, go to next input
    beq     AFTER_SPACE     
    cmp     r0, #(-3)       ; if '-' is detected, make flag
    moveq   r7, #1          
    beq     SCAN_NUM
    mul     r3, r12, r3     ; multiply 10 for before num
    add     r3, r0, r3      ; add recently scanned number
    b       SCAN_NUM        ; loop
AFTER_SPACE
    cmp     r7, #1          ; if minus was detected
    moveq   r7, #0          ; initial flag for minus
    subeq   r3, r7, r3      ; r3 = 0-r3
    add     r2, r2, #1      ; counter +1 for 5 num inputs
    str     r3, [r1], #4    ; store
    mov     r3, #0          ; refresh r3 for input
    cmp     r2, #5          ; if we get 5 input, finish function & go to sort
    bne     SCAN_NUM        ; else, go repeat
    ldmfd   sp!, {r0-r3, r7, pc}    ; after getting 5 inputs, go to return addr

BUBBLE_SORT
    stmfd   sp!,{r1,r2,r4-r8,r10, lr} ; Register preservation
    mov 	r2, #4          ; initial setting for(i=n-1;i>0;i--)
    MOV     r5, r2          ; i=n-1 for setting outer loop(i=r5)
    mov     r10, #(0)       ; j=0 setting for inner loop(j=r10)
OUTER_LOOP
    cmp     r5, #0          ; i<=0, stop & go to print part
    bne     INNER_LOOP
    ldmfd   sp!, {r1,r2,r4-r8,r10, pc}
INNER_LOOP
	mov		r8, r10, lsr #2 ; r8=r10/4, for checking j<i (since j steps by 4)
    cmp     r8, r5          ; if j=i finish inner loop
    moveq   r10, #0         ; refresh j=0
    subeq   r5, r5, #1      ; as one outer loop finished, i--
    beq     OUTER_LOOP      
    LDR     r6, [r1, r10]   ; Load current element, A[j]
    add 	r11, r10, #4    ; for next element
    LDR     r7, [r1, r11]   ; Load next element, A[j+4]
    cmp     r6, r7          ; for ascending sort, if current>next, swap occur
    bgt     SWAP 
    add     r10, r10,#4     ; j++ & loop
    b       INNER_LOOP
SWAP
    str     r7, [r1, r10]   ; store r7 to original r6 memory address
    add 	r11, r10, #4    
    str     r6, [r1, r11]   ; store r6 to original r7 memory address
    add 	r10, r10, #4    ; j++
    b 		INNER_LOOP
PRINT_SORTED_NUMS
    stmfd   sp!, {r1,r2,r7-r11,lr}
    mov     r2, #0          ; for quotient
    mov     r7, #0          ; record digit(for space & check printing number finish, =r7)
	mov		r8, #0          ; counter for how many number printed(max 5, =r8)
    mov     r9, #(-3)         ; save '-' for minus inputs
    mov     r10, #0         ; flag for minus inputs
GET_SORTED_NUM
    cmp     r8, #5          ; if 5 number printed, finish whole function
    bne     CONTINUE
    ldmfd   sp!, {r1,r2,r7-r11,pc}
CONTINUE
    ldr     r0, [r1, r8, lsl #2] ; load r0 which need to be printed, start by r1, r8(counter)*4
	add		r8, r8, #1      ; counter ++ after loading number
    cmp     r0, r2          ; check if number is minus(since r2=0 at loading number part)
    sublt   r0, r2, r0      ; r0 = -r0
    ;sublt   r0, r0, #1
    movlt   r10, #1         ; flag = 1
DIVIDE_FOR_DECIMAL
 	cmp     r0, r12         ; if r0<10, r0 now be remainder
 	blt     END_DIVIDE      
 	sub     r0, r0, r12     ; r0 = r0-10,
 	add     r2, r2, #1      ; quotient ++
 	bl      DIVIDE_FOR_DECIMAL 	
END_DIVIDE
	stmfd   sp!, {r0}       ; as division makes digit from end, need to put in stack
	add     r7, r7, #1      ; check for number of digits to pop from stack
	cmp     r2, #0          ; if quotient become 0, time to print
	beq     CHECK_BEFORE_PRINT
	mov     r0, r2          ; r2 -> r0 (r0 = quoitent, do for next digit)
	mov     r2, #0          ; initialize quoitent before re-division
	bl      DIVIDE_FOR_DECIMAL

CHECK_BEFORE_PRINT
    cmp     r10, #1         ; check if number was minus
    moveq   r10, #0         ; refresh flag
    bleq    ADD_DASH
    b     PRINT_NUM

ADD_DASH
    stmfd   sp!, {r9}       ; push - for minus indication
	add     r7, r7, #1      ; digit to pop ++

PRINT_NUM    
    ldmfd   sp!,{r0}
    add     r0, r0, #'0'    ; decimal to ascii
    bl      print_char
    sub     r7, r7, #1
    CMP     r7, #0
   	moveq	r0, #(32)       ; for seperate, add ' ' before numbers
    bleq	print_char
    beq     GET_SORTED_NUM
    bne     PRINT_NUM
print_char
    stmfd   sp!, {r0,r1, lr}   
    adr     r1, char
    strb    r0, [r1]
    mov     r0, #3
    swi     0x123456
    ldmfd   sp!, {r0,r1,pc}
FINISH  
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