extern printf
extern fgets
extern isfloat
extern atof
extern stdin
extern scanf
global Inputs

max_position_size equ 20

section .data
align 16
	Welcome db "We will find your power",10,0
	Occupation db "Please enter your name and occupation:", 10, 0
	ResistanceandCurrent db "Please enter the resistance in your circuit first and then enter the current in this circuit:",10,0
	;Current db "Please enter the current flow in this circuit:" ,10,0
	Spewout db "Welcome %s" , 10 ,0
	error_message db "The input is invalid. Returning to main" ,10,0
	stringformat db "%s", 0
	Goodbye db "Thank you %s. Your power consumption is %lf",10,0
align 64

segment .bss
occupation resb max_position_size
array resq 2 ;we create this array to help store our inputs when going through our function loops 

segment .text

Inputs:

push rbp
mov rbp,rsp
push rbx
push rcx
push rdx
push rdi
push rsi
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
pushf

;Welcome_message
mov qword rax, 0
mov rdi, stringformat
mov rsi, Welcome
call printf

;Name_message
mov qword rax, 0
mov rdi, stringformat
mov rsi, Occupation
call printf

;input_message
mov qword rax, 0
mov rdi, occupation
mov rsi, max_position_size
mov rdx, [stdin]
call fgets

;Output_name
mov qword rax, 0
mov rdi, Spewout
mov rsi, occupation
call printf

mov r14,0x3ff0000000000000 ;used to flag input if they're wrong when putting floats into registers we need to but in its hexadecimal ieee-754 format
mov r15,0 ;used to return a value of 0 back to the c file if the input is invalid


inputnumbers:

;resistance_and_current_message
mov qword rax, 0
mov rdi, stringformat
mov rsi, ResistanceandCurrent
call printf

push qword 0

push qword 0
mov rdi, stringformat ;puts our input into to string so that way our isfloat function will recognize as such and therefore have an easier time to validate
mov rsi, rsp ;points rsi to top of the to place input value of scanf
mov rax, 1 ;set rax to 1 to let scanf know its going to be a incoming float
call scanf

;float_validation
mov rdi, rsp
mov rax, 0
call isfloat

cmp rax, 0 ;checks to see if isfloat function returned false and if so we return a value of zero and leave the asm file
je invalid_input

mov rax, 1 ;Set rax to 1 to allow function to return float to xmm0 register
call atof ;c library function

movq r12, xmm0
mov [array + 8*r15], r12

add r15, 1 ;think of like incrementing through a loop
cmp r15, 2 ;once the r15 register is equal to 2 then we mov on to multiplying and return>

pop rax ;pops the offset before scanf

pop rax


jne inputnumbers

movsd xmm15,qword[array] ;since we stored the float into the array  we move it to xmm15 for resistance

movsd xmm9, qword[array+8] ;same with xmm9 but with circuit

mulsd xmm15, xmm15

mulsd xmm15, xmm9

jmp valid_inputs


invalid_input:
pop rax
pop rax

mov rax, 0
mov rdi, stringformat
mov rsi, error_message
call printf

movq xmm15, r14  ;Sets return value to 1.0 (using r14)
movsd xmm0, xmm15
jmp End_of_function

valid_inputs:
mov qword rax, 0
movsd xmm0, xmm15
mov rdi, Goodbye
mov rsi, occupation
mov rax, 1
call printf ;this destorys our movsd xmm0,xmm15


End_of_function:
movsd xmm0, xmm15


popf
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rsi
pop rdi
pop rdx
pop rcx
pop rbx
pop rbp
ret
