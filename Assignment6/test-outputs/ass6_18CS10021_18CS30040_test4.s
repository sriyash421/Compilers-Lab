	.file	"output.s"

.STR0:	.string "_____________ nth Fibonacci Number _____________\n"
.STR1:	.string "Input number n:\n"
.STR2:	.string "nth Fibonacci number is: "
.STR3:	.string "\n_________________________\n"
	.text
	.globl	fib
	.type	fib, @function
fib:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$556, %rsp
	movl	%edi, -4(%rbp)
# 0:res = t000 
	movl	$100, -408(%rbp)
# 1:res = t001 
	movl	$0, -416(%rbp)
# 2:res = t002 
	movl	$0, -420(%rbp)
# 3:res = t004 arg1 = t002 
	movl	-420(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -428(%rbp)
# 4:res = t003 arg1 = t001 arg2 = t004 
	movl	-416(%rbp), %eax
	movl	-428(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -424(%rbp)
# 5:res = t005 
	movl	$0, -432(%rbp)
# 6:res = f arg1 = t003 arg2 = t005 
	leaq	-404(%rbp), %rdx
	movslq	-424(%rbp), %rax
	addq	%rax, %rdx
	movl	-432(%rbp), %eax
	movl	%eax, (%rdx)
# 7:res = t006 arg1 = t005 
	movl	-432(%rbp), %eax
	movl	%eax, -436(%rbp)
# 8:res = t007 
	movl	$0, -440(%rbp)
# 9:res = t008 
	movl	$1, -444(%rbp)
# 10:res = t010 arg1 = t008 
	movl	-444(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -452(%rbp)
# 11:res = t009 arg1 = t007 arg2 = t010 
	movl	-440(%rbp), %eax
	movl	-452(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -448(%rbp)
# 12:res = t011 
	movl	$1, -456(%rbp)
# 13:res = f arg1 = t009 arg2 = t011 
	leaq	-404(%rbp), %rdx
	movslq	-448(%rbp), %rax
	addq	%rax, %rdx
	movl	-456(%rbp), %eax
	movl	%eax, (%rdx)
# 14:res = t012 arg1 = t011 
	movl	-456(%rbp), %eax
	movl	%eax, -460(%rbp)
# 15:res = t013 
	movl	$2, -464(%rbp)
# 16:res = i arg1 = t013 
	movl	-464(%rbp), %eax
	movl	%eax, -412(%rbp)
# 17:res = t014 arg1 = t013 
	movl	-464(%rbp), %eax
	movl	%eax, -468(%rbp)
# 18:arg1 = i arg2 = n 
.L3:
	movl	-412(%rbp), %eax
	movl	-4(%rbp), %edx
	cmpl	%edx, %eax
	jle .L1
# 19:
	jmp .L2
# 20:
	jmp .L2
# 21:res = t015 arg1 = i 
.L4:
	movl	-412(%rbp), %eax
	movl	%eax, -472(%rbp)
# 22:res = i arg1 = i 
	movl	-412(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -412(%rbp)
# 23:
	jmp .L3
# 24:res = t016 
.L1:
	movl	$0, -476(%rbp)
# 25:res = t018 arg1 = i 
	movl	-412(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -484(%rbp)
# 26:res = t017 arg1 = t016 arg2 = t018 
	movl	-476(%rbp), %eax
	movl	-484(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -480(%rbp)
# 27:res = t019 
	movl	$0, -488(%rbp)
# 28:res = t020 
	movl	$1, -492(%rbp)
# 29:res = t021 arg1 = i arg2 = t020 
	movl	-412(%rbp), %eax
	movl	-492(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -496(%rbp)
# 30:res = t023 arg1 = t021 
	movl	-496(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -504(%rbp)
# 31:res = t022 arg1 = t019 arg2 = t023 
	movl	-488(%rbp), %eax
	movl	-504(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -500(%rbp)
# 32:res = t024 arg1 = f arg2 = t022 
	leaq	-404(%rbp), %rdx
	movslq	-500(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -508(%rbp)
# 33:res = t025 
	movl	$0, -512(%rbp)
# 34:res = t026 
	movl	$2, -516(%rbp)
# 35:res = t027 arg1 = i arg2 = t026 
	movl	-412(%rbp), %eax
	movl	-516(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -520(%rbp)
# 36:res = t029 arg1 = t027 
	movl	-520(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -528(%rbp)
# 37:res = t028 arg1 = t025 arg2 = t029 
	movl	-512(%rbp), %eax
	movl	-528(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -524(%rbp)
# 38:res = t030 arg1 = f arg2 = t028 
	leaq	-404(%rbp), %rdx
	movslq	-524(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -532(%rbp)
# 39:res = t031 arg1 = t024 arg2 = t030 
	movl	-508(%rbp), %eax
	movl	-532(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -536(%rbp)
# 40:res = f arg1 = t017 arg2 = t031 
	leaq	-404(%rbp), %rdx
	movslq	-480(%rbp), %rax
	addq	%rax, %rdx
	movl	-536(%rbp), %eax
	movl	%eax, (%rdx)
# 41:res = t032 arg1 = t031 
	movl	-536(%rbp), %eax
	movl	%eax, -540(%rbp)
# 42:
	jmp .L4
# 43:res = t033 
.L2:
	movl	$0, -544(%rbp)
# 44:res = t035 arg1 = n 
	movl	-4(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -552(%rbp)
# 45:res = t034 arg1 = t033 arg2 = t035 
	movl	-544(%rbp), %eax
	movl	-552(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -548(%rbp)
# 46:res = t036 arg1 = f arg2 = t034 
	leaq	-404(%rbp), %rdx
	movslq	-548(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -556(%rbp)
# 47:res = t036 
	movl	-556(%rbp), %eax
	jmp	.LRT0
.LRT0:
	addq	$-556, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	fib, .-fib
	.globl	main
	.type	main, @function
main:
.LFB1:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
# 48:res = t037 
	movl	$1, -16(%rbp)
# 49:res = err arg1 = t037 
	movl	-16(%rbp), %eax
	movl	%eax, -12(%rbp)
# 50:
	movq	$.STR0,	%rdi
# 51:res = t038 
	pushq %rbp
	call	printStr
	movl	%eax, -20(%rbp)
	addq $8 , %rsp
# 52:
	movq	$.STR1,	%rdi
# 53:res = t039 
	pushq %rbp
	call	printStr
	movl	%eax, -24(%rbp)
	addq $8 , %rsp
# 54:res = t040 arg1 = err 
	leaq	-12(%rbp), %rax
	movq	%rax, -32(%rbp)
# 55:res = t040 
# 56:res = t041 
	pushq %rbp
	movq	-32(%rbp), %rdi
	call	readInt
	movl	%eax, -36(%rbp)
	addq $0 , %rsp
# 57:res = n arg1 = t041 
	movl	-36(%rbp), %eax
	movl	%eax, -4(%rbp)
# 58:res = t042 arg1 = t041 
	movl	-36(%rbp), %eax
	movl	%eax, -40(%rbp)
# 59:res = n 
# 60:res = t043 
	pushq %rbp
	movl	-4(%rbp) , %edi
	call	fib
	movl	%eax, -44(%rbp)
	addq $0 , %rsp
# 61:res = fib_num arg1 = t043 
	movl	-44(%rbp), %eax
	movl	%eax, -8(%rbp)
# 62:res = t044 arg1 = t043 
	movl	-44(%rbp), %eax
	movl	%eax, -48(%rbp)
# 63:
	movq	$.STR2,	%rdi
# 64:res = t045 
	pushq %rbp
	call	printStr
	movl	%eax, -52(%rbp)
	addq $8 , %rsp
# 65:res = fib_num 
# 66:res = t046 
	pushq %rbp
	movl	-8(%rbp) , %edi
	call	printInt
	movl	%eax, -56(%rbp)
	addq $0 , %rsp
# 67:
	movq	$.STR3,	%rdi
# 68:res = t047 
	pushq %rbp
	call	printStr
	movl	%eax, -60(%rbp)
	addq $8 , %rsp
# 69:res = t048 
	movl	$0, -64(%rbp)
# 70:res = t048 
	movl	-64(%rbp), %eax
	jmp	.LRT1
.LRT1:
	addq	$-64, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE1:
	.size	main, .-main
