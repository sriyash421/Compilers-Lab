// tests for iteration and selection statements


int main() 
{ 
    int arr[] = {12, 3, 4, 15}; 
    int n = 4;
    int sum = 0; // initialize sum 
    int i; 
    
    for (i = 0; i < n; i++) {
	if((arr[i]&1) == 0){
    	   sum += arr[i]; 
	}
	else{
		break;	
	}

   }
	
    return 0; 
} 
