	.file	"output.s"

.STR0:	.string "_____________ Calculating Momentum _____________\n"
.STR1:	.string "Input mass:"
.STR2:	.string "Input velocity:"
.STR3:	.string "The value of momentum is "
.STR4:	.string "\n__________________________\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$88, %rsp
# 0:
	movq	$.STR0,	%rdi
# 1:res = t000 
	pushq %rbp
	call	printStr
	movl	%eax, -16(%rbp)
	addq $8 , %rsp
# 2:res = t001 
	movl	$1, -24(%rbp)
# 3:res = err arg1 = t001 
	movl	-24(%rbp), %eax
	movl	%eax, -20(%rbp)
# 4:
	movq	$.STR1,	%rdi
# 5:res = t002 
	pushq %rbp
	call	printStr
	movl	%eax, -28(%rbp)
	addq $8 , %rsp
# 6:res = t003 arg1 = err 
	leaq	-20(%rbp), %rax
	movq	%rax, -36(%rbp)
# 7:res = t003 
# 8:res = t004 
	pushq %rbp
	movq	-36(%rbp), %rdi
	call	readInt
	movl	%eax, -40(%rbp)
	addq $0 , %rsp
# 9:res = mass arg1 = t004 
	movl	-40(%rbp), %eax
	movl	%eax, -4(%rbp)
# 10:res = t005 arg1 = t004 
	movl	-40(%rbp), %eax
	movl	%eax, -44(%rbp)
# 11:
	movq	$.STR2,	%rdi
# 12:res = t006 
	pushq %rbp
	call	printStr
	movl	%eax, -48(%rbp)
	addq $8 , %rsp
# 13:res = t007 arg1 = err 
	leaq	-20(%rbp), %rax
	movq	%rax, -56(%rbp)
# 14:res = t007 
# 15:res = t008 
	pushq %rbp
	movq	-56(%rbp), %rdi
	call	readInt
	movl	%eax, -60(%rbp)
	addq $0 , %rsp
# 16:res = velocity arg1 = t008 
	movl	-60(%rbp), %eax
	movl	%eax, -8(%rbp)
# 17:res = t009 arg1 = t008 
	movl	-60(%rbp), %eax
	movl	%eax, -64(%rbp)
# 18:res = t010 arg1 = mass arg2 = velocity 
	movl	-4(%rbp), %eax
	imull	-8(%rbp), %eax
	movl	%eax, -68(%rbp)
# 19:res = momentum arg1 = t010 
	movl	-68(%rbp), %eax
	movl	%eax, -12(%rbp)
# 20:res = t011 arg1 = t010 
	movl	-68(%rbp), %eax
	movl	%eax, -72(%rbp)
# 21:
	movq	$.STR3,	%rdi
# 22:res = t012 
	pushq %rbp
	call	printStr
	movl	%eax, -76(%rbp)
	addq $8 , %rsp
# 23:res = momentum 
# 24:res = t013 
	pushq %rbp
	movl	-12(%rbp) , %edi
	call	printInt
	movl	%eax, -80(%rbp)
	addq $0 , %rsp
# 25:
	movq	$.STR4,	%rdi
# 26:res = t014 
	pushq %rbp
	call	printStr
	movl	%eax, -84(%rbp)
	addq $8 , %rsp
# 27:res = t015 
	movl	$0, -88(%rbp)
# 28:res = t015 
	movl	-88(%rbp), %eax
	jmp	.LRT0
.LRT0:
	addq	$-88, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	main, .-main
