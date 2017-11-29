#include <stdio.h>
#include <sys/inotify.h>
#include <unistd.h>

#define BUF_LEN 128
#define EVENT_SIZE sizeof(struct inotify_event)

int main(int argc, char** argv)
{
    char path[] = "/home/qqq1ppp/asdf";
    char buffer[BUFSIZ];
    int fd = inotify_init();
    int wd = inotify_add_watch(fd, path, IN_MODIFY | IN_CREATE | IN_DELETE | IN_MOVED_FROM | IN_MOVED_TO | IN_MOVE_SELF); // all flags

    while(1) 
    {
    int len, i = 0;
    len = read(fd, buffer, BUF_LEN);
    if (len < 0) {
        perror("read err\n");
    }
    while (i < len) {
        struct inotify_event *event = (struct inotify_event *) &buffer[i];
        printf ("[debug] wd=%d mask=%d cookie=%d len=%d dir=%s\n", event->wd, event->mask, event->cookie, event->len, (event->mask & IN_ISDIR)?"yes":"no");
        if (event->len) {
            if (event->mask & IN_CREATE) {
                if (event->mask & IN_ISDIR) {
                    printf("[+] directory %s was created.\n", event->name);       
                } else {
                    printf("[+] file %s was created.\n", event->name);
                }
            } else if (event->mask & IN_DELETE) {
                if (event->mask & IN_ISDIR) {
                    printf("[-] directory %s was deleted.\n", event->name);       
                } else {
                    printf("[-] file %s was deleted.\n", event->name);
                }
            } else if (event->mask & IN_MODIFY) {
                if (event->mask & IN_ISDIR) {
                    printf("[*] directory %s was modified.\n", event->name);
                } else {
                    printf("[*] file %s was modified.\n", event->name);
                }
            } else if (event->mask & IN_MOVED_FROM || event->mask & IN_MOVED_TO || event->mask & IN_MOVE_SELF) {
                if (event->mask & IN_ISDIR) {
                    printf("[>] directory %s was moved.\n", event->name);
                } else {
                    printf("[>] file %s was moved.\n", event->name);
                }
            }
        }
        i += EVENT_SIZE + event->len;
        }
    }

    return 0;

}