#include <unistd.h>
#include <spawn.h>
#include <stdio.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <wait.h>

int main()
{

    int ret_err = 0;
    pid_t pid_child = -1;
    char buff_err[64];
    posix_spawn_file_actions_t posix_faction;
    char* argv_child[] = {"forkexec_child", NULL};

    printf("Parent[%d]: Start\n", getpid());
    if((ret_err = posix_spawn_file_actions_init(&posix_faction)) != 0)
    {
        strerror_r(ret_err, buff_err, sizeof(buff_err));
        fprintf(stderr, "Fail: file_actions_init %s\n", buff_err);
        exit(EXIT_FAILURE);
    }

    if((ret_err- posix_spawn_file_actions_addopen(&posix_faction, 
        3, "pspawn.log", O_WRONLY | O_CREAT | O_APPEND, 0644)) != 0)
    {
        strerror_r(ret_err, buff_err, sizeof(buff_err));
        fprintf(stderr, "Fail: file_actions_addopen: %s\n", buff_err);
        exit(EXIT_FAILURE);
    }
    ret_err = posix_spawn( &pid_child,
	argv_child[0], 
	&posix_faction,		// action structure
	NULL,
	argv_child,
	NULL);
 
    if((ret_err = posix_spawn_file_actions_destroy(&posix_faction)) != 0)
    {
        strerror_r(ret_err, buff_err, sizeof(buff_err));
        fprintf(stderr, "FAIL: file_actions_destroy: %s\n", buff_err);
        exit(EXIT_FAILURE);
    }
    
    printf("Parent[%d]: Wait for child(%d)\n", getpid(), (int)pid_child);
    (void)wait(NULL);
    printf("Parent[%d]: Exit\n", getpid());
    return 0;

}
