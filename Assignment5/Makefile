all: a.out
	
	./a.out < ass5_18CS10021_18CS30040_test1.c > ass5_18CS10021_18CS30040_quads1.out
	./a.out < ass5_18CS10021_18CS30040_test2.c > ass5_18CS10021_18CS30040_quads2.out
	./a.out < ass5_18CS10021_18CS30040_test3.c > ass5_18CS10021_18CS30040_quads3.out
	./a.out < ass5_18CS10021_18CS30040_test4.c > ass5_18CS10021_18CS30040_quads4.out
	./a.out < ass5_18CS10021_18CS30040_test5.c > ass5_18CS10021_18CS30040_quads5.out
	./a.out < ass5_18CS10021_18CS30040_test6.c > ass5_18CS10021_18CS30040_quads6.out
	@echo "\n DONE !!\n"

a.out: lex.yy.o y.tab.o ass5_18CS10021_18CS30040_translator.o
	g++ lex.yy.o y.tab.o ass5_18CS10021_18CS30040_translator.o -lfl

ass5_18CS10021_18CS30040_translator.o: ass5_18CS10021_18CS30040_translator.cxx ass5_18CS10021_18CS30040_translator.h
	g++ -c ass5_18CS10021_18CS30040_translator.h
	g++ -c ass5_18CS10021_18CS30040_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

y.tab.o: y.tab.c
	g++ -c y.tab.c

lex.yy.c: ass5_18CS10021_18CS30040.l y.tab.h ass5_18CS10021_18CS30040_translator.h
	flex ass5_18CS10021_18CS30040.l

y.tab.c: ass5_18CS10021_18CS30040.y
	yacc -dtv ass5_18CS10021_18CS30040.y -W

y.tab.h: ass5_18CS10021_18CS30040.y
	yacc -dtv ass5_18CS10021_18CS30040.y -W

clean:
	rm lex.yy.c y.tab.c y.tab.h lex.yy.o y.tab.o ass5_18CS10021_18CS30040_translator.o y.output a.out ass5_18CS10021_18CS30040_translator.h.gch