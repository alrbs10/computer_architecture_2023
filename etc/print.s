print_char
    stmfd   sp!, {r0, lr}   ; push the registers that
    
    adr     r1, char
    strb    r0, [r1]
    mov     r0, #3
    swi     0x123456
    
    ldmfd   sp!, {r0,pc}
char      DCB      0
