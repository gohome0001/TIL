#include <stdio.h>
#include <sys/ptrace.h>

int main()
{
    int a = ptrace(0,0,1,0);
    if(a != 0)
    {
    	printf("don't trace me!\n");
    }else{
    	printf("hi!\n");
	printf("PTRACE_TRACEME : %d\n", PTRACE_TRACEME);
    }
}
