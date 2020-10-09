lex.yy.c : ass3_18CS30040.l header.h
			flex ass3_18CS30040.l > lex.yy.c

a.out : lex.yy.c ass3_18CS30040.c ass3_18CS30040_test.c
			gcc ass3_18CS30040.c lex.yy.c -lfl

clean :
		rm -rf a.out lex.yy.c

run : a.out
		./a.out