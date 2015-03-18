#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	if(argc!=5)
	{
		puts("Error!!");
		return 1;
	}
	setreuid(geteuid(),geteuid());

	if( !access(argv[2],F_OK) || !access(argv[4],F_OK))
	{
		puts("Don\'t hack!!");
		return 1;
	}

	rename(argv[1],argv[2]);
	rename(argv[3],argv[4]);

    return 0;
}
