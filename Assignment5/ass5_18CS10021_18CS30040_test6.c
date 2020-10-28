// tests recursion and arithmatic operations

int fib(int n) 
{ 
  if(n<=1) return n;
  return fib(n-1) + fib(n-2);
} 

int factorial (int n) {
	int m = n-1;
	int r = 1;
	if (m) {
		int fn = factorial(m-1);
		r = n*fn;
	}
	return r;
}
  
int main () 
{ 
  int n = 9; 
  int fib_num;
  fib_num = fib(n);
  int fact = factorial(n);
  return 0; 
} 
