TITLE Program6_Moldenhauer         (Program6_Moldenhauer.asm)

; Author: Peter Moldenhauer
; Date: 11/15/16
; OSU Email : moldenhp@oregonstate.edu
; Course - Section: CS271 - 400
; Assignment: Program 6
; Assignment Due Date: 12/04/16
; Description: This program demonstrates the implemenation and calling of low-level I/O procedures
; as well as demonstrates the use of macros. Specifically, this program gets 10 valid integers from
; the user and stores the numeric values in an array. The program then displays teh integers, their 
; sum, and their average.

INCLUDE Irvine32.inc

;************************************************************
; Macro: getString
; Description: Moves the user's input into a memory location. 
; Parameters: address, length
;*************************************************************
getString MACRO address, length	
	push	     edx
	push	     ecx
	mov  	edx, address
	mov  	ecx, length
	call 	ReadString
	pop		ecx
	pop		edx
ENDM


;******************************************************************
; Macro: displayString
; Description: Displays string stored in specified memory location.
; Parameters: theString
;*******************************************************************
displayString  MACRO     theString
	push	     edx
	mov		edx, OFFSET theString
	call	     WriteString
	pop		edx
ENDM

MAXNUMS = 10        ; max number of inputs from user

.data 

buffer		BYTE 255 DUP(0)
stringTemp	BYTE	32 DUP(?);
introMsg1		BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",0
introMsg2      BYTE "Written by: Peter Moldenhauer",0
introMsg3		BYTE	"Please provide 10 unsigned decimal integers.",0
introMsg4		BYTE	"Each number needs to be small enough to fit inside a 32 bit register.",0
introMsg5      BYTE "After you have finished inputting the raw numbers I will display a list",0
introMsg6		BYTE	"of the integers, their sum, and their average value.",0
userPrompt	BYTE	"Please enter an unsigned number: ", 0
errorMsg		BYTE	"Error: You did not enter an unsigend number or your number was too big.",0
redoMsg        BYTE "Please try again: ",0
valueMsg		BYTE	"You entered the following numbers: ",0
spaces         BYTE "  ",0
sumMsg		BYTE	"The sum of these numbers is: ",0
averageMsg	BYTE	"The average is: ",0
rounded        BYTE " (rounded up)",0
goodbyeMsg	BYTE	"Thanks for playing! Goodbye!", 0
sum			DWORD     ?
average		DWORD	?
theArray		DWORD     10 DUP(0)

.code
main PROC

;Print intro messages to screen using macro 
	displayString	introMsg1
	call      CrLf
	displayString	introMsg2
	call	     CrLf 
     call      CrLf    
	displayString	introMsg3
	call      CrLf
	displayString	introMsg4
	call	     CrLf
     displayString  introMsg5
     call      CrLf
     displayString  introMsg6
     call      CrLf 
	call	     CrLf

;Set loop counter
	mov		ecx, MAXNUMS
	mov		edi, OFFSET theArray

userInputLabel:
;Display prompt for user input
     displayString	userPrompt

;Push onto stack, call ReadVal
	push	     OFFSET buffer
	push	     SIZEOF buffer
	call	     ReadVal

;Go to next array spot	
	mov		eax, DWORD PTR buffer
	mov		[edi], eax
	add		edi, 4				     ;For next DWORD in array

;Loop if not 10 values yet
	loop	     userInputLabel


;Show the user what they entered into the array (below)

;Set loop variables
	mov		ecx, MAXNUMS
	mov		esi, OFFSET theArray
	mov		ebx, 0					;For calculating sum

;Display message
	call      CrLf 
     displayString	valueMsg
	call		CrLf

;Calculate the sum and Print numbers to screen 
sumAgainLabel:
	mov		eax, [esi]
	add		ebx, eax				     ;add eax to the sum

;Push parameters eax and stringTemp and call WriteVal
	push	     eax
	push	     OFFSET stringTemp
	call	     WriteVal
     displayString  spaces 
	add		esi, 4					;increment the array looper
	loop	     sumAgainLabel

;Display the sum
	mov		eax, ebx
	mov		sum, eax
     call      CrLf 
	displayString	sumMsg

;Push sum and stringTemp paramaters and call WriteVal
	push	     sum
	push	     OFFSET stringTemp
	call	     WriteVal
	call	     CrLf


;Calculate the average (sum in eax)

;Clear edx and move 10 into ebx
	mov		ebx, MAXNUMS
	mov		edx, 0

;Divide the sum by 10
	div		ebx

;Determine if average needs to be rounded up
	mov		ecx, eax
	mov		eax, edx
	mov		edx, 2
	mul		edx
	cmp		eax, ebx
	mov		eax, ecx
	mov		average, eax
	jb		noRoundLabel
	inc		eax
	mov		average, eax

noRoundLabel:
	displayString	averageMsg

;Push parameters average and stringTemp and call WriteVal
	push	     average
	push	     OFFSET stringTemp
	call	     WriteVal
     displayString rounded 
	call	     CrLf

;Display goodbye message
	call      CrLf 
     displayString	goodbyeMsg
	call	     CrLf
     call      CrLf 

     exit                                     ; exit to operating system 
main ENDP 


;**************************************************************************************
; Procedure: ReadVal
; Description: Invokes getString macro to get the user's string of digits. Converts
; the digits string to numbers and validates input.
; Parameters: OFFSET buffer, SIZEOF buffer
; preconditions: getString macro must be defined
; registers changed: ebp, edx, ecx, eax, ebx 
;***************************************************************************************
readVal PROC
; Set up stack 
     push	     ebp
	mov		ebp, esp
	pushad

StartLabel:
	mov		edx, [ebp+12]	          ;address of buffer
	mov		ecx, [ebp+8]	          ;size of buffer into ecx

;Read the input
	getString	edx, ecx

;Set registers
	mov		esi, edx
	mov		eax, 0
	mov		ecx, 0
	mov		ebx, 10

;Load the string in byte by byte
LoadByteLabel:
	lodsb					     ;loads from memory at esi
	cmp		ax, 0			     ;check if we have reached the end of the string
	je		DoneLabel

;Check the range if char is int in ASCII
	cmp		ax, 48				;0 is ASCII 48
	jb		ErrorLabel
	cmp		ax, 57				;9 is ASCII 57
	ja		ErrorLabel

;Adjust for value of digit
	sub		ax, 48
	xchg	     eax, ecx
	mul		ebx				     ;mult by 10 for correct digit place
	jc		ErrorLabel
	jnc		NoErrorLabel

ErrorLabel:
	displayString	errorMsg
     call      CrLf 
     displayString redoMsg 
	jmp		StartLabel

NoErrorLabel:
	add		eax, ecx
	xchg	     eax, ecx		          ;Exchange for the next loop through
	jmp		LoadByteLabel	          ;Parse next byte
	
DoneLabel:
	xchg	     ecx, eax
	mov		DWORD PTR buffer, eax	;Save int in passed variable
; restore stack and return 
     popad
	pop       ebp
	ret       8
readVal ENDP


;******************************************************************************************************
; Procedure: WriteVal
; Description: Convert numeric value to a string of digits  and invoke displayString to produce output.
; Parameters: integer and string (memory) to write the output
; preconditions: displayString macro must be defined
; registers changed : ebp, edx, eax, ebx, edi 
;*******************************************************************************************************
writeVal PROC
; Set up stack 
     push	     ebp
	mov		ebp, esp
	pushad		                    ;save registers

;Set for looping through the integer
	mov		eax, [ebp+12]	     ;move integer to convert to string to eax
	mov		edi, [ebp+8]	     ;move address to edi to store string
	mov		ebx, 10
	push	     0

ConvertLabel:
	mov		edx, 0
	div		ebx
	add		edx, 48
	push	     edx				;push next digit onto stack

;Check if at end
	cmp		eax, 0
	jne		ConvertLabel

;Pop numbers off the stack
PopLabel:
	pop		[edi]
	mov		eax, [edi]
	inc		edi
	cmp		eax, 0		     ;check if the end
	jne		PopLabel

;Write as string using macro
	mov		edx, [ebp+8]
	displayString	OFFSET stringTemp  

; Restore stack and return 	
     popad		             
	pop       ebp
	ret       8
writeVal ENDP


END main 