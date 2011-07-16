#include <stdio.h>

typedef struct s_myexample{
	char a;
	int b;
	s_myexample_t* myotherexample_p;
} s_myexample_t;

int main() {

	s_myexample_t ptr;

	printf("Hello world!\n");
	
	return 0;

}
