/*
Name: Sriyash Poddar
Roll: 18CS30040
*/

#include "toylib.h"

/*
main program to test the functions created
*/

int main()
{
    int n, response;
    
    char msg1[] = "\nWARNING: Using inhouse print statement, things may break!\n";
    printStringUpper(msg1);

    char msg2[] = "\nPlease enter a hexadecimal integer:\n";
    printStringUpper(msg2);
    response = readHexInteger(&n); 			   
    
    if(response == GOOD){
        printHexInteger(n);
    }
    else{
        char msg3[] = "\nInvalid input for hexadecimal integer!\n";
        printStringUpper(msg3);
    }

    float p;
    char msg4[] = "\nPlease enter a float value:\n";
    printStringUpper(msg4);
    response = readFloat(&p);
    
    if(response == GOOD){
        printFloat(p);
    }
    else{
        char msg5[] = "\nInvalid input for float!\n";
        printStringUpper(msg5);
    }

    return 0;
}