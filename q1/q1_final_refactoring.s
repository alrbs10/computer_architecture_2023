    AREA text, CODE
    ENTRY
main
;initialization part    
    mov     r1, #0x80000000
    mov     r12, #10        ; r12 = 10 for making decimal num(=r12)
    bl      scan_nums
    bl      bubble_sort
    bl      print_sorted_nums
    b       finish
scan_nums
    stmfd   sp!, {r0-r3, r7, lr}
    mov     r2, #0          ; counter for 5 number inputs(=r2)
    mov     r3, #0          ; init for initial input(=r3)
    mov     r7, #0          ; flag for minus(=r7)
scan_num
    bl      scan            ; get keyboard input
    sub     r0, r0, #'0'    ; ASCII -> decimal
    cmp     r0, #(-16)      ; if space is detected, go to next input
    beq     after_space     
    cmp     r0, #(-3)       ; if '-' is detected, make flag
    moveq   r7, #1          
    beq     scan_num
    mul     r3, r12, r3     ; multiply 10 for before num
    add     r3, r0, r3      ; add recently scanned number
    b       scan_num        ; loop
after_space
    cmp     r7, #1          ; if minus was detected
    subeq   r3, r7, r3      ; r3 = -r3
    subeq   r3, r3, #1
    moveq   r7, #0          ; initial flag for minus
    add     r2, r2, #1      ; counter +1 for 5 num inputs
    str     r3, [r1], #4    ; store
    mov     r3, #0          ; return r3=0
    cmp     r2, #5          ; if we get 5 input, finish function & go to sort
    bne     scan_num
    ldmfd   sp!, {r0-r3, r7, pc}

bubble_sort
    stmfd   sp!,{r1,r2,r4-r8,r10, lr} ; Register preservation
    mov 	r2, #4          ; initial setting for(i=n-1;i>0;i--)
    MOV     r5, r2          ; i=n-1 for setting outer loop(=r5)
    mov     r10, #(0)       ; j=0 setting for inner loop
outer_loop
    cmp     r5, #0          ; i<=0, stop & go to print part
    bne     inner_loop
    ldmfd   sp!, {r1,r2,r4-r8,r10, pc}
inner_loop
	mov		r8, r10, lsr #2 ; r8=r10/4, for checking j<i (since j steps by 4)
    cmp     r8, r5          ; if j=i finish inner loop
    moveq   r10, #0         ; refresh j=0
    subeq   r5, r5, #1      ; as one outer loop finished, i--
    beq     outer_loop      
    LDR     r6, [r1, r10]   ; Load current element, A[j]
    add 	r11, r10, #4    ; for next element
    LDR     r7, [r1, r11]   ; Load next element, A[j+4]
    cmp     r6, r7          ; for ascending sort, if current>next, swap occur
    bgt     swap 
    add     r10, r10,#4     ; j++ & loop
    b       inner_loop

print_sorted_nums
    stmfd   sp!, {r1,r2,r7-r11,lr}
    mov     r2, #0          ; for quotient
    mov     r7, #0          ; record digit(for space & check printing number finish, =r7)
	mov		r8, #0          ; counter for how many number printed(max 5, =r8)
    mov     r9, #(-3)         ; save '-' for minus inputs
    mov     r10, #0         ; flag for minus inputs
get_sorted_num
    cmp     r8, #5          ; if 5 number printed, finish whole function
    beq     return_print_sort         
	;mov	    r1, #0x80000000 ; after printing char, need r1 refresh
    ldr     r0, [r1, r8, lsl #2] ; load r0 which need to be printed, start by r1, r8(counter)*4
	add		r8, r8, #1      ; counter ++ after loading number
    cmp     r0, r2          ; check if number is minus(since r2=0 at loading number part)
    sublt   r0, r2, r0      ; r0 = -r0
    ;sublt   r0, r0, #1
    movlt   r10, #1         ; flag = 1
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

check_before_print
    cmp     r10, #1         ; check if number was minus
    moveq   r10, #0         ; refresh flag
    bleq    add_dash_for_minus
    b     print_num

add_dash_for_minus
    stmfd   sp!, {r9}       ; push - for minus indication
	add     r7, r7, #1      ; digit to pop ++

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
    stmfd   sp!, {r0,r1, lr}   
    adr     r1, char
    strb    r0, [r1]
    mov     r0, #3
    swi     0x123456
    ldmfd   sp!, {r0,r1,pc}

swap
    str     r7, [r1, r10]
    add 	r11, r10, #4
    str     r6, [r1, r11]
    add 	r10, r10, #4
    b 		inner_loop
return_print_sort
    ldmfd   sp!, {r1,r2,r7-r11,pc}
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