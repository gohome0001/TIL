#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char** argv)
{
	char buf[2];
	size_t f = open(argv[1], O_RDONLY);
	int i;
	while(read(f,buf,2))
	{
		if(buf[0] == "\xff")
		{
			if(buf[1] >= 0xd0 && buf[1] < 0xd9)
				continue;
			else if(buf[1] == 0xd9)
				break;
			else if(buf[1] == 0x01)
				continue;
			else if(buf[1] == 0xff)
				continue;
			else
			{
				read(f,buf,2)
			}
		}else{
			printf("not correct jpeg image\n");
			return -1;
		}
	}
	size_t offset = 	
}
