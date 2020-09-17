/*
Name: Sriyash Poddar
Roll: 18CS30040
*/

#include "toylib.h"

int main()
{
    int n, response;
    printStringUpper("\nWARNING: Using inhouse print statement, things may break!\n");
    printStringUpper("\nPlease enter a hexadecimal integer:\n");
    response = readHexInteger(&n); 			   
    
    if(response == GOOD){
        printHexInteger(n);
    }
    else{
        printStringUpper("\nInvalid input for hexadecimal integer!\n");
    }

    float p;
    printStringUpper("\nPlease enter a float value:\n");
    response = readFloat(&p);
    
    if(response == GOOD){
        printFloat(p);
    }
    else{
        printStringUpper("\nInvalid input for float!\n");
    }

    return 0;
}