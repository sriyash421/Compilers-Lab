##########################
##  Makefile to compile ##
##  the library         ##
##########################

a.out: main.o libass2_18CS30040.a
		c++ main.o -L. -lass2_18CS30040

main.o: main.c toylib.h
		c++ -Wall -c main.c

libass2_18CS30040.a: ass2_18CS30040.o
		ar -rcs libass2_18CS30040.a ass2_18CS30040.o

ass2_18CS30040.o: ass2_18CS30040.cpp toylib.h
		c++ -Wall -c ass2_18CS30040.cpp

clean:
	rm a.out main.o libass2_18CS30040.a ass2_18CS30040.o