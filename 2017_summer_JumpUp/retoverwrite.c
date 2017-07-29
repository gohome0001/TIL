#include <stdio.h>
#include <string.h>

void func()
{
    printf("you did it!");
}

int main(int argc, char** argv)
{
    char buf[128];
    strcpy(buf, argv[1]);
    printf("%s\n", buf);

    return 0;
}

