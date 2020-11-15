// Nested loops 

int main(){
	int n, err=1;
	printStr("_____________ Pattern _____________\n");
	printStr("Num of lines:\n");
	n=readInt(&err);
	int i=0,j=0;
	for(i=1;i<=n;i++){
		for(j=i; j<=n; j++){
			printStr("*");
		}
		printStr("\n");
	}
}