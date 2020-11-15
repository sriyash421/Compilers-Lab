	.file	"output.s"

.STR0:	.string "_____________ Convert Decimal Number to Binary ______________\n"
.STR1:	.string "Input an integer: "
.STR2:	.string "The binary representation of the integer is:"
.STR3:	.string "\n_______________________________________________\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$248, %rsp
# 0:res = t000 
	movl	$0, -24(%rbp)
# 1:res = reverse_binary arg1 = t000 
	movl	-24(%rbp), %eax
	movl	%eax, -12(%rbp)
# 2:res = t001 arg1 = t000 
	movl	-24(%rbp), %eax
	movl	%eax, -28(%rbp)
# 3:res = t002 
	movl	$0, -32(%rbp)
# 4:res = binary arg1 = t002 
	movl	-32(%rbp), %eax
	movl	%eax, -8(%rbp)
# 5:res = t003 arg1 = t002 
	movl	-32(%rbp), %eax
	movl	%eax, -36(%rbp)
# 6:
	movq	$.STR0,	%rdi
# 7:res = t004 
	pushq %rbp
	call	printStr
	movl	%eax, -40(%rbp)
	addq $8 , %rsp
# 8:
	movq	$.STR1,	%rdi
# 9:res = t005 
	pushq %rbp
	call	printStr
	movl	%eax, -44(%rbp)
	addq $8 , %rsp
# 10:res = t006 
	movl	$1, -52(%rbp)
# 11:res = err arg1 = t006 
	movl	-52(%rbp), %eax
	movl	%eax, -48(%rbp)
# 12:res = t007 arg1 = err 
	leaq	-48(%rbp), %rax
	movq	%rax, -60(%rbp)
# 13:res = t007 
# 14:res = t008 
	pushq %rbp
	movq	-60(%rbp), %rdi
	call	readInt
	movl	%eax, -64(%rbp)
	addq $0 , %rsp
# 15:res = N arg1 = t008 
	movl	-64(%rbp), %eax
	movl	%eax, -4(%rbp)
# 16:res = t009 arg1 = t008 
	movl	-64(%rbp), %eax
	movl	%eax, -68(%rbp)
# 17:res = temp arg1 = N 
	movl	-4(%rbp), %eax
	movl	%eax, -16(%rbp)
# 18:res = t010 arg1 = N 
	movl	-4(%rbp), %eax
	movl	%eax, -72(%rbp)
# 19:res = t011 
	movl	$0, -76(%rbp)
# 20:res = d arg1 = t011 
	movl	-76(%rbp), %eax
	movl	%eax, -20(%rbp)
# 21:res = t012 arg1 = t011 
	movl	-76(%rbp), %eax
	movl	%eax, -80(%rbp)
# 22:res = t013 
.L6:
	movl	$0, -84(%rbp)
# 23:arg1 = temp arg2 = t013 
	movl	-16(%rbp), %eax
	movl	-84(%rbp), %edx
	cmpl	%edx, %eax
	jne .L1
# 24:
	jmp .L2
# 25:
	jmp .L2
# 26:res = t014 
.L1:
	movl	$1, -88(%rbp)
# 27:res = t015 arg1 = d arg2 = t014 
	movl	-20(%rbp), %eax
	movl	-88(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -92(%rbp)
# 28:res = d arg1 = t015 
	movl	-92(%rbp), %eax
	movl	%eax, -20(%rbp)
# 29:res = t016 arg1 = t015 
	movl	-92(%rbp), %eax
	movl	%eax, -96(%rbp)
# 30:res = t017 
	movl	$2, -100(%rbp)
# 31:res = t018 arg1 = temp arg2 = t017 
	movl	-16(%rbp), %eax
	cltd
	idivl	-100(%rbp), %eax
	movl	%edx, -104(%rbp)
# 32:res = t019 
	movl	$1, -108(%rbp)
# 33:arg1 = t018 arg2 = t019 
	movl	-104(%rbp), %eax
	movl	-108(%rbp), %edx
	cmpl	%edx, %eax
	je .L3
# 34:
	jmp .L4
# 35:
	jmp .L5
# 36:res = t020 
.L3:
	movl	$10, -112(%rbp)
# 37:res = t021 arg1 = reverse_binary arg2 = t020 
	movl	-12(%rbp), %eax
	imull	-112(%rbp), %eax
	movl	%eax, -116(%rbp)
# 38:res = t022 
	movl	$1, -120(%rbp)
# 39:res = t023 arg1 = t021 arg2 = t022 
	movl	-116(%rbp), %eax
	movl	-120(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -124(%rbp)
# 40:res = reverse_binary arg1 = t023 
	movl	-124(%rbp), %eax
	movl	%eax, -12(%rbp)
# 41:res = t024 arg1 = t023 
	movl	-124(%rbp), %eax
	movl	%eax, -128(%rbp)
# 42:
	jmp .L5
# 43:res = t025 
.L4:
	movl	$10, -132(%rbp)
# 44:res = t026 arg1 = reverse_binary arg2 = t025 
	movl	-12(%rbp), %eax
	imull	-132(%rbp), %eax
	movl	%eax, -136(%rbp)
# 45:res = reverse_binary arg1 = t026 
	movl	-136(%rbp), %eax
	movl	%eax, -12(%rbp)
# 46:res = t027 arg1 = t026 
	movl	-136(%rbp), %eax
	movl	%eax, -140(%rbp)
# 47:
	jmp .L5
# 48:res = t028 
.L5:
	movl	$2, -144(%rbp)
# 49:res = t029 arg1 = temp arg2 = t028 
	movl	-16(%rbp), %eax
	cltd
	idivl	-144(%rbp), %eax
	movl	%eax, -148(%rbp)
# 50:res = temp arg1 = t029 
	movl	-148(%rbp), %eax
	movl	%eax, -16(%rbp)
# 51:res = t030 arg1 = t029 
	movl	-148(%rbp), %eax
	movl	%eax, -152(%rbp)
# 52:
	jmp .L6
# 53:res = t031 
.L2:
	movl	$0, -156(%rbp)
# 54:arg1 = reverse_binary arg2 = t031 
	movl	-12(%rbp), %eax
	movl	-156(%rbp), %edx
	cmpl	%edx, %eax
	jne .L7
# 55:
	jmp .L8
# 56:
	jmp .L8
# 57:res = t032 
.L7:
	movl	$10, -160(%rbp)
# 58:res = t033 arg1 = binary arg2 = t032 
	movl	-8(%rbp), %eax
	imull	-160(%rbp), %eax
	movl	%eax, -164(%rbp)
# 59:res = t034 
	movl	$10, -168(%rbp)
# 60:res = t035 arg1 = reverse_binary arg2 = t034 
	movl	-12(%rbp), %eax
	cltd
	idivl	-168(%rbp), %eax
	movl	%edx, -172(%rbp)
# 61:res = t036 arg1 = t033 arg2 = t035 
	movl	-164(%rbp), %eax
	movl	-172(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -176(%rbp)
# 62:res = binary arg1 = t036 
	movl	-176(%rbp), %eax
	movl	%eax, -8(%rbp)
# 63:res = t037 arg1 = t036 
	movl	-176(%rbp), %eax
	movl	%eax, -180(%rbp)
# 64:res = t038 
	movl	$10, -184(%rbp)
# 65:res = t039 arg1 = reverse_binary arg2 = t038 
	movl	-12(%rbp), %eax
	cltd
	idivl	-184(%rbp), %eax
	movl	%eax, -188(%rbp)
# 66:res = reverse_binary arg1 = t039 
	movl	-188(%rbp), %eax
	movl	%eax, -12(%rbp)
# 67:res = t040 arg1 = t039 
	movl	-188(%rbp), %eax
	movl	%eax, -192(%rbp)
# 68:res = t041 
	movl	$1, -196(%rbp)
# 69:res = t042 arg1 = d arg2 = t041 
	movl	-20(%rbp), %eax
	movl	-196(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -200(%rbp)
# 70:res = d arg1 = t042 
	movl	-200(%rbp), %eax
	movl	%eax, -20(%rbp)
# 71:res = t043 arg1 = t042 
	movl	-200(%rbp), %eax
	movl	%eax, -204(%rbp)
# 72:
	jmp .L2
# 73:res = t044 
.L8:
	movl	$0, -208(%rbp)
# 74:arg1 = d arg2 = t044 
	movl	-20(%rbp), %eax
	movl	-208(%rbp), %edx
	cmpl	%edx, %eax
	jne .L9
# 75:
	jmp .L10
# 76:
	jmp .L10
# 77:res = t045 
.L9:
	movl	$1, -212(%rbp)
# 78:res = t046 arg1 = d arg2 = t045 
	movl	-20(%rbp), %eax
	movl	-212(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -216(%rbp)
# 79:res = d arg1 = t046 
	movl	-216(%rbp), %eax
	movl	%eax, -20(%rbp)
# 80:res = t047 arg1 = t046 
	movl	-216(%rbp), %eax
	movl	%eax, -220(%rbp)
# 81:res = t048 
	movl	$10, -224(%rbp)
# 82:res = t049 arg1 = binary arg2 = t048 
	movl	-8(%rbp), %eax
	imull	-224(%rbp), %eax
	movl	%eax, -228(%rbp)
# 83:res = binary arg1 = t049 
	movl	-228(%rbp), %eax
	movl	%eax, -8(%rbp)
# 84:res = t050 arg1 = t049 
	movl	-228(%rbp), %eax
	movl	%eax, -232(%rbp)
# 85:
	jmp .L8
# 86:
.L10:
	movq	$.STR2,	%rdi
# 87:res = t051 
	pushq %rbp
	call	printStr
	movl	%eax, -236(%rbp)
	addq $8 , %rsp
# 88:res = binary 
# 89:res = t052 
	pushq %rbp
	movl	-8(%rbp) , %edi
	call	printInt
	movl	%eax, -240(%rbp)
	addq $0 , %rsp
# 90:
	movq	$.STR3,	%rdi
# 91:res = t053 
	pushq %rbp
	call	printStr
	movl	%eax, -244(%rbp)
	addq $8 , %rsp
# 92:res = t054 
	movl	$0, -248(%rbp)
# 93:res = t054 
	movl	-248(%rbp), %eax
	jmp	.LRT0
.LRT0:
	addq	$-248, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	main, .-main
