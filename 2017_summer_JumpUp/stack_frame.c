#include <stdio.h>

int foo(int x)
{
    return x+1;
}

int main()
{
    int x = 12;
    int y = foo(x);
    return 0;
}
