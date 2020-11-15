	.file	"output.s"

.STR0:	.string "_____________ Pattern _____________\n"
.STR1:	.string "Num of lines:\n"
.STR2:	.string "*"
.STR3:	.string "\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
# 0:res = t000 
	movl	$1, -12(%rbp)
# 1:res = err arg1 = t000 
	movl	-12(%rbp), %eax
	movl	%eax, -8(%rbp)
# 2:
	movq	$.STR0,	%rdi
# 3:res = t001 
	pushq %rbp
	call	printStr
	movl	%eax, -16(%rbp)
	addq $8 , %rsp
# 4:
	movq	$.STR1,	%rdi
# 5:res = t002 
	pushq %rbp
	call	printStr
	movl	%eax, -20(%rbp)
	addq $8 , %rsp
# 6:res = t003 arg1 = err 
	leaq	-8(%rbp), %rax
	movq	%rax, -28(%rbp)
# 7:res = t003 
# 8:res = t004 
	pushq %rbp
	movq	-28(%rbp), %rdi
	call	readInt
	movl	%eax, -32(%rbp)
	addq $0 , %rsp
# 9:res = n arg1 = t004 
	movl	-32(%rbp), %eax
	movl	%eax, -4(%rbp)
# 10:res = t005 arg1 = t004 
	movl	-32(%rbp), %eax
	movl	%eax, -36(%rbp)
# 11:res = t006 
	movl	$0, -44(%rbp)
# 12:res = i arg1 = t006 
	movl	-44(%rbp), %eax
	movl	%eax, -40(%rbp)
# 13:res = t007 
	movl	$0, -52(%rbp)
# 14:res = j arg1 = t007 
	movl	-52(%rbp), %eax
	movl	%eax, -48(%rbp)
# 15:res = t008 
	movl	$1, -56(%rbp)
# 16:res = i arg1 = t008 
	movl	-56(%rbp), %eax
	movl	%eax, -40(%rbp)
# 17:res = t009 arg1 = t008 
	movl	-56(%rbp), %eax
	movl	%eax, -60(%rbp)
# 18:arg1 = i arg2 = n 
.L3:
	movl	-40(%rbp), %eax
	movl	-4(%rbp), %edx
	cmpl	%edx, %eax
	jle .L1
# 19:
	jmp	.LRT0
# 20:
	jmp	.LRT0
# 21:res = t010 arg1 = i 
.L8:
	movl	-40(%rbp), %eax
	movl	%eax, -64(%rbp)
# 22:res = i arg1 = i 
	movl	-40(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -40(%rbp)
# 23:
	jmp .L3
# 24:res = j arg1 = i 
.L1:
	movl	-40(%rbp), %eax
	movl	%eax, -48(%rbp)
# 25:res = t011 arg1 = i 
	movl	-40(%rbp), %eax
	movl	%eax, -68(%rbp)
# 26:arg1 = j arg2 = n 
.L6:
	movl	-48(%rbp), %eax
	movl	-4(%rbp), %edx
	cmpl	%edx, %eax
	jle .L4
# 27:
	jmp .L5
# 28:
	jmp .L5
# 29:res = t012 arg1 = j 
.L7:
	movl	-48(%rbp), %eax
	movl	%eax, -72(%rbp)
# 30:res = j arg1 = j 
	movl	-48(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -48(%rbp)
# 31:
	jmp .L6
# 32:
.L4:
	movq	$.STR2,	%rdi
# 33:res = t013 
	pushq %rbp
	call	printStr
	movl	%eax, -76(%rbp)
	addq $8 , %rsp
# 34:
	jmp .L7
# 35:
.L5:
	movq	$.STR3,	%rdi
# 36:res = t014 
	pushq %rbp
	call	printStr
	movl	%eax, -80(%rbp)
	addq $8 , %rsp
# 37:
	jmp .L8
.LRT0:
	addq	$-80, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	main, .-main
