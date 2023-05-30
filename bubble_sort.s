	AREA    text, CODE
	EXPORT  main

	ENTRY
main
    ; Array initialization
    LDR     r0, =array       ; Array address
    LDR     r1, =5           ; Array length
    BL      init_array      ; Initialize the array

    ; Sort the array
    LDR     r0, =array       ; Array address
    LDR     r1, =5           ; Array length
    BL      bubble_sort     ; Perform bubble sort

    ; Print the sorted array
    LDR     r0, =array       ; Array address
    LDR     r1, =5           ; Array length
    BL      print_array     ; Print the array

    B       exit            ; Program exit

; Array initialization
init_array
    stmfd 	sp!,{r4, lr}        ; Register preservation

    LDR     r2, [r1]        ; Array length
    ADD     r1, r1, #4      ; Increment array pointer

    MOV     r3, #0          ; Loop counter
loop_init
    CMP     r3, r2          ; Compare loop counter with array length
    BEQ     end_init        ; If equal, exit the loop

    LDR     r4, [r0]        ; Load value from array
    ADD     r0, r0, #4      ; Increment array pointer

    STR     r4, [r1]        ; Store the value in the array
    ADD     r1, r1, #4      ; Increment array pointer

    ADD     r3, r3, #1      ; Increment loop counter
    B       loop_init       ; Repeat the loop

end_init
    ldmfd   sp!,{r4, pc}        ; Register restoration and return

; Bubble Sort algorithm
bubble_sort
    stmfd   sp!,{r4, r5, lr}    ; Register preservation

    SUB     r1, r1, #1      ; Decrease array length by 1

outer_loop
    MOV     r4, #0          ; Flag indicating if any swaps occurred
    MOV     r5, r1          ; Loop counter for inner loop

inner_loop
    LDR     r2, [r0]        ; Load current element
    LDR     r3, [r0, #4]    ; Load next element

    CMP     r2, r3          ; Compare current element with next element
    bleq    no_swap         ; If less than or equal, no swap needed

    STR     r3, [r0]        ; Swap current element with next element
    STR     r2, [r0, #4]

    MOV     r4, #1          ; Set the swap flag to indicate a swap occurred

no_swap
    ADD     r0, r0, #4      ; Increment array pointer
    SUB     r5, r5, #1      ; Decrement inner loop counter

    CMP     r5, #0          ; Check if inner loop counter reached 0
    bgt     inner_loop      ; If greater than, repeat the inner loop

    CMP     r4, #0          ; Check if any swaps occurred
    beq     end_sort        ; If equal, exit the outer loop

    SUB     r1, r1, #1      ; Decrease array length by 1
    B       outer_loop      ; Repeat the outer loop

end_sort
    ldmfd   sp!,{r4, r5, pc}    ; Register restoration and return

; Print the array
print_array
    stmfd   sp!,{r4, lr}        ; Register preservation

    LDR     r2, [r1]        ; Array length
    ADD     r1, r1, #4      ; Increment array pointer

    MOV     r3, #0          ; Loop counter
loop_print
    CMP     r3, r2          ; Compare loop counter with array length
    BEQ     end_print       ; If equal, exit the loop

    LDR     r4, [r0]        ; Load value from array
    ADD     r0, r0, #4      ; Increment array pointer

    MOV     r0, r4          ; Move the value to r0 for printing
    BL      print_int       ; Print the integer

    ADD     r3, r3, #1      ; Increment loop counter
    B       loop_print      ; Repeat the loop

end_print
    ldmfd   sp!,{r4, pc}        ; Register restoration and return

; Print an integer
print_int
    stmfd   sp!,{r0, lr}        ; Register preservation

    MOV     r1, r0          ; Move the value to r1 for printing
    MOV     r0, #1          ; File descriptor for standard output
    LDR     r2, =buffer     ; Buffer address
    MOV     r3, #10         ; Base 10
    SWI     0x123456        ; Call SYS_WRITE

    ldmfd   sp!, {r0, pc}        ; Register restoration and return

; Program exit
exit
    B       exit            ; Infinite loop for program termination

; Data section
	AREA    data, DATA
array
    DCD     5, 2, 3, 4, 1   ; Array of integers
buffer
    DCD      12              ; Buffer for printing integers

    END