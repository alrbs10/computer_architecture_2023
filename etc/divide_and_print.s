	AREA text, CODE
    ENTRY
    ; Dividend = 20, Divisor = 5
    sdmfd   sp!, {r1, lr}
init
    mov     r1, #0x80000020
    mov     r10, #0 ; pointer for decimal
    MOV     r2, #345        ; Dividend
    MOV     r12, #10       ; Divisor
division_init
    MOV r4, #0         ; Quotient (initialize to 0)
    MOV r5, r2         ; Remainder (initialize to dividend)

division_loop
    CMP r5, r12         ; Compare remainder with divisor
    blt division_done  ; If remainder < divisor, division is complete

    SUB r5, r5, r12     ; Subtract divisor from remainder
    ADD r4, r4, #1     ; Increment quotient

    B division_loop    ; Repeat the division loop

division_done
    ; Quotient will be stored in r4
    ; Remainder will be stored in r5
    str     r5, [r1, r10]
    cmp     r4, r10
    movgt   r2, r4
    addgt   r10, r10, #2
    bgt     division_init
    ; Rest of the code...

    END