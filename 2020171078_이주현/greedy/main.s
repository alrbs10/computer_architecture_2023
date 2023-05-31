; ARM assenbler

         AREA text, CODE
         ; This section is called "text", and contains code
         ENTRY
         
         IMPORT   scan
         IMPORT   print
         IMPORT   print_char
   
                
                 
         
start

;get number A
		mov r3, #10  ;r3 is enter

INSERT_NUM_FIRST
		bl scan
		sub       r4, r0, #'0'
INSERT_NUM
		bl scan
		CMP r0, r3  ;if enter is inserted
		BEQ INSERT_NUM2_FIRST
		BNE MAKE_DIGIT 
		
MAKE_DIGIT
		mov   	  r2, #10
       	mul 	  r4, r2, r4
       	sub 	  r0, r0, #'0' 
       	add		  r4, r4, r0
       	bl INSERT_NUM

;get number B
INSERT_NUM2_FIRST

		mov r6, r4 ; r6 is number A
		bl scan
		sub       r7, r0, #'0'

INSERT_NUM2
		bl scan
		CMP r0, r3  ;if enter is inserted
		BEQ SET_VARIABLE
		BNE MAKE_DIGIT2
		
MAKE_DIGIT2
		mov   	  r2, #10
       	mul 	  r7, r2, r7
       	sub 	  r0, r0, #'0' 
       	add		  r7, r7, r0
       	bl INSERT_NUM2
		


SET_VARIABLE
	 
	     mov r10, r7    ;r10 is number B
		 mov r1, #0  ; r1 is count 
		 mov r2, #0 ;  r2 is share(¸ò)
		 mov r3, #10 ; needed to divide

START_LOOP		 
    CMP r6, r10  ; if(A==B)
    BEQ END_LOOP
    BGT END_START_LOOP  ;if(A>B)
    BNE DECIDE_EVEN_ODD
    
    
    
DECIDE_EVEN_ODD
	
	add r11, r10, #1;  r11 = B+1
	sub sp, sp, #4
	str r10, [sp, #0]  ; save r10 in stack
	mov r10, r10, LSR #1 ; r10 = B/2
	mov r11, r11, LSR #1 ; r11 = (B+1)/2
	CMP r10, r11
    BEQ EVEN
    BNE ODD

EVEN
    add r1, r1, #1 ;count++
    bl START_LOOP

ODD
	ldr r10, [sp, #0] ; return r10(MEM) to r10(REG) 
	bl DIVIDE  
	

;DIVIDE_START


DIVIDE
 	sub r10, r10, r3  ; r10 = i-10
 	add r2, r2, #1;  share++
 	CMP r10, r3  ; if i-10<10
 	BLT END_DIVIDE
 	bl DIVIDE
 	
END_DIVIDE
	CMP r10, #1  ;if remainder==1
	BEQ UP_COUNT 
	BNE NOTHING
	
UP_COUNT  ;remainder==1
	mov r10, r2 ;r2 -> r10 (r10 = share)
	add r1, r1, #1 ; count++
	bl START_LOOP
	
NOTHING   ;else
		;you need to print (-1) here
		mov r0, #45   
		bl print_char   ; print (-)
		mov r0, #1; 
		add r0, r0, #'0' ;decimal to ascii
        bl print_char   ; print (1)
		bl DONE

;DIVIDE_END


END_LOOP
    ;you need to print count here
    add r1,r1, #1 ; count+1
    mov r0, r1
	add r0, r0, #'0'
	bl print_char
	bl DONE    		
    
END_START_LOOP

	mov r0, #45   
		bl print_char   ; print (-)
		mov r0, #1; 
		add r0, r0, #'0' ;decimal to ascii
        bl print_char   ; print (1)

   	
DONE
         
finish
         ; Standard exit code: SWI 0x123456, calling routine 0x18
         ; with argument 0x20026
         mov      r0, #0x18
         mov      r1, #0x20000
         add      r1, r1, #0x26
         SWI      0x123456
         
         
END