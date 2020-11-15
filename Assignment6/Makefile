TinyC: y.tab.o lex.yy.o ass6_18CS10021_18CS30040_translator.o ass6_18CS10021_18CS30040_target_translator.o
	@mkdir -p binaries
	g++ -g ass6_18CS10021_18CS30040_translator.o ass6_18CS10021_18CS30040_target_translator.o lex.yy.o y.tab.o -lfl -o binaries/TinyC
	@echo "\nMake successful. The binariesary generated is ./binaries/TinyC\n Run (make run) to generate test files for "

lex.yy.c: ass6_18CS10021_18CS30040.l
	flex ass6_18CS10021_18CS30040.l

y.tab.c: ass6_18CS10021_18CS30040.y
	yacc -dtv ass6_18CS10021_18CS30040.y -Wno-empty-rule -Wno-yacc -Wno-conflicts-rr

y.tab.h: ass6_18CS10021_18CS30040.y
	yacc -dtv ass6_18CS10021_18CS30040.y -Wno-empty-rule -Wno-yacc -Wno-conflicts-rr

ass6_18CS10021_18CS30040_target_translator.o: ass6_18CS10021_18CS30040_target_translator.cxx
	g++ -g -c -no-pie ass6_18CS10021_18CS30040_target_translator.cxx
ass6_18CS10021_18CS30040_translator.o: ass6_18CS10021_18CS30040_translator.cxx
	g++ -g -c -no-pie ass6_18CS10021_18CS30040_translator.cxx
lex.yy.o: lex.yy.c
	g++ -g -c -no-pie lex.yy.c
y.tab.o:    y.tab.c
	g++ -g -no-pie -DYYDEBUG -c y.tab.c
libass6_18CS10021_18CS30040.a: ass6_18CS10021_18CS30040.o
	ar -rcs libass6_18CS10021_18CS30040.a ass6_18CS10021_18CS30040.o

ass6_18CS10021_18CS30040.o: ass6_18CS10021_18CS30040.c myl.h
	gcc -g -no-pie -Wall -c ass6_18CS10021_18CS30040.c
clean:
	rm -rf test1 test2 test3 test4 test5 lex.yy.c y.tab.h y.output y.tab.c *.o *.s *.a *.out *.gch test-outputs/* binaries/*

test1: ass6_18CS10021_18CS30040_test1.o libass6_18CS10021_18CS30040.a
	gcc -g -no-pie ass6_18CS10021_18CS30040_test1.o -o ./binaries/test1 -L. -lass6_18CS10021_18CS30040
ass6_18CS10021_18CS30040_test1.o: test-outputs/ass6_18CS10021_18CS30040_test1.s myl.h
	gcc -g -Wall  -c  test-outputs/ass6_18CS10021_18CS30040_test1.s -no-pie -o ass6_18CS10021_18CS30040_test1.o

test2: ass6_18CS10021_18CS30040_test2.o libass6_18CS10021_18CS30040.a
	gcc -g  -no-pie ass6_18CS10021_18CS30040_test2.o -o ./binaries/test2 -L. -lass6_18CS10021_18CS30040
ass6_18CS10021_18CS30040_test2.o: test-outputs/ass6_18CS10021_18CS30040_test2.s myl.h
	gcc -g -Wall -c test-outputs/ass6_18CS10021_18CS30040_test2.s -no-pie

test3: ass6_18CS10021_18CS30040_test3.o libass6_18CS10021_18CS30040.a
	gcc -g  -no-pie ass6_18CS10021_18CS30040_test3.o -o ./binaries/test3 -L. -lass6_18CS10021_18CS30040
ass6_18CS10021_18CS30040_test3.o: test-outputs/ass6_18CS10021_18CS30040_test3.s myl.h
	gcc -g -Wall  -c test-outputs/ass6_18CS10021_18CS30040_test3.s -no-pie

test4: ass6_18CS10021_18CS30040_test4.o libass6_18CS10021_18CS30040.a
	gcc -g  -no-pie ass6_18CS10021_18CS30040_test4.o -o ./binaries/test4 -L. -lass6_18CS10021_18CS30040
ass6_18CS10021_18CS30040_test4.o: test-outputs/ass6_18CS10021_18CS30040_test4.s myl.h
	gcc -g -Wall  -c test-outputs/ass6_18CS10021_18CS30040_test4.s -no-pie

test5: ass6_18CS10021_18CS30040_test5.o libass6_18CS10021_18CS30040.a
	gcc -g  -no-pie ass6_18CS10021_18CS30040_test5.o -o ./binaries/test5 -L. -lass6_18CS10021_18CS30040
ass6_18CS10021_18CS30040_test5.o: test-outputs/ass6_18CS10021_18CS30040_test5.s myl.h
	gcc -g -Wall -c test-outputs/ass6_18CS10021_18CS30040_test5.s -no-pie
ass6_18CS10021_18CS30040.c:
	touch ass6_18CS10021_18CS30040.c

run:
	mkdir -p test-outputs

	./binaries/TinyC < test-inputs/ass6_18CS10021_18CS30040_test1.c > test-outputs/ass6_18CS10021_18CS30040_quad1.out

	mv output.s test-outputs/ass6_18CS10021_18CS30040_test1.s

	make test1

	./binaries/TinyC < test-inputs/ass6_18CS10021_18CS30040_test2.c > test-outputs/ass6_18CS10021_18CS30040_quad2.out

	mv output.s test-outputs/ass6_18CS10021_18CS30040_test2.s

	make test2

	./binaries/TinyC < test-inputs/ass6_18CS10021_18CS30040_test3.c > test-outputs/ass6_18CS10021_18CS30040_quad3.out

	mv output.s test-outputs/ass6_18CS10021_18CS30040_test3.s

	make test3

	./binaries/TinyC < test-inputs/ass6_18CS10021_18CS30040_test4.c > test-outputs/ass6_18CS10021_18CS30040_quad4.out

	mv output.s test-outputs/ass6_18CS10021_18CS30040_test4.s

	make test4

	./binaries/TinyC < test-inputs/ass6_18CS10021_18CS30040_test5.c > test-outputs/ass6_18CS10021_18CS30040_quad5.out

	mv output.s test-outputs/ass6_18CS10021_18CS30040_test5.s

	make test5

	#Below are the individual commands for compiling each test file
	@echo ""
	@echo "COMMANDS FOR THE TEST CASES"
	@echo "1 : Calculate Momentum                   : ./binaries/test1"
	@echo "2 : Convert Decimal Number to Binary     : ./binaries/test2"
	@echo "3 : Greatest Common Divisor Calculation  : ./binaries/test3"
	@echo "4 : nth Fibonacci Number                 : ./binaries/test4"
	@echo "5 : Star Pattern                         : ./binaries/test5"
	@mv *_test*.o test-outputs
