TITLE Program1(Program1.asm)

; Author: Peter Moldenhauer
; Date: 9 / 23 / 16
; OSU Email : moldenhp@oregonstate.edu
; Course - Section: CS271 - 400
; Assignment: Program 1
; Assignment Due Date : 10 / 9 / 16
; Description: This program prompts the user for two numbers and then calculates the
; sum, difference, product, (integer)quotient and remainder of the numbers.
; Extra Credit : Validate the second number to be less than the first

INCLUDE Irvine32.inc

.data
; Extra credit notifications
ec2       BYTE      "**EC: Program repeats until user chooses to quit.", 0
ec3       BYTE      "**EC: Program validates the second number to be less than the first.", 0


input1    DWORD ?        ; first integer entered by user
input2    DWORD ?        ; second integer entered by user
intro_1   BYTE      "             MASM Arithmetic - Program1    by: Peter Moldenhauer", 0
intro_2   BYTE      "Enter 2 numbers, and I'll show you the sum, difference, product, quotient and remainder", 0
ec1       BYTE      "The second number must be less than the first!", 0
getnum1   BYTE      "First number: ", 0
getnum2   BYTE      "Second number: ", 0
sum       DWORD ?        ; calculated sum of both numbers
dif       DWORD ?        ; calculated difference of both numbers
pro       DWORD ?        ; calculated product of both numbers
quo       DWORD ?        ; calculated quotient of division of numbers
rem       DWORD ?        ; calculated remainder of division of numbers
sign1     BYTE      " + ", 0
sign2     BYTE      " - ", 0
sign3     BYTE      " X ", 0
sign4     BYTE      " / ", 0
sign5     BYTE      " = ", 0
remState  BYTE      " remainder ", 0
again     BYTE      "Do you want to enter new numbers? (y/n) ", 0
choice    BYTE ?         ; input from user to quit or enter new numbers 
close     BYTE      "Pretty Cool huh?  Goodbye!!!", 0

.code
main PROC

; Introduction and instructions to user
     mov       edx, OFFSET    intro_1
     call      WriteString
     call      CrLf 
     mov       edx, OFFSET    ec2
     call      WriteString
     call      CrLf
     mov       edx, OFFSET    ec3
     call      WriteString
     call      CrLf
     call      CrLf
     mov       edx, OFFSET    intro_2 
     call      WriteString
     call      CrLf 
     call      CrLf

top:      ; this is the destination for the loop to get the input numbers (extra credit)

; Prompt user for data and get the data
     mov       edx, OFFSET    ec1       
     call      WriteString    
     call      CrLf
     call      CrLf

toptop:   ; this is the destination for the loop to repeat program if user desires to(extra credit)

     mov       edx, OFFSET    getnum1 
     call      WriteString 
     call      ReadInt
     mov       input1,   eax
      
     mov       edx, OFFSET    getnum2
     call      WriteString 
     call      ReadInt 
     mov       input2,   eax
     call      CrLf 

     cmp       eax, input1         ; compare input2 with input1 (extra credit)
     ja        top                 ; jump back to loop destination if input2 is above input1 (extra credit)

; Calculate the required values ( +, -, *, / )
     ; addition
     mov       eax, input1
     mov       ebx, input2
     add       eax, ebx
     mov       sum, eax

     ; subtraction
     mov       eax, input1
     mov       ebx, input2
     sub       eax, ebx
     mov       dif, eax

     ; multiplication
     mov       eax, input1
     mov       ebx, input2
     mul       ebx
     mov       pro, eax

     ; division
     mov       eax, input1
     cdq
     mov       ebx, input2
     div       ebx
     mov       quo, eax
     mov       rem, edx

; Display the results
     ; addition
     mov       eax, input1
     call      WriteDec
     mov       edx, OFFSET    sign1
     call      WriteString 
     mov       eax, input2
     call      WriteDec
     mov       edx, OFFSET    sign5
     call      WriteString
     mov       eax, sum
     call      WriteDec
     call      CrLf

     ; subtraction
     mov       eax, input1
     call      WriteDec
     mov       edx, OFFSET    sign2
     call      WriteString
     mov       eax, input2
     call      WriteDec
     mov       edx, OFFSET    sign5 
     call      WriteString
     mov       eax, dif
     call      WriteDec
     call      CrLf

     ; multiplication 
     mov       eax, input1
     call      WriteDec
     mov       edx, OFFSET    sign3
     call      WriteString
     mov       eax, input2
     call      WriteDec
     mov       edx, OFFSET    sign5
     call      WriteString
     mov       eax, pro
     call      WriteDec
     call      CrLf

     ; division 
     mov       eax, input1
     call      WriteDec
     mov       edx, OFFSET    sign4
     call      WriteString
     mov       eax, input2
     call      WriteDec
     mov       edx, OFFSET    sign5
     call      WriteString
     mov       eax, quo
     call      WriteDec
     mov       edx, OFFSET    remState
     call      WriteString
     mov       eax, rem
     call      WriteDec
     call      CrLf
     call      CrLf

; Extra Credit: Ask user about entering in new numbers (loop through everything again)
     mov       edx, OFFSET    again
     call      WriteString
     call      ReadChar 
     mov       choice,   al 
     call      CrLf
     call      CrLf
     cmp       choice,   'Y'
     je        toptop         ; jump to top of program if user input equals Y
     cmp       choice,   'y'
     je        toptop         ; jump to top of program if user input equals y

; Say goodbye
     mov       edx, OFFSET    close
     call      WriteString
     call      CrLF
     call      CrLf

     exit; exit to operating system
main ENDP

; (insert additional procedures here)

END main
