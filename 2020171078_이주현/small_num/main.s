; ARM assenbler

         AREA text, CODE
         ; This section is called "text", and contains code
         ENTRY
         
         IMPORT   scan
         IMPORT   print
         IMPORT   print_char
         
start
;another way to get prime number
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

INSERT_NUM2_FIRST

		mov r5, r4 ; r5 is first prime number
		bl scan
		sub       r6, r0, #'0'

INSERT_NUM2
		bl scan
		CMP r0, r3  ;if enter is inserted
		BEQ SET_VARIABLE
		BNE MAKE_DIGIT2
		
MAKE_DIGIT2
		mov   	  r2, #10
       	mul 	  r6, r2, r6
       	sub 	  r0, r0, #'0' 
       	add		  r6, r6, r0
       	bl INSERT_NUM2
		
				


SET_VARIABLE
;counting prime number between r5,r8

		
;for (int i = M; i <= N; i++) {  count = 0;

	mov r8, r6    ; r8 is second prime number
	mov r9, r5     ;r5->r9, r9 is 'i', r5 is M
	add r8, r8, #1 ;r8 -> r8+1, r8 was initially N
	mov r10, #0    ;r10->0, r10 is count
	mov r11, #1  ; r11 is 'j'
 	mov r1, #0;    r1 is counter(¸ò)
 	mov r0, #0		; r0 is count_all
 	
START_LOOP
 	CMP r9, r8      ; i<=N
 	BEQ END_START_LOOP
 	bl DIVIDE
 	
HERE 
    CMP r10, #2  ;if(count==2)
 	BEQ UP_COUNT_ALL
 	add r9, r9, #1  ; i++
 	mov r5, r9;
 	mov r11, #1; initialize j
 	mov r10, #0 ; initialize count
 	bl START_LOOP
 	
UP_COUNT_ALL
	add r0, r0, #1   ; count_all ++
	add r9, r9, #1  ; i++
	mov r5, r9;
	mov r11, #1; initialize j
	mov r10, #0 ; initialize count
 	bl START_LOOP



;for (int j = 1; j <= i; j++) {if (i%j == 0) {count++;}}
DIVIDE
	CMP r11, r5      ; if j>i
 	BGT HERE
 	sub r9, r9, r11  ; r9 = i-j
 	add r1, r1, #1;  counter++
 	CMP r9, r11  ; if i-j<j
 	BLT END_DIVIDE
 	bl DIVIDE
 	
END_DIVIDE
	CMP r9, #0
	BEQ UP_COUNT 
	bl NOTHING
	
UP_COUNT  ;remainder=0
	add r10, r10, #1  ;count++
	add r11, r11, #1 ; j++
	mov r9, r5;
	mov r1, #0;
	bl DIVIDE
	
NOTHING   ;remainder != 0
		add r11, r11, #1 ; j++
		mov r9, r5;  initialize i
		mov r1, #0; initialize counter
		bl DIVIDE
		
 	
END_START_LOOP
    ;we need to print r0, which is count_all here.
    
    ;you need to implement how to print many digits here before add instruction
    
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
    BEQ finish
    BNE PRINT_NUM
	
	
         
finish
         ; Standard exit code: SWI 0x123456, calling routine 0x18
         ; with argument 0x20026
         mov      r0, #0x18
         mov      r1, #0x20000
         add      r1, r1, #0x26
         SWI      0x123456
         
         
END