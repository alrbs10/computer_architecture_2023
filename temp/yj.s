; ARM assembler
    AREA text, CODE
            
            
scan
    stmfd   sp!, {lr}
    mov     r0, #7
    swi     0x123456
    ldmfd   sp!, {pc}
         
         


            
print_char
    stmfd   sp!, {lr}
    add     r0, r0, #'0'
    adr     r1, char
    strb    r0, [r1]
    mov     r0, #3
    swi     0x123456
    ldmfd   sp!, {pc} 

print
    stmfd   sp!, {r0,lr}
    mov     r0, r2
    bl      print_char
    bl      tab
    mov     r0, r3
    bl      print_char
    bl      tab
    mov     r0, r4
    bl      print_char
    bl      tab
    mov     r0, r5
    bl      print_char
    bl      tab
    mov     r0, r6
    bl      print_char
    b       finish

                   
tab           
    stmfd   sp!, {lr}
    mov     r0, #(-16)
    add     r0, r0, #'0'
    adr     r1, char
    strb    r0, [r1]
    mov     r0, #3
    swi     0x123456
    ldmfd   sp!, {pc} 





    AREA text, CODE
            
    ENTRY
   
start
    mov    r10, #10
    mov    r0, #0
    mov    r1, #0
    mov    r2, #0      ;숫자입력받아 저장r2~r6
    mov    r3, #0
    mov    r4, #0
    mov    r5, #0
    mov    r6, #0
    bl     num1
                 
num1      
    bl      scan
    sub     r0, r0, #'0'
    cmp     r0, #(-16)
    beq     num2
    mul     r2, r10, r2
    add     r2, r0, r2
    bl      num1


num2      
    bl      scan
    sub     r0, r0, #'0'
    cmp     r0, #(-16)
    beq     com32
    mul     r3, r10, r3
    add     r3, r0, r3
    bl      num2
            
com32       
    cmp     r2, r3
    bgt     swap32      ;r2가 더 크면 스왑
    bl      num3

swap32      
    mov     r0, r3
    mov     r3, r2
    mov     r2, r0
    bl      num3



num3      
    bl      scan
    sub     r0, r0, #'0'
    cmp     r0, #(-16)
    beq     com43
    mul     r4, r10, r4
    add     r4, r0, r4
    bl      num3

com43       
    cmp     r3, r4
    bgt     swap43
    bl      num4

swap43      
    mov     r0, r4
    mov     r4, r3
    mov     r3, r0
    bl      com42

com42     
    cmp     r2, r3
    bgt     swap42
    bl      num4

swap42    
    mov     r0, r3
    mov     r3, r2
    mov     r2, r0
    bl      num4



num4    
    bl      scan
    sub     r0, r0, #'0'
    cmp     r0, #(-16)
    beq     com54
    mul     r5, r10, r5
    add     r5, r0, r5
    bl      num4

com54       
    cmp     r4, r5
    bgt     swap54
    bl      num5

swap54      
    mov     r0, r5
    mov     r5, r4
    mov     r4, r0
    bl      com53

com53       
    cmp     r3, r4
    bgt     swap53
    bl      num5

swap53      
    mov     r0, r4
    mov     r4, r3
    mov     r3, r0
    bl      com52

com52       
    cmp     r2, r3
    bgt     swap52
    bl      num5

swap52      
    mov     r0, r3
    mov     r3, r2
    mov     r2, r0
    bl      num5



num5     
    bl      scan
    sub     r0, r0, #'0'
    cmp     r0, #(-16)
    beq    com65
    mul     r6, r10, r6
    add     r6, r0, r6
    bl      num5

com65       
    cmp     r5, r6
    bgt     swap65
    bl      print

swap65      
    mov     r0, r6
    mov     r6, r5
    mov     r5, r0
    bl      com64

com64       
    cmp     r4, r5
    bgt     swap64
    bl      print

swap64      
    mov     r0, r5
    mov     r5, r4
    mov     r4, r0
    bl      com63

com63       
    cmp     r3, r4
    bgt     swap63
    bl      print

swap63      
    mov     r0, r4
    mov     r4, r3
    mov     r3, r0
    bl      com62

com62       
    cmp     r2, r3
    bgt     swap62
    bl      print

swap62      
    mov     r0, r3
    mov     r3, r2
    mov     r2, r0
    bl      print


            
finish
    mov     r0, #0x18
    mov     r1, #0x20000
    add     r1, r1, #0x26
    SWI     0x123456


char       DCB     0

    END