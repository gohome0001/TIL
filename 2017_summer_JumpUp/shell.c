#include <stdio.h>

void main()
{
	setreuid(geteuid(), geteuid());
	system("/bin/bash");
}
