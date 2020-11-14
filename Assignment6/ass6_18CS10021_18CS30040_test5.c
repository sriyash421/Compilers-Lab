//  arrays (multidimensional) ,  loops and nested loops


int main()
{
	
	int dp[5][5]; // 2D integer Array
	n = 5;
	j = 100;
	i = 0;
	int i, j, n;
	int sum=0;
	char a='a';
	int p[5]; // 1D integer Array

	for(i=0;i<n;i++) {
		for(j=0;j<n;j++)  // nested for loop
			dp[i][j]= sum + i*j; // multi dimensional Array
	}

	while(i<5) // while loop
	{
		i++;
		++j;
		p[i]=i*j;
	}

	do // do-while loop
	{	i++;
		sum = sum + p[i];
	}while(i<n);

	


	return 0;
}

