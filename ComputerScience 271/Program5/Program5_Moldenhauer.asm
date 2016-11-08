TITLE Program5_Moldenhauer         (Program5_Moldenhauer.asm)

; Author: Peter Moldenhauer
; Date: 11/10/16
; OSU Email : moldenhp@oregonstate.edu
; Course - Section: CS271 - 400
; Assignment: Program 5
; Assignment Due Date: 11/20/16
; Description: This program uses indirect addressing, parameter passing, gernerating random numbers and working with arrays
; The program will get a user request in the range of 10 to 200. It will then generate "request" number of random numbers in the range 
; of 100 to 999. It will then store these numbers in consecutive elements of an array. Next, the program will display the list of numbers. 
; The program will then sort the list in decending order and calculate the median value of the numbers. Finally, the median value will be 
; displayed as well as the sorted list. 

INCLUDE Irvine32.inc

min = 10
max = 200
lo = 100
hi = 999

.data

intro1         BYTE      "Sorting Random Integers                By: Peter Moldenhauer",0
intro2         BYTE      "This program gernerates random numbers in the range [100...999],",0
intro3         BYTE      "displays the original list, sorts the list, and calculates the",0
intro4         BYTE      "median value. Finally, it displays the list sorted in decending order.",0
inputPrompt    BYTE      "How many numbers should be generated? [10...200]: ",0
errorMsg       BYTE      "Invalid input",0
title1         BYTE      "The unsorted random numbers:",0
title2         BYTE      "The sorted list:",0
title3         BYTE      "The median is: ",0
spaces         BYTE      "    ", 0

userInput      DWORD     ?
userArray      DWORD     max  DUP(?)
arrayCount     DWORD     0 

.code 

;----------------------------------------------------------------
; Title: main
; Description: Initilize the entire program
; Parameters: None
; Returns: Printed data from other procedures
; Preconditions: none
; Registers changed: none 
;-----------------------------------------------------------------
main PROC
     ; Display intro messages
     push      OFFSET    intro1              ; pass by reference 
     push      OFFSET    intro2              ; pass by reference
     push      OFFSET    intro3              ; pass by reference
     push      OFFSET    intro4              ; pass by reference 
     call      introduction 

     ; Get the user input
     push      OFFSET    userInput           ; pass by reference 
     call      getData 

     ; Fill the array with random numbers 
     push      OFFSET    userArray           ; pass by reference
     push      userInput                     ; pass by value
     call      fillArray 

     ; Display the unsorted array 
     push      OFFSET    userArray           ; pass by reference 
     push      userInput                     ; pass by value 
     push      OFFSET    title1              ; pass by reference 
     call      displayList 

     ; Sort the array in decending order 
     push      OFFSET    userArray           ; pass by reference 
     push      userInput                     ; pass by value 
     call      sortList 

     ; Calculate and display the median
     push      OFFSET    userArray           ; pass by reference 
     push      userInput                     ; pass by value 
     push      OFFSET    title3              ; pass by reference 
     call      displayMedian 

     ; Display the sorted array 
     push      OFFSET    userArray           ; pass by reference 
     push      userInput                     ; pass by value 
     push      OFFSET    title2              ; pass by reference 
     call      displayList 

     ; Exit to OS 
     exit

main ENDP 

;------------------------------------------------------------------
; Title: introduction
; Description: Prints out intro messages and instructions 
; Parameters: None
; Returns: intro messages 
; Preconditions: intro messages pushed on stack 
; Registers changed : edx, ebp
;-------------------------------------------------------------------
introduction PROC
     
     ; set up stack 
     pushad
     mov       ebp, esp

     ; access intro1
     mov       edx, [ebp+48]
     call      WriteString
     call      CrLf 

     ; access intro2
     mov       edx, [ebp+44]
     call      WriteString
     call      CrLf

     ; access intro3
     mov       edx, [ebp+40]
     call      WriteString 
     call      CrLf

     ; access intro4
     mov       edx, [ebp+36]
     call      WriteString
     call      CrLf
     call      CrLf 

     ; restore stack and return
     popad
     ret       16

introduction ENDP 

; ------------------------------------------------------------------
; Title: getData
; Description: Gets user input and validates input 
; Parameters: userInput 
; Returns: userInput 
; Preconditions: userInput on stack 
; Registers changed : ebp, ebx, edx, eax 
; -------------------------------------------------------------------
getData PROC

     ; Set up stack
     push      ebp
     mov       ebp, esp
     mov       ebx, [esp+8]

     ; Give prompts to user and get input 
GivePrompt:
     mov       edx, OFFSET    inputPrompt 
     call      WriteString
     call      ReadInt

     ; Validate - Compare and jump based on user input
     cmp       eax, min
     jl        BadInput
     cmp       eax, max
     jg        BadInput
     jmp       GoodInput 

     ; If input is invalid, give error message and loop again 
BadInput:
     mov       edx, OFFSET    errorMsg
     call      WriteString
     call      CrLf 
     jmp       GivePrompt

     ; If input is valid, save input, restore stack and return 
GoodInput:
     call      CrLf 
     mov       [ebx], eax
     pop       ebp 
     ret       4

getData ENDP 

; ------------------------------------------------------------------
; Title: fillArray
; Description: Fills array with random numbers 
; Parameters: userInput, userArray 
; Returns: array with random numbers 
; Preconditions: userInput and userArray on stack
; Registers changed : ebp, ebx, ecx, eax, edi 
; -------------------------------------------------------------------
fillArray PROC 
     
     ; Set up stack, loop counter and initialize array 
     push      ebp
     mov       ebp, esp
     mov       edi, [ebp+12]                 ; addres of array is in edi 
     mov       ecx, [ebp+8]                  ; value of count in ecx 
     call      Randomize                     ; generates random number 

     ; If there are still empty places in the array, keep generating random numbers to fill 
KeepFilling:
     mov       eax, hi 
     sub       eax, lo
     inc       eax 
     call      RandomRange 
     add       eax, lo 

     ; Set number, increment and repeat if ecx != 0  
     mov       [edi], eax
     add       edi, 4 
     loop      KeepFilling

     ; Restore stack
     pop       ebp
     ret       8

fillArray ENDP

; ------------------------------------------------------------------
; Title: displayList 
; Description: Prints out list to the screen
; Parameters: userInput, userArray, title 
; Returns: printed array 
; Preconditions: userInput, userArray and title on stack
; Registers changed : ebp, esi, edx, eax, 
; -------------------------------------------------------------------
displayList PROC

     ; Set up stack, loop counter and title 
     push      ebp
     mov       ebp, esp
     mov       esi, [ebp+16]                      ; address of array
     mov       ecx, [ebp+12]                      ; ecx is the loop counter
     mov       edx, [ebp+8]                       ; edx is the title 
     mov       ebx, 0
     call      WriteString 
     call      CrLf 

     ; Count rows, keep looping through array 
KeepLooping:
     inc       ebx
     mov       eax, [esi]
     call      WriteDec
     add       esi, 4
     cmp       ebx, 10                            ; 10 numbers per line
     jne       AddSpaces 
     call      CrLf 
     mov       ebx, 0
     jmp       EndLooping

     ; Add spaces inbetween numbers on each row
AddSpaces:
     mov       edx, OFFSET    spaces 
     call      WriteString

     ; restore stack and end looping 
EndLooping:
     loop      KeepLooping
     call      CrLf
     call      CrLf 
     pop       ebp
     ret       12 

displayList ENDP 

; ------------------------------------------------------------------
; Title: sortList 
; Description: takes the random numbers in array and sorts them 
; Parameters: userInput, userArray
; Returns: array sorted in decending order 
; Preconditions: userInput, userArray on stack
; Registers changed : ebp, ecx, eax, edx, esi 
; -------------------------------------------------------------------
sortList PROC

     ; Set up stack and loop counter
     pushad 
     mov       ebp, esp
     mov       ecx, [ebp+36]
     mov       edi, [ebp+40]
     dec       ecx
     mov       ebx, 0

     ; Initialize outer loop
OuterLoop:
     mov       eax, ebx
     mov       edx, eax
     inc       edx 
     push      ecx 
     mov       ecx, [ebp+36]                       

     ; Initialize inner loop
InnerLoop:
     mov       esi, [edi+edx*4]
     cmp       esi, [edi+eax*4]
     jle       L1 
     mov       eax, edx

     ; Skip if not greater
L1:
     inc       edx
     loop      InnerLoop

     ; If greater then swap numbers
     lea       esi, [edi+ebx*4]
     push      esi
     lea       esi, [edi+eax*4]
     push      esi 
     call      exchange 
     pop       ecx 
     inc       ebx 
     loop      OuterLoop
     
     ; Restore stack and return 
     popad 
     ret       8

sortList ENDP 

; ------------------------------------------------------------------
; Title: exchange 
; Description: gets array indexes and swaps them 
; Parameters: array indexes 
; Returns: swapped array indexes 
; Preconditions: stack set up in sortList procedure  
; Registers changed : ebp, ecx, eax, edx 
; -------------------------------------------------------------------
exchange PROC

     ; Set up stack 
     pushad 
     mov       ebp, esp
     
     ; Swap array values
     mov       eax, [ebp+40]                      ; low: array[k]
     mov       ecx, [eax]
     mov       ebx, [ebp+36]                      ; high: array[i]
     mov       edx, [ebx]
     mov       [eax], edx 
     mov       [ebx], ecx 

     ; Restore stack and return 
     popad 
     ret       8

exchange ENDP 

; ------------------------------------------------------------------
; Title: displayMedian
; Description: calculates and prints the median of the array 
; Parameters: userInput, userArray, title
; Returns: median number of array 
; Preconditions: userInput, userArray and title on stack
; Registers changed : ebp, edi, eax, ebx, edx 
; -------------------------------------------------------------------
displayMedian PROC

     ; Set up stack
     pushad 
     mov       ebp, esp
     mov       edi, [ebp+44]

     ; Print "median" title
     mov       edx, [ebp+36]
     call      WriteString

     ; Calculate median
     mov       eax, [ebp+40]
     cdq  
     mov       ebx, 2
     div       ebx
     shl       eax, 2                             ; shift left 2 
     add       edi, eax
     cmp       edx, 0
     je        EvenNum 

     ; Display median if its an odd numbered array 
     mov       eax, [edi]
     call      WriteDec
     call      CrLf 
     call      CrLf 
     jmp       Done 

     ; Display median if its an even numbered array 
EvenNum:
     mov       eax, [edi] 
     add       eax, [edi-4]
     cdq 
     mov       ebx, 2
     div       ebx 
     call      WriteDec 
     call      CrLf
     call      CrLf 

     ; Restore stack and return 
Done:
     popad 
     ret       12

displayMedian ENDP 


END main 