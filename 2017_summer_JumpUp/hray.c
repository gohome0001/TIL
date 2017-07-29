#include <unistd.h>

char kkkk;

short proc_kkkk(short x)
{
    int a = 0;
    if(x >= 1)
    {
	x--;
	a = proc_kkkk(x);
	x++;
	return x*a;	
    }else{
    	return 1;
    }
}

void main()
{
    short a = proc_kkkk(3);
    kkkk = a + 0x30;

    write(1, &kkkk, 1);
    return;
}
