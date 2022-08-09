// Jason McKinnerney
// CS2318
// Assignment 4
// June 30 2021


#include <iostream>
using namespace std;

	
// Perrin Function. Takes input and runs algorithm to compute an integer result

int perrin(int input) {			// input variable will be loaded from 0($sp) to $t0
	
	int answer;					// $s0 will be result to return
	int a = 3;					// $t1
	int b = 0;					// $t2
	int c = 2;					// $t3
	
	if (input == 0) 			// if $s0 == $t2	
		answer = 3;			
	
	if (input == 1) 			// if $s0 == $t4 ($t4 set to 2)				
		answer = 0;
	
	if (input == 2)				// if $s0 == $t3
		answer = 2;
	
	while (input > 2) {			// Perrin Loop
		answer = a + b;
		a = b;
		b = c;
		c = answer;
		input = input - 1;
	}
	
	return answer;				//  Save result from $s0 to 4($sp)
};								//	And Return

int main() {

	int input;					//	$t0
	int result;					//	$s0

	
	
	cout << "Please enter a value between 1 and 10: "; 
	
	cin >> input;				// Store input in $t0
	
	result = perrin(input);		// Call Function and Store Result in $s0
	
	cout << "The final result is: " << result << endl;
	
	

	return 0;

};