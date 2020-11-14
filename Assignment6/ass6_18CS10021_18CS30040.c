#include "myl.h"
#define BUFFER_SIZE 50

int printStr(char  * s)
{
    int size = 0;
    int buffer_length = 0;
    while(s[size] != '\0')
    {
        size++;
        buffer_length  =  buffer_length +1;
    }
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(s), "d"(size)
    );
    buffer_length++;
    return size;
}


int printInt(int n)
{
    char buff[BUFFER_SIZE],zero = '0';    
    int buffer_length = 0;
    int i = 0,j = 0,size,k;
    if(n<0){n = -n;buff[i++] = '-';buffer_length++;}
    if(n == 0){buff[i++]=zero;buffer_length++;}
    while(n!=0){
        buffer_length++;
        buff[i++]= (char)(n%10 + zero);
        n=n/10;
    }
    if(buff[0] == '-'){j=1;buffer_length++;}
    k=i-1;
    buffer_length++;
    size=i;
    while(j<k){
        char tmp;
        tmp=buff[j];
        buffer_length++;
        buff[j]=buff[k];
        buffer_length++;
        buff[k]=tmp;
        buffer_length++;
        j++;k--;
    }
  __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff), "d"(size)
    );
    buffer_length++;
	return size;
}

int readInt (int *  eP) {
    int i=0;
    char str[10];
    int buffer_length=0;
    int sign=1,sum=0;
     *eP=OK;
    while(1){
        __asm__ __volatile__ ("syscall"::"a"(0), "D"(0), "S"(str), "d"(1));
        if(str[0] == ' ' || str[0]  ==  '\t' || str[0] == '\n'){buffer_length++;break;}
        if(!i && str[0] == '-'){buffer_length++;sign = -1;}
        else{
            buffer_length++;
            if(str[0] >'9' || str[0]<'0' ){buffer_length++; *eP = ERR;}
            else{
                buffer_length++;
                sum = 10 * sum+(int)(str[0]-'0');
            }
        }
        buffer_length++;
        i++;
    }
    return sum * sign;
}