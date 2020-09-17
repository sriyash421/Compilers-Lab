	.file	"ass1b_18CS30040.c"
	.text
	.section	.rodata
	.align 8
.LC0:
	.string	"\nGCD of %d, %d, %d and %d is: %d"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp # base pointer is pushed in the stack to preserve base pointer
	movq	%rsp, %rbp # stack pointer is made new base pointer
	subq	$32, %rsp # stack frame is created
	movl	$45, -20(%rbp) # value of 45  is assigned to a, which is at Mem[rbp-20]
	movl	$99, -16(%rbp) # value of 99  is assigned to b, which is at Mem[rbp-16]
	movl	$18, -12(%rbp) # value of 18  is assigned to c, which is at Mem[rbp-12]
	movl	$180, -8(%rbp) # value of 180  is assigned to d, which is at Mem[rbp-8]
	movl	-8(%rbp), %ecx  # move Mem[rbp-8] i.e d to fourth arguement of GCD4
	movl	-12(%rbp), %edx # move Mem[rbp-12] i.e c to third arguement of GCD4
	movl	-16(%rbp), %esi # move Mem[rbp-16] i.e b to second arguement of GCD4
	movl	-20(%rbp), %eax # value of Mem[rbp-20] i.e. a is copied to eax register
	movl	%eax, %edi # move eax i.e a to first arguement of GCD4
	call	GCD4 # call GCD4 function
	movl	%eax, -4(%rbp) # returned value is assigned to result i.e. Mem[rbp-4]
	movl	-4(%rbp), %edi # Copying args for the print function
	movl	-8(%rbp), %esi
	movl	-12(%rbp), %ecx
	movl	-16(%rbp), %edx
	movl	-20(%rbp), %eax
	movl	%edi, %r9d
	movl	%esi, %r8d
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi # Load effective address of LC0 to first arguement i.e. rdi register
	movl	$0, %eax # value of 0 is assigned to eax register i.e. the return value of print
	call	printf@PLT # call print function
	movl	$10, %edi # assign \n is ASCII to first arg
	call	putchar@PLT # calling putchar function
	movl	$0, %eax # value of 0 is assigned to eax register i.e. the return value of main
	leave # retrieve the original rbp
	ret # return the value in eax and end the function
	.size	main, .-main
	.globl	GCD4
	.type	GCD4, @function
GCD4:
	pushq	%rbp # base pointer is pushed in the stack to preserve base pointer
	movq	%rsp, %rbp # stack pointer is made new base pointer
	subq	$32, %rsp # stack frame is created
	movl	%edi, -20(%rbp) # first arg is copied to n1 i.e. Mem[rbp-20]
	movl	%esi, -24(%rbp) # second arg is copied to n2 i.e. Mem[rbp-24]
	movl	%edx, -28(%rbp) # third arg is copied to n3 i.e. Mem[rbp-28]
	movl	%ecx, -32(%rbp) # fourth arg is copied to n4 i.e. Mem[rbp-32]
	movl	-24(%rbp), %edx # Copying first and second args for GCD(n1,n2)
	movl	-20(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	GCD
	movl	%eax, -12(%rbp) # Copying return value of GCD(n1,n2) to t1 i.e. Mem[rbp-12]
	movl	-32(%rbp), %edx # Copying first and second args for GCD(n3,n4)
	movl	-28(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	GCD
	movl	%eax, -8(%rbp) # Copying return value of GCD(n3,n4) to t2 i.e. Mem[rbp-8]
	movl	-8(%rbp), %edx # Copying first and second args for GCD(t1,t2)
	movl	-12(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	GCD
	movl	%eax, -4(%rbp) # Copying return value of GCD(t1,t2) to t3 i.e. Mem[rbp-4]
	movl	-4(%rbp), %eax # Copying value of t3 to eax i.e return value of GCD4
	leave # retrieve the original rbp
	ret # return the value in eax and end the function
	.size	GCD4, .-GCD4
	.globl	GCD
	.type	GCD, @function
GCD:
	pushq	%rbp # base pointer is pushed in the stack to preserve base pointer
	movq	%rsp, %rbp # stack pointer is made new base pointer
	movl	%edi, -20(%rbp) # first arg is copied to num1 i.e. Mem[rbp-20]
	movl	%esi, -24(%rbp) # second arg is copied to num2 i.e. Mem[rbp-24]
	jmp	.L6
.L7: # block of while loop statements
	movl	-20(%rbp), %eax # Copying value of Mem[rbp-20] i.e. num1 to eax register
	cltd # sign extension command
	idivl	-24(%rbp)  # here edx = num1 % num2
	movl	%edx, -4(%rbp) # temp = edx
	movl	-24(%rbp), %eax # Copying value of num2 to  eax
	movl	%eax, -20(%rbp) # Copying value of eax to  num1
	movl	-4(%rbp), %eax # Copying value of temp to  eax
	movl	%eax, -24(%rbp) # Copying value of eax to  num2
.L6: # block of while loop condition
	movl	-20(%rbp), %eax # Copying value of Mem[rbp-20] i.e. num1 to eax register
	cltd # sign extension command
	idivl	-24(%rbp) # here edx = num1 % num2
	movl	%edx, %eax
	testl	%eax, %eax # check if eax is not equal to 0
	jne	.L7 # if yes the move to L7 i.e loop continues
	movl	-24(%rbp), %eax # else loop breaks and value of num2 is assigned to eax register i.e. the return value of GCD
	popq	%rbp # retrieve the original rbp
	ret # return the value in eax and go back to GCD4
	.size	GCD, .-GCD
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
