    AREA text, CODE
    ENTRY
start    
    mov     r12, #10 ; r12 = 10
    mov     r0, #0
    mov     r1, #0x80000004
    mov     r2, #0 ;cont 5 num
    mov     r3, #0
    ;mov		r4, #(-16)

scan_num
    bl      scan
    sub     r0, r0, #'0' ; ASCII -> decimal
    cmp     r0, #(-16) 
    beq     after_space
    mul     r3, r12, r3
    add     r3, r0, r3
    bl      scan_num

after_space
    add     r2, r2, #1
    str     r3, [r1], #4
    mov     r3, #0
    cmp     r2, #5
    beq     load_num
    bl      scan_num

load_num
    ldr     r5, [r1], #(-4)
    ldr     r5, [r1], #(-4)
    ldr     r5, [r1], #(-4)
    ldr     r5, [r1], #(-4)
    ldr     r5, [r1], #(-4)
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