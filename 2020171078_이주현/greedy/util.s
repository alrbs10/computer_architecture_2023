         AREA text, CODE
         
         EXPORT print
         EXPORT scan
         EXPORT print_char
     
print
         ; Entry: takes char in r0
         ; Conforms to APCS
         ; Call SYS_WRITEC, with r1 containing a POINTER TO a character
         
         ; SYS_WRITEC = 3, SYS_WRITE0 = 4, SYS_READC = 7
         
         stmfd    sp!, {r4-r12, lr}
         mov    r1, r0
         mov    r0, #4
         swi      0x123456
         ldmfd    sp!, {r4-r12, pc}
         
scan
         stmfd   sp!, {lr}
         mov      r0, #7
         swi      0x123456
         ldmfd   sp!, {pc}
         
print_char
         stmfd   sp!, {r0, lr}   ; push the registers that
                           ; you want to save
         
         adr      r1, char
         strb   r0, [r1]
         mov      r0, #3
         swi      0x123456
         
         ldmfd   sp!, {r0,pc}
         
char      DCB      0


     
       	 
