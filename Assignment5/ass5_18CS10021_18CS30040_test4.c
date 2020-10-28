// tests for recursion and nested if else

int GCD(int a, int b) 
{ 
    if (a == 0) 
        return b; 
    return GCD(b % a, a); 
} 

int main()  
{  
    int a, b, g;
    int flag = 2;
    if(flag==0)
    {
    	a= 10;
    	b= 25;
    }
    else
    {
    	a = 5;
    	if(flag==1)   // nested if else
    		b=5;
    	else
    		b=4;
    }
    g = GCD(a, b);   // recursive function call
    return 0;  
}  
