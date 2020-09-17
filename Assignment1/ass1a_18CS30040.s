	.file	"ass1a_18CS30040.c"
	.text
	.section	.rodata
.LC0:
	.string	"\nThe greater number is: %d"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp # base pointer is pushed in the stack to preserve base pointer
	movq	%rsp, %rbp # stack pointer is made new base pointer
	subq	$16, %rsp # stack frame is created
	movl	$45, -8(%rbp) # value of 45 is assigned to num1, which is at Mem[rbp-8]
	movl	$68, -4(%rbp) # value of 45 is assigned to num2, which is at Mem[rbp-4]
	movl	-8(%rbp), %eax # value of Mem[rbp-8] i.e. num1 is copied to eax register
	cmpl	-4(%rbp), %eax # compared eax i.e. num1 and Mem[rbp-4] i.e. num2
	jle	.L2 # if less than equal to then move to L2
	movl	-8(%rbp), %eax # else copy num1 to eax
	movl	%eax, -12(%rbp) # copy value of eax to greater i.e Mem[rbp-12]
	jmp	.L3
.L2:
	movl	-4(%rbp), %eax # else copy num2 to eax
	movl	%eax, -12(%rbp) # copy value of eax to greater i.e Mem[rbp-12]
.L3:
	movl	-12(%rbp), %eax # greater stored in eax register
	movl	%eax, %esi # move eax to second arguement i.e. esi register
	leaq	.LC0(%rip), %rdi # Load effective address of LC0 to first arguement i.e. rdi register
	movl	$0, %eax # value of 0 is assigned to eax register i.e. the return value of print
	call	printf@PLT # call print function 
	movl	$0, %eax # value of 0 is assigned to eax register i.e. the return value of main
	leave # retrieve the original rbp
	ret # return the value in eax and end the function
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
