#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {

	if(argc!=3) {
		printf("usage : %s WIDTH HEIGHT",argv[0] );
		return 1;
	}
	int WIDTH=atoi(argv[1]), HEIGHT=atoi(argv[2]);
	
	int boundary[] = {-1, WIDTH, HEIGHT, -1};
	int i=0,j=0;
	int loc_mov[4][2] = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}};
	int bound_ch[4] = {1, -1, -1, 1};
	int layer[HEIGHT][WIDTH];
	int location[] = {0,0};
	int dir = 0;
	
	while(i++ < WIDTH*HEIGHT)
	{
		if( location[(dir+1)%2]+(dir/2 == 1 ? -1:1) == boundary[ (dir+1)%4 ] ){
			boundary[dir] += bound_ch[dir];
			i--;
			dir++;
			dir%=4;
			continue;
		}
		// printf("dir : %d\n", dir);
		// printf("%d to [%d][%d]\n", i, location[0], location[1]);
		layer[location[0]][location[1]] = i;
		// printf("add %d to location[0]\n", loc_mov[dir][0]);
		location[0] += loc_mov[dir][0];
		// printf("add %d to location[1]\n", loc_mov[dir][1]);
		location[1] += loc_mov[dir][1];
		
	}
	for(i=0;i<HEIGHT;i++)
	{
		for(j=0;j<WIDTH;j++)
		{
			printf("%5d", layer[i][j]); // 
		}
		printf("\n");
	}
	
	return 0;
}
