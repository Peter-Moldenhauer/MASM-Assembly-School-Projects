TITLE Program4_Moldenhauer (Program4_Moldenhauer.asm)

; Author: Peter Moldenhauer
; Date: 10/24/16
; OSU Email : moldenhp@oregonstate.edu
; Course - Section: CS271 - 400
; Assignment: Program 4
; Assignment Due Date: 11/6/16
; Description: This program calculates composite numbers. The user enters an integer n that is between 1 and 400
; The program then calculates and displays all of the composite numbers up to and including the nth composite. 

INCLUDE Irvine32.inc

LOWERLIMIT = 1
UPPERLIMIT = 400
TAB = 09h 

.data
	
	introMsg       BYTE      "Composite Numbers      Programed by: Peter Moldenhauer",0
     ec1            BYTE      "**EC: Align the output columns**",0
     instruct1      BYTE      "Enter the number of conposite numbers you would like to see.",0
     instruct2      BYTE      "I'll accept orders for up to 400 composites.",0
     instruct3      BYTE      "Enter the number of composites to display [1...400]: ",0
     error1         BYTE      "Input not valid. Try again!",0
     goodbye        BYTE      "Results certified by Peter Moldenhauer.   Goodbye!",0
     input          DWORD     ?
     composite      DWORD     ?
     lineCount      DWORD     0

.code
main PROC

     call      introduction
     call      getUserData
     call      showComposites
     call      farewell  

; exit to operating system
	exit
main ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description: This procedure displays the intro messages
; Receives: introMsg, ec1, instruct1, instruct2
; Returns: none
; Preconditions: none
; Registers changed: edx 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
introduction PROC

     mov       edx, OFFSET introMsg
     call      WriteString
     call      CrLf
     mov       edx, OFFSET ec1
     call      WriteString
     call      CrLf 
     call      CrLf
     mov       edx, OFFSET instruct1
     call      WriteString
     call      CrLf
     mov       edx, OFFSET instruct2
     call      WriteString
     call      CrLf
     call      CrLf
     ret

introduction ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description: This procedure gets input from the user
; Receives: input, instruct3  
; Returns: none
; Preconditions: none
; Registers changed : edx, eax 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getUserData PROC 

     ; Prompt user for input
     mov       edx, OFFSET instruct3
     call      WriteString
     call      ReadInt
     mov       input, eax 

     ; validate input 
     call      validate 
     ret

getUserData ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description: This procedure validates user input
; Receives: error1 
; Returns: none
; Preconditions: none
; Registers changed : edx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validate PROC 

     ; validate if input is within range of 1 to 400, if not then jump to error section 
     cmp       input, LOWERLIMIT
     jl        ErrorSection 
     cmp       input, UPPERLIMIT
     jg        ErrorSection
     call      CrLf 
     ret

ErrorSection:  
     ; display an error message and jump back to get user input procedure
     mov       edx, OFFSET error1
     call      WriteString
     call      CrLf
     jmp       getUserData

validate ENDP 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description: This procedure calculates and displays the composites for a given number
; Receives: input, composite, lineCount, TAB 
; Returns: none
; Preconditions: input variable must be in the range of 1...400 
; Registers changed : eax, ebx, ecx, edx 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showComposites PROC

     ; set up the procedure by moving input to the loop counter register
     ; Also initialize eax as the lowest composite number (4) and ebx as the lowest divider for composite numbers (2)
     mov       ecx, input
     mov       eax, 4
     mov       composite, eax
     mov       ebx, 2

     ; initialize outerloop to the input counter 
OuterLoop: 

     ; call isComposite procedure to find the next composite number
     call      isComposite

     ; when composite number is found, output it to screen and increment composite 
     mov       eax, composite 
     call      WriteDec
     inc       composite 

     ; count number of numbers in each line and then either add a new line or add spaces depending on number
     inc       lineCount
     mov       eax, lineCount
     mov       ebx, 10
     cdq 
     div       ebx 
     cmp       edx, 0
     je        AddNewLine
     jne       AddTab

AddNewLine:

     call      CrLf
     jmp       Continue 

AddTab:
      
     mov       al, TAB  
     call      WriteChar 

Continue:

     ; reset registers and loop the outer loop again 
     mov       ebx, 2
     mov       eax, composite
     loop      OuterLoop 

     ; finished looping, exit procedure
     ret 

showComposites ENDP 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description: This procedure finds the next composite number and returns it
; Receives: composite 
; Returns: none
; Preconditions: this procedure is called in showComposites procedure 
; Registers changed : eax, ebx, edx 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
isComposite PROC 

InnerLoop:

     ; check if number is still possibly be composite
     cmp       ebx, eax

     ; if not, jump to increment the number of restarting 
     je        NotComposite1

     ; check if number is composite by dividing and comparing with 0
     cdq
     div       ebx
     cmp       edx, 0
     je        YesComposite
     jne       NotComposite2 

     ; if number is composite, exit inner loop 
YesComposite:

     ret

     ; if number is not composite with divisior, incrment divisor, reset number and restart inner loop
NotComposite2:

     mov       eax, composite
     inc       ebx 
     jmp       InnerLoop

     ; if number is not composite at all, increment composite number, reset divisor and restart inner loop 
NotComposite1:

     inc       composite 
     mov       eax, composite 
     mov       ebx, 2
     jmp       InnerLoop

isComposite ENDP 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description: This procedure displays a goodbye message on the screen
; Receives: goodbye 
; Returns: none
; Preconditions: none
; Registers changed : edx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
farewell PROC

     call      CrLf 
     call      CrLf 
     mov       edx, OFFSET goodbye 
     call      WriteString
     call      CrLf 
     call      CrLf 
     ret 

farewell ENDP 

END main