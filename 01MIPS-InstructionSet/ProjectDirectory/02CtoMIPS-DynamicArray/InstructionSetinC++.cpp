// Jason McKinnerney
// CS2318
// Take Home Quiz 2
// June 24 2021


//Description:The median value of a set of integers, is the integer 𝑘such that half of the integers
//in the set are smaller than or equal to  𝑘and half of the integers in the set are greater than or equal to 𝑘

//Steps:
//1)Considera MIPS assembly program that generates and initializes a dynamic integer array of 10 integers,
// stores a pointer to the arrayin$a0 and the size of the array in $a1.
//2)Next, the program finds the median of the values stored in the array and places this value in the register $v0.
//3)Develop and submit a Pseudo C++ program in compliance with the instructions above.
//4)Convert the Pseudo C++ program toMIPS Assembly (submit the program).
//5)Your deliverables should be the Pseudo-C++program as well as the assembly code of the MIPS program.6)You do not have to run the program.


#include <iostream>
using namespace std;

int main() {
	int index, next, min, temp;
	int size = 10;												//Size of Array == $a1
	int arr[size];
	
	cout << " Please enter 10 numbers:" << endl;				//Dynamic Array == $a0
	index = 0;
	while (index != size) {
		cin >> arr[index];
		index++;
	}

    for (index = 0; index < (size - 1); index++)	{
		min = index;
		for (next = (index + 1); next < size; next++) {			//Selection Sort
			if (arr[next] < arr[min])
				min = next;
		}
		temp = arr[min];
		arr[min] = arr[index];
		arr[index] = temp;
	}

	int half = arr[(size - 1) / 2];									//Find Median value == $v0
	
	for (index = 0; index < (size); index++) 
		cout << arr[index] << endl;

	cout << "Half: " << half << endl;
};	
	
