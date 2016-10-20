TITLE Program3_Moldenhauer (Program3_Moldenhauer.asm)

; Author: Peter Moldenhauer
; Date: 10/19/16
; OSU Email : moldenhp@oregonstate.edu
; Course - Section: CS271 - 400
; Assignment: Program 3
; Assignment Due Date : 10/30/16
; Description: This program repeatedly prompts the user to enter a number. The program validates the 
; user input to be in the range of -100 to -1. The program then counts and accumulates the valid user numbers 
; until a non-negative number is entered. The program will calculate the rounded integer average of the negative numbers.
; EXTRA CREDIT: Number the lines during user input
; EXTRA CREDIT: Do something astoundingly creative 

INCLUDE Irvine32.inc

LOWERLIMIT = -100
UPPERLIMIT = -1

.data
	
	intro          BYTE		"Welcome to the Integer Accumulator by Peter Moldenhauer",0
     ec1  		BYTE		"**EC: Number the lines during user input**", 0
     ec2            BYTE      "**EC: Do something astoundingly creative**",0
	namePrompt	BYTE		"What is your name? ",0
     userName		BYTE		33 DUP(0)                                    ; String to be entered by user
	greeting		BYTE		"Hello ",0
	
	instruct1		BYTE		"Please enter numbers in [-100, -1]",0
	instruct2		BYTE		"Enter a non-negative number when you are finished to see results.",0
	instruct3		BYTE		" - Enter number: ",0
	printTotal	BYTE		"The total number of valid numbers you entered: ",0
	printSum		BYTE		"The sum of your valid numbers: ",0
	printAvg		BYTE		"The rounded average of your valid numbers: ",0
	
	sMessage		BYTE		"You did not enter any negative numbers at all!",0
     byeMessage1    BYTE      "Thank you for playing Integer Accumulator!",0
     byeMessage2	BYTE		"Goodbye ", 0

     msgBox1        BYTE      "Integer Accumulator Program complete",0
     msgBox2        BYTE      "Pretty cool program, ay?"
                    BYTE      0dh, 0ah
                    BYTE      "Should Peter Moldenhauer get extra credit for this?",0
	
	userInput		DWORD		?
	theTotal		DWORD		0
	theSum		DWORD		?
	theAvg		DWORD		?

.code
main PROC

; Introduction 
	mov		edx, OFFSET intro
	call	     WriteString
	call	     CrLf
	mov		edx, OFFSET ec1
	call	     WriteString
	call	     CrLf
     mov		edx, OFFSET ec2
     call	     WriteString
     call	     CrLf

; Get user name
	mov		edx, OFFSET namePrompt
	call	     WriteString
	mov		edx, OFFSET UserName
	mov		ecx, 32
	call	     ReadString

; Greet user
	mov		edx, OFFSET greeting
	call	     WriteString
	mov		edx, OFFSET userName
	call	     WriteString
	call	     CrLf
     call      CrLf

; Give user instructions
	mov		edx, OFFSET instruct1
	call	     WriteString
	call	     CrLf
	mov		edx, OFFSET instruct2
	call	     WriteString
	call	     CrLf

; Repeatedly prompt user to enter a number and validate the user input
L1:
	; Extra credit - Number the lines during user input 
	mov		eax, theTotal
	call	     WriteDec

; Validate for range of -100 to -1 - Loops back if less than -100 or exits if greater than -1
	mov		edx, OFFSET instruct3
	call	     WriteString
	call	     ReadInt
	mov		userInput, eax
	cmp		userInput, LOWERLIMIT
	jl		L1
	cmp		userInput, UPPERLIMIT
	jg		L2

; Passed validation now calculate variables

; Increment the total number of inputs
	inc		theTotal
; Add to sum
	mov		eax, theSum
	add		eax, userInput
	mov		theSum, eax

; Loopback to main loop
	loop	L1

; Code executed after user terminates loop by entering a non-negative number 
L2:

; Jump to the end of program if there were no negative inputs at all
	cmp		theTotal, 1
	jl		L3

; Print total number of inputs
	mov		edx, OFFSET printTotal
	call	     WriteString
	mov		eax, theTotal
	call	     WriteDec
	call	     CrLf

; Print sum
	mov		edx, OFFSET printSum
	call 	WriteString
	mov		eax, theSum
	call	     WriteInt
	call	     CrLf

; Calculate Average
	mov		eax, theSum
	cdq
	mov		ebx, theTotal
	idiv	     ebx
	mov		theAvg, eax

; Print Average
	mov		edx, OFFSET printAvg
	call	     WriteString
	mov		eax, theAvg
	call 	WriteInt
	call	     CrLf

; Extra Credit - Display a graphical popup message box 
     mov       ebx, OFFSET msgBox1
     mov       edx, OFFSET msgBox2
     call      MsgBoxAsk

L3:

; If no negative numbers entered..
	cmp		theTotal, 0
	je		L4
	jne		L5

L4:
	mov		edx, OFFSET sMessage
	call	     WriteString
	jmp		L5

L5:
; Say goodbye to user
	call	     CrLf
     mov		edx, OFFSET byeMessage1
     call	     WriteString
     call      CrLf
	mov		edx, OFFSET byeMessage2
	call	     WriteString
	mov		edx, OFFSET userName
	call	     WriteString
	call	     CrLf

; exit to operating system
	exit
main ENDP

; (insert additional procedures here)

END main