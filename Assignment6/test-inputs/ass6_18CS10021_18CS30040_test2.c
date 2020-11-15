// Convert decimal number to binary
int main()
{
    int N, binary, reverse_binary, temp, d;
    reverse_binary = 0;
    binary = 0;
    printStr("_____________ Convert Decimal Number to Binary ______________\n");
    printStr("Input an integer: ");
    
    int err = 1;
    N = readInt(&err);

    temp = N;
    d = 0;

    while(temp != 0){
        d = d + 1;
        if(temp%2==1)
            reverse_binary = reverse_binary*10 + 1;
        else
            reverse_binary = reverse_binary*10;

        temp = temp /2;
    }
    
    while( reverse_binary != 0 ){
        binary = binary*10 + reverse_binary%10;
        reverse_binary = reverse_binary/10;
        d = d - 1;
    }
    while(d != 0){
        d = d - 1;
        binary = binary * 10;
    }
    printStr("The binary representation of the integer is:");
    printInt(binary);
    printStr("\n_______________________________________________\n");
    return 0;
}