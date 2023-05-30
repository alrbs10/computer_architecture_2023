        AREA text, CODE

print
		stmfd	sp!, {r4-r12, lr} ; Push onto a Full Descending Stac
		mov		r1, r0 ; r1 = r0
		mov		r0, #4 ; r0 = 4
		swi		0x123456
		ldmfd	sp!, {r4-r12, pc} ; Pop from a Full Descending Stack
scan   
        stmfd	sp!, {lr} ; Push onto a Full Descending Stack
		mov		r0, #7 ; r0 = 7
		swi		0x123456
		ldmfd	sp!, {pc} ; Pop from a Full Descending Stack

print_char
		stmfd	sp!, {r0, lr}
		adr		r1, char
		strb	r0, [r1]
		mov		r0, #3
		swi		0x123456
		ldmfd	sp!, {r0, pc}
						
char	DCB		0      

        AREA text, CODE
        ENTRY
start
        
        mov     r12, #10 ; r12 = 10
        mov     r0, #0
        mov     r1, #0
        mov     r2, #0
        mov     r3, #0
        mov     r4, #0
        mov     r5, #0
        mov     r6, #0
        
        bl      scan1
make_minus
        mul     r0, r0, #(-1)
scan1
        bl      scan ; r0 <- N1
        sub     r0, r0, #'0' ; ASCII -> decimal
        cmp     r0, #(-16)       
        beq     scan2 ; if r0 = -16, go to scan2
        cmp     r0, #(-3)
        beq     make_minus
        mul     r2, r12, r2 ; r2 <- r2*10
        add     r2, r0, r2 ; r2 <- r0 + r2
        bl      scan1

scan2
        bl      scan ; r0 <- N2
        sub     r0, r0, #'0'  ; ASCII -> decimal
        cmp     r0, #(-16)
        beq     scan3 ; if r0 = -16, go to scan3
        mul     r3, r12, r3 ; r1 <- r3*10
        add     r3, r0, r3  ; r3 <- r3 + r0
        bl      scan2

scan3
        bl      scan ; r0 <- B(입력값2)
        sub     r0, r0, #'0'  ; ASCII -> decimal
        cmp     r0, #(-16)
        beq     scan4 ; if r0 = -16, go to scan4
        mul     r4, r12, r4 ; r1 <- r2*10
        add     r4, r0, r4  ; r4 <- r4 + r0
        bl      scan3

scan4
        bl      scan ; r0 <- B(입력값2)
        sub     r0, r0, #'0'  ; ASCII -> decimal
        cmp     r0, #(-16)
        beq     scan5 ; if r0 = -16, go to scan5
        mul     r5, r12, r5 ; r5 <- r5*10
        add     r5, r0, r5  ; r5 <- r5 + r0
        bl      scan4

scan5
        bl      scan ; r0 <- B(입력값2)
        sub     r0, r0, #'0'  ; ASCII -> decimal
        cmp     r0, #(-16)
        beq     finish ; if r0 = -16, go to scan5
        mul     r6, r12, r6; r4 <- r4*10
        add     r6, r0, r6 ; r4 <- r4 + r0
        bl      scan5

finish  
            mov       r0, #0x18
            mov       r1, #0x20000        
            add       r1, r1, #0x26       
            SWI       0x123456           

            END