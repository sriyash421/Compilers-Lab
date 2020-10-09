a.out: lex.yy.o y.tab.o ass4_18CS30040.o
	gcc lex.yy.o y.tab.o ass4_18CS30040.o -lfl

ass4_18CS30040.o: ass4_18CS30040.c
	gcc -c ass4_18CS30040.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

y.tab.o: y.tab.c
	gcc -c y.tab.c

lex.yy.c: ass4_18CS30040.l y.tab.h
	flex ass4_18CS30040.l

y.tab.c: ass4_18CS30040.y
	yacc -dtv ass4_18CS30040.y -Wnone

y.tab.h: ass4_18CS30040.y
	yacc -dtv ass4_18CS30040.y -Wnone

ass4_18CS30040.c:
	touch ass4_18CS30040.c

clean:
	rm lex.yy.c y.tab.c y.tab.h lex.yy.o y.tab.o ass4_18CS30040.o y.output a.out

test: 
	./a.out < ass4_18CS30040_test.c