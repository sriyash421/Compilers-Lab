a.out: main.o lass2_18CS30040.a
		cc main.o -L. lass2_18CS30040.a

main.o: main.c toylib.h
		cc -Wall -c main.c

lass2_18CS30040.a: ass2_18CS30040.o
		ar -rcs lass2_18CS30040.a ass2_18CS30040.cpp

ass2_18CS30040.o: ass2_18CS30040.cpp
		cc -Wall -c ass2_18CS30040.cpp

clean:
	rm a.out main.o lass2_18CS30040.a ass2_18CS30040.o