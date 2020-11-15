	.file	"output.s"

.STR0:	.string "_______ GCD Calculation _________\n"
.STR1:	.string "Input Integer a\n"
.STR2:	.string "Input Integer b\n"
.STR3:	.string "Greatest Common Divisor: "
.STR4:	.string "\n_____________\n"
	.text
	.globl	euclidGCD
	.type	euclidGCD, @function
euclidGCD:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$20, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
# 0:res = t000 
	movl	$0, -12(%rbp)
# 1:arg1 = a arg2 = t000 
	movl	-8(%rbp), %eax
	movl	-12(%rbp), %edx
	cmpl	%edx, %eax
	je .L1
# 2:
	jmp .L2
# 3:
	jmp	.LRT0
# 4:res = b 
.L1:
	movl	-4(%rbp), %eax
	jmp	.LRT0
# 5:
	jmp	.LRT0
# 6:res = t001 arg1 = b arg2 = a 
.L2:
	movl	-4(%rbp), %eax
	cltd
	idivl	-8(%rbp), %eax
	movl	%edx, -16(%rbp)
# 7:res = t001 
# 8:res = a 
# 9:res = t002 
	pushq %rbp
	movl	-8(%rbp) , %edi
	movl	-16(%rbp) , %esi
	call	euclidGCD
	movl	%eax, -20(%rbp)
	addq $0 , %rsp
# 10:res = t002 
	movl	-20(%rbp), %eax
	jmp	.LRT0
# 11:
	jmp	.LRT0
.LRT0:
	addq	$-20, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	euclidGCD, .-euclidGCD
	.globl	main
	.type	main, @function
main:
.LFB1:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$88, %rsp
# 12:
.L3:
	movq	$.STR0,	%rdi
# 13:res = t003 
	pushq %rbp
	call	printStr
	movl	%eax, -16(%rbp)
	addq $8 , %rsp
# 14:
	movq	$.STR1,	%rdi
# 15:res = t004 
	pushq %rbp
	call	printStr
	movl	%eax, -20(%rbp)
	addq $8 , %rsp
# 16:res = t005 
	movl	$1, -28(%rbp)
# 17:res = err arg1 = t005 
	movl	-28(%rbp), %eax
	movl	%eax, -24(%rbp)
# 18:res = t006 arg1 = err 
	leaq	-24(%rbp), %rax
	movq	%rax, -36(%rbp)
# 19:res = t006 
# 20:res = t007 
	pushq %rbp
	movq	-36(%rbp), %rdi
	call	readInt
	movl	%eax, -40(%rbp)
	addq $0 , %rsp
# 21:res = a arg1 = t007 
	movl	-40(%rbp), %eax
	movl	%eax, -4(%rbp)
# 22:res = t008 arg1 = t007 
	movl	-40(%rbp), %eax
	movl	%eax, -44(%rbp)
# 23:
	movq	$.STR2,	%rdi
# 24:res = t009 
	pushq %rbp
	call	printStr
	movl	%eax, -48(%rbp)
	addq $8 , %rsp
# 25:res = t010 arg1 = err 
	leaq	-24(%rbp), %rax
	movq	%rax, -56(%rbp)
# 26:res = t010 
# 27:res = t011 
	pushq %rbp
	movq	-56(%rbp), %rdi
	call	readInt
	movl	%eax, -60(%rbp)
	addq $0 , %rsp
# 28:res = b arg1 = t011 
	movl	-60(%rbp), %eax
	movl	%eax, -8(%rbp)
# 29:res = t012 arg1 = t011 
	movl	-60(%rbp), %eax
	movl	%eax, -64(%rbp)
# 30:res = a 
# 31:res = b 
# 32:res = t013 
	pushq %rbp
	movl	-8(%rbp) , %edi
	movl	-4(%rbp) , %esi
	call	euclidGCD
	movl	%eax, -68(%rbp)
	addq $0 , %rsp
# 33:res = gcd arg1 = t013 
	movl	-68(%rbp), %eax
	movl	%eax, -12(%rbp)
# 34:res = t014 arg1 = t013 
	movl	-68(%rbp), %eax
	movl	%eax, -72(%rbp)
# 35:
	movq	$.STR3,	%rdi
# 36:res = t015 
	pushq %rbp
	call	printStr
	movl	%eax, -76(%rbp)
	addq $8 , %rsp
# 37:res = gcd 
# 38:res = t016 
	pushq %rbp
	movl	-12(%rbp) , %edi
	call	printInt
	movl	%eax, -80(%rbp)
	addq $0 , %rsp
# 39:
	movq	$.STR4,	%rdi
# 40:res = t017 
	pushq %rbp
	call	printStr
	movl	%eax, -84(%rbp)
	addq $8 , %rsp
# 41:res = t018 
	movl	$0, -88(%rbp)
# 42:res = t018 
	movl	-88(%rbp), %eax
	jmp	.LRT1
.LRT1:
	addq	$-88, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE1:
	.size	main, .-main
