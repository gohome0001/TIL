#include <stdio.h>

int main(int argc, char** argv)
{
    if(argc > 1)
    {
	printf("input arg count : %d\n", argc-1);
	for(int i=1;i<argc;i++)
	{
	    printf("arg no.%d : %s\n",i , argv[i]);	
	}
    }else{
    	printf("no args\n");
    }

    return 0;
}
