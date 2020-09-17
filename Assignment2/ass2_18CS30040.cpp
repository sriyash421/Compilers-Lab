/*
Name: Sriyash Poddar
Roll: 18CS30040
*/

#include "toylib.h"

int printStringUpper(char *str){
    int size = 0;

    while(str[size]!='0'){
        if((int)'a'<=str[size] && str[size]<='z')
            str[size] -= (int)('a'-'A');
        size++;
    }

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
    char arr[100];
    int byte_count = 20;
    int is_neg = 0;
    int count = 0;
    int val = 0;

    __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(arr), "d"(byte_count)
    );

    if(arr[count]=='-'){
        is_neg = 1;
        count++;
    }

    while(arr[count]!=' ' && arr[count]!='\t' && arr[count]!='\n'){
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
    char arr[100];
    int count = 0;
    int is_neg=0;
    
    if(!n) arr[count++]='0';
    else{
        if(n<0){
            is_neg=1;
            n*=(-1);
        }

        while(n){
            int temp = n%16;
            if(temp<=9)
                arr[count++]= temp+'0';
            else
                arr[count++]= temp-10+'A';
            n/=16;
        }

        if(is_neg) arr[count++]='-';
        
        for(int i=0;i < count/2; i++){
            char swap = arr[i];
            arr[count-i-1] = arr[i];
            arr[i] = swap;
        }
    }

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
    char arr[100];
    int byte_count = 20;
    int is_neg = 0;
    int count = 0;
    int dot = 0;
    float val = 0;
    float div = 1.0;

    __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(arr), "d"(byte_count)
    );

    if(arr[count]=='-'){
        is_neg = 1;
        count++;
    }

    while(arr[count]!=' ' && arr[count]!='\t' && arr[count]!='\n'){

        if ((((int)arr[count]-'0' > 9) || ((int)arr[count]-'0' < 0)) && (arr[count]!='.'))
            return BAD;
        
        if(arr[count]=='.' && dot)
            return BAD;
        
        if(arr[count]=='.')
            dot = 1;
        
        if(dot){
            div*=10;
            val+=(float)(arr[count]-'0')/div;
        }
        else{
            val*=10.0;
            val+=(float)(arr[count]-'0');
        }

        count++;
    }

    if(is_neg) val*=val;

    *f = val;

    return GOOD;
}

int printFloat(float f){
    char arr[100];
    int count = 0;
    int is_neg = 0;
    int a = (int)f;
    float dec = f - a;

    if(f==0){
        arr[count++]='0';
        arr[count++]='.';
        arr[count++]='0';
    }
    else{
        if(f<0){
            f*=(-1);
            is_neg = 1;
        }

        while((dec-(int)dec)!=0){ dec*=10;}
        int temp_dec = (int)dec;
        
        if(!temp_dec){
            arr[count++]='0';
            arr[count++]='.';
        }
        else{
            while(temp_dec){
                arr[count++]= (temp_dec%10)+'0';
                temp_dec/=10;
            }    
        }

        while(a){
            arr[count++]= (a%10)+'0';
            a/=10;
        }
        
        if(is_neg) arr[count++]='-';
        
        for(int i=0;i < count/2; i++){
            char swap = arr[i];
            arr[count-i-1] = arr[i];
            arr[i] = swap;
        }
    }

    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(arr), "d"(count)
    );

    return count;
}
