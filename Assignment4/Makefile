y.tab.c: ass4_18CS30040.y
	yacc -dtv ass4_18CS30040.y -W

y.tab.h: ass4_18CS30040.y
	yacc -dtv ass4_18CS30040.y -W

y.tab.o: y.tab.c
	gcc-c y.tab.c

lex.yy.c: ass4_18CS30040.l y.tab.h
	flex ass4_18CS30040.l

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

ass4_18CS30040.o: ass4_18CS30040.c
	gcc -c ass4_18CS30040.c

a.out: lex.yy.o y.tab.o ass4_18CS30040.o
	gcc lex.yy.o y.tab.o ass4_18CS30040.o -lfl

clean: 
	rm y.tab.c y.tab.h y.tab.o lex.yy.c lex.yy.o ass4_18CS30040.o a.out y.output

test:
	./a.out < ass4_18CS30040_test.c