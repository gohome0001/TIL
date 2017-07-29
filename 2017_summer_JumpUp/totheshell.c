#include <unistd.h>

void main()
{
    char *sh[2];
    sh[0] = "/bin/bash";
    sh[1] = NULL;
    execv(sh[0], sh);
}
