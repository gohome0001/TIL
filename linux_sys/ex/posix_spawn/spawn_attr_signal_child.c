#include <unistd.h>
#include <signal.h>
#include <stdio.h>

int main()
{
   printf("Child[%d]: Start\n", getpid());

   printf("Child[%d]: Raise(SIGUSR1)\n", getpid());
   raise(SIGUSR1);

   printf("Child[%d]: Raise(SIGUSR2)\n", getpid());
   raise(SIGUSR2);

   printf("Child[%d]: Raise(SIGTERM)\n", getpid());
   raise(SIGTERM);

   printf("Child[%d]: Exit\n", getpid());
   return 0;
}
