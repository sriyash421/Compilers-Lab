/*
Name: Sriyash Poddar
Roll: 18CS30040
*/

#include "toylib.h"

int printStringUpper(char *str){
    /*  prints a string of characters terminated by '\0'.
        The return value id no of characters printed    */
    int size = 0;

    while(str[size]!='\0'){
        /*Getting string length*/
        if((int)'a'<=str[size] && str[size]<='z')
            str[size] -= (int)('a'-'A');
        size++;
    }

    /* inline assembly line commands for system call to print "str" to STDOUT*/
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(str), "d"(size)
    );

    return size;
}

int readHexInteger(int *n){
    /*Reads a hexadecimal integer and loads its decimal value in the pointer
      The return value is the correctness of format.*/
    char arr[100]={'0'};
    int byte_count = 20;
    int is_neg = 0;
    int count = 0;
    int val = 0;

    /* inline assembly line commands for system call to read STDIN into arr*/
    __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(arr), "d"(byte_count)
    );

    /* handles negative no.s */
    if(arr[count]=='-'){
        is_neg = 1;
        count++;
    }

    while(arr[count]!=' ' && arr[count]!='\t' && arr[count]!='\n'){
        /* Convert from base-16 to decimal*/
        val*=16;
        if((int)'0'<=arr[count] && arr[count]<=(int)'9')
            val+= (int)(arr[count]-'0');
        else if ((int)'A'<=arr[count] && arr[count]<=(int)'F')
            val+= 10+(int)(arr[count]-'A');
        else
            return BAD;
        count++;
    }
    
    if(is_neg) val*=(-1);
    
    *n = val;
    
    return GOOD;
}

int printHexInteger(int n){
    /*Prints an integer in hexadecimal format.
      The return value id no of characters printed*/
    char arr[100]={'0'};
    int count = 0;
    int is_neg=0;
    
    if(!n) arr[count++]='0';
    else{
        if(n<0){
            is_neg=1;
            n*=(-1);
        }

        while(n){
            /*Converting binary to base-16*/
            int temp = n%16;
            if(temp<=9)
                arr[count++]= temp+'0';
            else
                arr[count++]= temp-10+'A';
            n/=16;
        }

        /* handles negative no.s */
        if(is_neg) arr[count++]='-';
        
        /*adjusting the alignment of the representation*/
        for(int i=0;i < count/2; i++){
            char swap = arr[count-i-1];
            arr[count-i-1] = arr[i];
            arr[i] = swap;
        }
    }

    /* inline assembly line commands for system call to print "arr" to STDOUT*/
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(arr), "d"(count)
    );

    return count;
}

int readFloat(float *f){
    /*  Reads a float value and  loads it in the pointer.
        The return value is the correctness of format.    */
    char arr[100]={'0'};
    int byte_count = 20;
    int is_neg = 0;
    int count = 0;
    int dot = 0;
    float val = 0;
    float div = 1.0;

    /* inline assembly line commands for system call to read STDIN into arr*/
    __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(arr), "d"(byte_count)
    );

    /* handles negative no.s */
    if(arr[count]=='-'){
        is_neg = 1;
        count++;
    }

    while(arr[count]!=' ' && arr[count]!='\t' && arr[count]!='\n'){

        if ((((int)arr[count]-'0' > 9) || ((int)arr[count]-'0' < 0)) && (arr[count]!='.'))
            return BAD;
        
        if(arr[count]=='.' && dot)
            return BAD;
        
        if(arr[count]=='.'){
            dot = 1;
        }
        else if(dot){
            /*handles values after the decimal*/
            div*=10;
            val+=(float)(arr[count]-'0')/div;
        }
        else{
            val*=10.0;
            val+=(float)(arr[count]-'0');
        }

        count++;
    }

    /* handles negative no.s */
    if(is_neg) val*=(-1);

    *f = val;

    return GOOD;
}

int printFloat(float f){
    /*  Prints a float value.
        The return value is no of characters printed    */
    char arr[100]={'0'};
    int count = 0;
    int is_neg = 0;
    if(f<0){
        f*=(-1);
        is_neg = 1;
    }
    int a = (int)f;
    float dec = f - a;

    if(f==0){
        arr[count++]='0';
        arr[count++]='.';
        arr[count++]='0';
    }
    else{
        while((dec-(int)dec)!=0){ dec*=10;}
        int temp_dec = (int)dec;

        /*hadnling after the decimal places*/
        if(!temp_dec){
            arr[count++]='0';
        }
        else{
            while(temp_dec){
                arr[count++]= (temp_dec%10)+'0';
                temp_dec/=10;
            }    
        }
        arr[count++]='.';

        if(!a){
            arr[count++]='0';
        }
        else{
            while(a){
                arr[count++]= (a%10)+'0';
                a/=10;
            }
        }
        
        /* handles negative no.s */
        if(is_neg) arr[count++]='-';

        /*adjusting the alignment of the representation*/
        for(int i=0;i < count/2; i++){
            char swap = arr[count-i-1];
            arr[count-i-1] = arr[i];
            arr[i] = swap;
        }
    }

    /* inline assembly line commands for system call to print "arr" to STDOUT*/
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(arr), "d"(count)
    );

    return count;
}
