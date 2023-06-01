    AREA text, CODE
    ENTRY
main
;initialization part    
    mov     r0, #0          ; register for getting input from scan
    mov     r1, #0x80000000 ; address for count 0~9
    mov     r2, #0          ; register to compare with 0~9, 10 numbers
    mov     r7, #0          ; record digit(for space & check printing number finish, =r7)
    mov     r12, #10        ; print decimal
initial_room
    cmp     r2, #10 
    beq     scan_each
    strb    r0, [r1, r2]    ; make 0 for 0~9 room
    add     r2, r2, #1
    b       initial_room
scan_each    
    bl      scan            ; get keyboard input
    sub     r0, r0, #'0'    ; ASCII -> decimal
    cmp     r0, #(-16)      ; if space is detected, finish getting input
    beq     concat_6_9     
    ldrb    r2, [r1, r0]
    add     r2, r2, #1
    strb    r2, [r1, r0]
    b       scan_each       ; loop
concat_6_9
    ldrb    r2, [r1, #9]    ; load data from room 9
    ldrb    r3, [r1, #6]    ; load data from room 6
    add     r3, r3, r2      ; sum room from 6, 9
    and     r4, r3, #1
    cmp     r4, #0
    blne    add_1_for_odd
    mov     r3, r3, lsr #1  ; make half of room 6, 9
    strb    r3, [r1, #6]    ; after making half, store to memory
    b       count_max
count_max
    mov     r3, #0          ; initial set for max value, =r3
    mov     r2, #0          ; refresh r2 for counter, max=9 (since check room for only 0~8)
find_max_each_room
    cmp     r2, #8          ; if find for all room, finish
    addeq   r0, r3, #0      ; send r0 = r3 to print function
    moveq   r2, #0          ; refresh quoisent for division
    beq     divide_for_decimal
    ldrb    r4, [r1, r2]    
    cmp     r4, r3          ; compare current max, current room
    movgt   r3, r4          ; if current room is bigger than max, update max
    add     r2, r2, #1      ; r2++, check for next room
    b       find_max_each_room

add_1_for_odd
    stmfd   sp!, {lr}
    add     r3, r3, #1
    ldmfd   sp!, {pc}

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
	beq     print_num
	mov     r0, r2          ; r2 -> r0 (r0 = quoitent, do for next digit)
	mov     r2, #0          ; initialize quoitent before re-division
	bl      divide_for_decimal

print_num    
    ldmfd   sp!,{r0}
    add     r0, r0, #'0'    ; decimal to ascii
    bl      print_char      
    sub     r7, r7, #1
    CMP     r7, #0
    bleq	print_char
    beq     finish
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