TITLE Program2_Moldenhauer (Program2_Moldenhauer.asm)

; Author: Peter Moldenhauer
; Date: 10/4/16
; OSU Email : moldenhp@oregonstate.edu
; Course - Section: CS271 - 400
; Assignment: Program 2
; Assignment Due Date : 10/16/16
; Description: This program calculats Fibonacci numbers

INCLUDE Irvine32.inc

LOW_LIMIT = 1       ; low limit number defined as a constant
HIGH_LIMIT = 46     ; high limit number defined as a constant
TAB = 09h           ; used to alling columns for extra credit, use tabs not spaces!

.data
intro_1   BYTE      "Fibonacci Numbers",0
intro_2   BYTE      "Programmed by Peter Moldenhauer",0
getName   BYTE      "What's your name? ",0
userName  BYTE      33 DUP(0)                     ; string to be entered by user
hello     BYTE      "Hello, ",0
inst1     BYTE      "Enter the number of Fibonacci terms to be displayed. ",0
inst2     BYTE      "Give the number as an integer in the range [1...46]. ",0
enterT    BYTE      "How many Fibonacci terms do you want? ",0
terms     DWORD ?                                 ; integer to be entered by user
badT      BYTE      "Out of range. Enter a number in the range of [1...46]. ",0
bye1      BYTE      "Results certified by Peter Moldenhauer.",0
bye2      BYTE      "Goodbye, ",0

startNum  BYTE      "1",0
firNum    DWORD     0
secNum    DWORD     1 
sum       DWORD     ?
count     BYTE      5

; extra credit options
ec1       BYTE      "** EC: Display the numbers in aligned columns **",0
ec2       BYTE      "** EC: Do something incredible - change text colors **",0

.code
main PROC
     
     ; Extra Credit - change text color
     mov       eax, yellow 
     call      SetTextColor 

     ; Introduction, display program title and programmers name
     mov       edx, OFFSET    intro_1
     call      WriteString
     call      CrLf
     mov       edx, OFFSET    intro_2
     call      WriteString
     call      CrLf
     
     ; Extra Credit - change text color
     mov       eax, lightGreen
     call      SetTextColor

     ; Display extra credit options
     mov       edx, OFFSET    ec1
     call      WriteString
     call      CrLf
     mov       edx, OFFSET    ec2
     call      WriteString
     call      CrLf
     call      CrLf

     ; Extra Credit - change text color
     mov       eax, yellow
     call      SetTextColor

     ; Get user name and greet user
     mov       edx, OFFSET    getName 
     call      WriteString
     mov       edx, OFFSET    userName
     mov       ecx, 32                       ; Restring procedure, accept 32 characters because we initially allowed 33 to be entered(all 0 by default) so having 32 ensures that there will be one remaining 0 at end
     call      ReadString
     mov       edx, OFFSET    hello
     call      WriteString
     mov       edx, OFFSET    userName
     call      WriteString
     call      CrLf
     call      Crlf 

     ; User instructions 
     mov       edx, OFFSET    inst1
     call      WriteString 
     call      CrLf
     mov       edx, OFFSET    inst2
     call      WriteString
     call      CrLf
     call      CrLf

GETINPUT:
     ; Extra Credit - change text color
     mov       eax, yellow 
     call      SetTextColor 

     ; Get data from the user
     mov       edx, OFFSET    enterT
     call      WriteString
     call      ReadInt
     mov       terms, eax
     call      Crlf

     ; Compare user input to limits
     cmp       eax, LOW_LIMIT                ; check to see if input is less than 1
     jb        BADINPUT
     cmp       eax, HIGH_LIMIT               ; check to see if input is higher than 46
     ja        BADINPUT
     jmp       GETFIB                        ; if input is in limits, jump to GETFIB section

BADINPUT:
     ; Extra Credit - change text color
     mov       eax, lightRed 
     call      SetTextColor 

     ; Display error message
     mov       edx, OFFSET    badT
     call      WriteString 
     call      CrLf
     jmp       GETINPUT                      ; jump to get GETINPUT section 

     ; Display the fib sequence on the screen
GETFIB:                                      
     mov       ecx, terms                    ; initialize the counter for loop instruction

     ; Extra Credit - change text color
     mov       eax, white 
     call      SetTextColor 

     FIBLOOP:
          ; Get the first fib number
          cmp       ecx, terms
          jne       CALCFIB
          mov       edx, OFFSET    startNum
          call      WriteString
          jmp       ALLIGN

     CALCFIB:
          ; Calculate the rest of the fib numbers 
          mov       eax, firNum
          add       eax, secNum
          mov       sum, eax 
          
          ; reassign first and second numbers
          mov       ebx, secNum
          mov       firNum, ebx
          mov       secNum, eax

          ; Display new number in sequence
          mov       edx, OFFSET    sum
          call      WriteDec
          
     ALLIGN:
          ; Extra Credit - Align the columns in output
          mov       eax, terms
          mov       ebx, ecx
          dec       ebx 
          sub       eax, ebx 
          cmp       eax, 35
          ja        TABONE
          ; Output this tab if numbers are too short
          mov       al, TAB
          call      WriteChar

     TABONE:
          ; Output this first tab always (even if numbers are too long)
          mov       al, TAB
          call      WriteChar 

     LINETERMS:
          ; check to see how many digits are on the line
          mov       al, count
          dec       al
          mov       count, al
          jz        NEWLINE
          jmp       LOOPBOT

     NEWLINE:
          ; print fib numbers on a new line if needed
          call      CrLf
          mov       count, 5

     LOOPBOT:
          loop      FIBLOOP 

     ; Extra Credit - change text color
     mov       eax, yellow 
     call      SetTextColor 

     ; Farewell 
     call      CrLF
     call      CrLF
     mov       edx, OFFSET    bye1
     call      WriteString
     call      CrLF
     mov       edx, OFFSET    bye2
     call      WriteString
     mov       edx, OFFSET    userName
     call      WriteString
     call      CrLf
     call      CrLf 

     exit      ; exit to operating system
main ENDP
END main