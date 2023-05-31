; ARM assenbler

         AREA text, CODE
         ; This section is called "text", and contains code
         ENTRY
         
         IMPORT   scan
         IMPORT   print
         IMPORT   print_char
         
              
         
start

;make stack & get 1st number

		 sub sp, sp, #40  ; allocate memory	 
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


;get 2nd number
 
INSERT_NUM2_FIRST

		mov r5, r4 ; r5 is first number
		str	  r5, [sp, #0]  ;store 1st number in memory
		bl scan
		sub       r4, r0, #'0'
		
INSERT_NUM2
		bl scan
		CMP r0, r3  ;if enter is inserted
		BEQ INSERT_NUM3_FIRST
		BNE MAKE_DIGIT2
		
MAKE_DIGIT2
		mov   	  r2, #10
       	mul 	  r4, r2, r4
       	sub 	  r0, r0, #'0' 
       	add		  r4, r4, r0
       	bl INSERT_NUM2

		
;get 3rd number

INSERT_NUM3_FIRST

		mov r5, r4 ; r5 is 2nd number
		str	  r5, [sp, #4]  ;store 2nd number in memory
		bl scan
		sub       r4, r0, #'0'
		
INSERT_NUM3
		bl scan
		CMP r0, r3  ;if enter is inserted
		BEQ INSERT_NUM4_FIRST
		BNE MAKE_DIGIT3
		
MAKE_DIGIT3
		mov   	  r2, #10
       	mul 	  r4, r2, r4
       	sub 	  r0, r0, #'0' 
       	add		  r4, r4, r0
       	bl INSERT_NUM3
       	
;get 4th number

INSERT_NUM4_FIRST

		mov r5, r4 ; r5 is 3rd number
		str	  r5, [sp, #8]  ;store 3rd number in memory
		bl scan
		sub       r4, r0, #'0'
		
INSERT_NUM4
		bl scan
		CMP r0, r3  ;if enter is inserted
		BEQ INSERT_NUM5_FIRST
		BNE MAKE_DIGIT4
		
MAKE_DIGIT4
		mov   	  r2, #10
       	mul 	  r4, r2, r4
       	sub 	  r0, r0, #'0' 
       	add		  r4, r4, r0
       	bl INSERT_NUM4
       	
;get 5th number

INSERT_NUM5_FIRST

		mov r5, r4 ; r5 is 4th number
		str	  r5, [sp, #12]  ;store 4th number in memory
		bl scan
		sub       r4, r0, #'0'
		
INSERT_NUM5
		bl scan
		CMP r0, r3  ;if enter is inserted
		BEQ INSERT_NUM6_FIRST
		BNE MAKE_DIGIT5
		
MAKE_DIGIT5
		mov   	  r2, #10
       	mul 	  r4, r2, r4
       	sub 	  r0, r0, #'0' 
       	add		  r4, r4, r0
       	bl INSERT_NUM5
		       	
		       	
;get 6th number

INSERT_NUM6_FIRST

		mov r5, r4 ; r5 is 5th number
		str	  r5, [sp, #16]  ;store 5th number in memory
		bl scan
		sub       r4, r0, #'0'
		
INSERT_NUM6
		bl scan
		CMP r0, r3  ;if enter is inserted
		BEQ INSERT_NUM7_FIRST
		BNE MAKE_DIGIT6
		
MAKE_DIGIT6
		mov   	  r2, #10
       	mul 	  r4, r2, r4
       	sub 	  r0, r0, #'0' 
       	add		  r4, r4, r0
       	bl INSERT_NUM6


;get 7th number
      	
INSERT_NUM7_FIRST

		mov r5, r4 ; r5 is 6th number
		str	  r5, [sp, #20]  ;store 6th number in memory
		bl scan
		sub       r4, r0, #'0'
		
INSERT_NUM7
		bl scan
		CMP r0, r3  ;if enter is inserted
		BEQ INSERT_NUM8_FIRST
		BNE MAKE_DIGIT7
		
MAKE_DIGIT7
		mov   	  r2, #10
       	mul 	  r4, r2, r4
       	sub 	  r0, r0, #'0' 
       	add		  r4, r4, r0
       	bl INSERT_NUM7
       	
;get 8th number

INSERT_NUM8_FIRST

		mov r5, r4 ; r5 is 7th number
		str	  r5, [sp, #24]  ;store 7th number in memory
		bl scan
		sub       r4, r0, #'0'
		
INSERT_NUM8
		bl scan
		CMP r0, r3  ;if enter is inserted
		BEQ INSERT_NUM9_FIRST
		BNE MAKE_DIGIT8
		
MAKE_DIGIT8
		mov   	  r2, #10
       	mul 	  r4, r2, r4
       	sub 	  r0, r0, #'0' 
       	add		  r4, r4, r0
       	bl INSERT_NUM8
       	
;get 9th number

INSERT_NUM9_FIRST

		mov r5, r4 ; r5 is 8th number
		str	  r5, [sp, #28]  ;store 8th number in memory
		bl scan
		sub       r4, r0, #'0'
		
INSERT_NUM9
		bl scan
		CMP r0, r3  ;if enter is inserted
		BEQ INSERT_NUM10_FIRST
		BNE MAKE_DIGIT9
		
MAKE_DIGIT9
		mov   	  r2, #10
       	mul 	  r4, r2, r4
       	sub 	  r0, r0, #'0' 
       	add		  r4, r4, r0
       	bl INSERT_NUM9
       	
       	
;get 10th number

INSERT_NUM10_FIRST

		mov r5, r4 ; r5 is 9th number
		str	  r5, [sp, #32]  ;store 9th number in memory
		bl scan
		sub       r4, r0, #'0'
		
INSERT_NUM10
		bl scan
		CMP r0, r3  ;if enter is inserted
		BEQ GET_TARGET 
		BNE MAKE_DIGIT10
		
MAKE_DIGIT10
		mov   	  r2, #10
       	mul 	  r4, r2, r4
       	sub 	  r0, r0, #'0' 
       	add		  r4, r4, r0
       	bl INSERT_NUM10
						       	
		       	
GET_TARGET      	        	      	        	 
;get target number to find
		 mov r5, r4 ; r5 is 10th number
         str	  r5, [sp, #36]  ;store 10th number in memory

INSERT_TARGET
		bl scan
		sub       r4, r0, #'0'
		
INSERT_TARGET_NUM
		bl scan
		CMP r0, r3  ;if enter is inserted
		BEQ SET_VARIABLE
		BNE MAKE_DIGIT_TARGET
		
MAKE_DIGIT_TARGET
		mov   	  r2, #10
       	mul 	  r4, r2, r4
       	sub 	  r0, r0, #'0' 
       	add		  r4, r4, r0
       	bl INSERT_TARGET_NUM
       	 
SET_VARIABLE
;set the variable
		 mov r5, r4  ; r5 is target number
		 mov r2, #0  ; r2 is low(index)
		 mov r3, #9 ; r3 is high(index)
		 mov r4, #0  ; r4 is mid (index)
		 
       	 
;while


START_LOOP
 	CMP r2, r3      ; low>high
 	BGT END_START_LOOP
 	add r6, r2, r3 ; r6 = high+low (index)
 	mov r6, r6, LSR #1 ; you need to make /2 here
 	mov r4, r6 ;   mid= r4 = high+low /2 (index)
 	mov r8, #4
 	mul r7, r8, r4; index*4
 	add r7, r7, sp;
 	ldr r8, [r7, #0]  ;get the number that mid(r4) points
 	CMP r5, r8   ; if (target == data[mid])
 	BEQ SUCESS_FINDING
 	CMP r5, r8   ; if (target < data[mid])
 	BLT CHANGE_HIGH
 	CMP r5, r8   ; if (target > data[mid])
 	BGT CHANGE_LOW

SUCESS_FINDING
	;we need to print r4(mid) here
	mov r0, r8
	mov r2, #0  ; r2 is share
    mov r7, #0  ;r7 is the number of saving memory
	mov r3, #10 ; needed to divide
	
DIVIDE_PRINT
 	CMP r0, r3  ; if i-10<10
 	BLT END_DIVIDE_PRINT
 	sub r0, r0, r3  ; r0 = i-10
 	add r2, r2, #1;  share++
 	bl DIVIDE_PRINT
 	
END_DIVIDE_PRINT
	
	stmfd sp!,{r0}
	add r7, r7, #1
	CMP r2, #0 ;if) share ==0
	BEQ PRINT_NUM
	mov r0, r2 ;r2 -> r0 (r0 = share)
	mov r2, #0  ; initialize share
	bl DIVIDE_PRINT

;DIVIDE_PRINT_END



PRINT_NUM    
    ldmfd sp!,{r0}
    add r0, r0, #'0' ;decimal to ascii
    bl print_char
    sub r7, r7, #1
    CMP r7, #0
    BEQ END_START_LOOP
    BNE PRINT_NUM
	
	
        
    
CHANGE_HIGH
	sub r3, r4, #1 ; high = mid -1
	bl START_LOOP
	
CHANGE_LOW    
    add r2, r4, #1 ; low = mid +1
    bl START_LOOP
    
END_START_LOOP
   	
	
         
finish
         ; Standard exit code: SWI 0x123456, calling routine 0x18
         ; with argument 0x20026
         mov      r0, #0x18
         mov      r1, #0x20000
         add      r1, r1, #0x26
         SWI      0x123456
         
         
END