// tests for typecasting and pointers
int multiply(float a, float b)
{
	int mul;
	mul = a*b; // type casting float -> int
	return mul;
}

int swapTwoNumbers(int* a, int* b) // function to swap two numbers 
{
	int temp = *a;
	*a = *b;
	*b = temp;
	return 1;
}

int main()
{
	int q=0,r=0;
	float x=2.5;
	q = multiply(x,1.2);
	r=10;
	int check = swapTwoNumbers(&q,&r);
	return 0;
}
