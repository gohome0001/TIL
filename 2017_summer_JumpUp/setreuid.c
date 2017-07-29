#include <unistd.h>
#include <string.h>

void main(int argc, char** argv)
{
    setreuid(geteuid(), geteuid());
    int i = 1;	
    char command[100];
    for(; i<argc; i++)
    {
	strcat(command, argv[i]);
	strcat(command, " ");
    }
    system(command);
}
