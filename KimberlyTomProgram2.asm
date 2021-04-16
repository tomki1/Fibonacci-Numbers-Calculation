TITLE Fibonacci Numbers Calculation    (KimberlyTomProgram2.asm)

; Author: Kimberly Tom
; Last Modified: 10/11/18
; OSU email address: tomki@oregonstate.edu
; Course number/section: 271_400
; Project Number: 2                Due Date: 10/14/18
; Description: This program greets the user and calculates Fibonacci numbers given the user's desired integer input.

INCLUDE Irvine32.inc

FIB_MIN = 1																					;lower limit for number of Fibonacci terms									
FIB_MAX = 46																				;upper limit for number of Fibonacci terms

.data
title_1		BYTE	"Fibonacci Numbers Calculation		by Kimberly Tom", 0
EC1			BYTE	"**EC1: Numbers are displayed in aligned columns", 0
EC2			BYTE	"**EC2: Do something incredible, i.e. change font and background color for EC, input, calculation, and error message", 0
prompt_1	BYTE	"What's your name? ", 0
intro_1		BYTE	"Nice to meet you, ",0
userName	BYTE	33 DUP(0)																;string to be entered by user
intro_2		BYTE	"Enter the number of Fibonacci terms to be displayed. It must be an integer in the range [1..46].", 0
prompt_2	BYTE	"How many Fibonaci terms do you want? ", 0
invalidTerm	BYTE	"The integer you entered is not in the range [1..46]. ", 0
n			DWORD	?																		;holds the number of Fibonacci terms
prevTerm1	DWORD	?																		;holds previous term	
prevTerm2	DWORD	?																		;holds 2nd to previous term
lastPrinted	DWORD	?																		;holds the last printed integer
sevenSpaces	BYTE	"       ", 0															;seven blank spaces to help display results
intCount	DWORD	?																		;holds the number of integer results displayed
divFive		DWORD	5																		;used to divide by 5
rowCount	DWORD	?																		;number of rows completed
goodBye		BYTE	"I hope you enjoyed this program. Good Bye, ", 0

.code
main PROC


;introduction
	mov		edx, OFFSET title_1
	call	WriteString
	call	Crlf
	mov		eax, white+(blue*16)						;white on blue 
	call	SetTextColor
	mov		edx, OFFSET EC1
	call	WriteString
	call	Crlf
	mov		edx, OFFSET EC2
	call	WriteString
	mov		eax, lightGray+(black*16)					;lightGray on black 
	call	SetTextColor
	call	Crlf
	call	Crlf

;Get user name
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	mov		eax, magenta+(black*16)						;magenta on black 
	call	SetTextColor
	call	ReadString
	call	Crlf
	mov		eax, lightGray+(black*16)					;lightGray on black
	call	SetTextColor

;greet user
	mov		edx, OFFSET intro_1
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	Crlf

;userInstructions
	mov		edx, OFFSET intro_2
	call	WriteString
	call	Crlf

;getUserData
GetTerm: 
;obtain number of terms from user
	mov		edx, OFFSET prompt_2
	call	WriteString
	mov		eax, magenta+(black*16)					;magenta on black 
	call	SetTextColor
	call	ReadInt
	call	Crlf
	mov		n, eax
	mov		eax, lightGray+(black*16)				;lightGray on black
	call	SetTextColor

;input validation as integer must be [1..46]
	mov		eax, n
	cmp		eax, FIB_MIN
	jl		Invalid									;if user term less than 1, it is invalid, jump to Invalid

	cmp		eax, FIB_MAX
	jg		Invalid									;if user term is greater than 46, it is invalid, jump to Invalid

	mov		eax, green+(black*16)					;green on black 
	call	SetTextColor

;displayFibs
	mov		intCount, 0
	mov		rowCount, 1
	;first two calcualtions done manually as this is special case of adding 1 + 1
	mov		eax, 1
	call	WriteDec
	inc		intCount
	mov     al, 9									;ASCII Tab character
	call    WriteChar								;tab to align text
	call    WriteChar								;tab to align text
	call    WriteChar								;tab to align text

;set loop control
	mov		ecx, n									
	sub		ecx, 2									;loop will execute n-2 times as the first two calculations are taken care of manually 
	cmp		ecx, -1
	je		TheEnd									;if n-2 is -1, jump to the end as we have completed the first calculation

Fib2:
	mov		eax, 1
	call	WriteDec
	inc		intCount
	mov     al, 9									;ASCII Tab character
	call    WriteChar								;tab to align text
	call    WriteChar								;tab to align text
	call    WriteChar								;tab to align text

	cmp		ecx, 0
	je		TheEnd									;if n-2 = 0, jump to the end as we have completed the first two calculations

	mov		prevTerm1, 1							;previous term 1 holds the previous term
	mov		prevTerm2, 1							;previous term 2 holds the second to previous term

FibLoop:
	mov		eax, prevTerm1 
	add		eax, prevTerm2 
	call	WriteDec
	mov		edx, OFFSET sevenSpaces
	call	WriteString
	mov		lastPrinted, eax
	mov		eax, prevTerm1 
	mov		prevTerm2, eax
	mov		eax, lastPrinted
	mov		prevTerm1, eax
	inc		intCount
	mov		edx, intCount
	cdq
	div		divFive
	cmp		edx, 0
	jne		NoNewRow								;if integer result count is not divisible by 5, jump to NoNewRow
	call	Crlf									;create a new row after 5 integer results have been placed on a line
	inc		rowCount
	jmp		Again									;jump to Again since we just created a new row and don't need to indent

NoNewRow:
	mov		eax, rowCount
	cmp		eax, 9
	jge		NinthRow								;alignment for ninth row and greater don't need as much indentation, so jump to NinthRow

	mov     al, 9									;ASCII Tab character
	call    WriteChar								;tab to align text

NinthRow:
	mov     al, 9									;ASCII Tab character
	call    WriteChar								;tab to align text

Again:
	loop	FibLoop
	jmp		TheEnd

Invalid:
	mov		edx, OFFSET invalidTerm					;term is invalid, show error message then jump back to GetTerm
	mov		eax, white+(red*16)						;white on red 
	call	SetTextColor
	call	WriteString
	mov		eax, lightGray+(black*16)				;lightGray on black 
	call	SetTextColor
	call	Crlf
	jmp		GetTerm

;farewell
TheEnd:
	mov		eax, lightGray+(black*16)				;lightGray on black 
	call	SetTextColor
	call	Crlf
	call	Crlf
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	Crlf


	exit										;exit to operating system
main ENDP

END main
