#include <stdio.h>
#include <stdlib.h>

int main()
{
    int *one = malloc(sizeof(int)*2);
    int *two = malloc(sizeof(int)*2);
    int *three = malloc(sizeof(int)*2);
    free(two);
    printf("success\n");
    return 0;
}
