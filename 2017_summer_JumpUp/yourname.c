#include <stdio.h>
#include <unistd.h>

char* getname()
{
    static char name_buf[100];
    scanf("%s", name_buf);
    return name_buf;
}

int main()
{
    char* name;
    printf("input name : ");
    name = getname();
    printf("name : %s\n", name);
    return 0;
}
