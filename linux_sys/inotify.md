# inotify API

파일시스템 이벤트를 감시하는 API다.

각각의 파일, 혹인 디렉토리를 모니터링할 수 있다.

사용되는 함수에 대해 알아보자.

inotify_init
---

```c
int inotify_init(void)
int inotify_init(int flags)
```

이 함수는 inotify instance를 생성하고, 이에 접근할 수 있는 fd를 리턴해준다. 

flags는 bitwise OR로 설정해준다

- `IN_NONBLOCK`는 `O_NONBLOCK`을 리턴되는 fd에 적용시켜준다. 
- `IN_CLOEXEC`는 exec로 자식프로세스 생성시에 해당 fd를 닫는다. (CLOSE on EXEC)

inotify_add_watch
---

```C
int inotify_add_watch(int fd, const char *pathname, uint32_t mask)
```

`inotify_init()`으로 리턴받은 인스턴스에, 모니터링할 파일/디렉토리를 새롭게 추가하거나 수정하는 함수다. 

리턴값으로 해당 path에 대한 watch descriptor를 리턴해준다. read로 해당 path 에 대한 event를 monitor 할 수 있다.

fd는 아까 받은 fd, pathname에는 파일 경로를 준다

mask는 bitwise or로 옵션을 준다. 파일시스템 이벤트에 대한 플래그다.
모니터링 데이터 해석에도 사용된다.

inotify_rm_watch
---

```C
int inotify_rm_watch(int fd, int wd);
```

해당 watch descriptor 의 path를 watch list에서 제거한다.


이벤트 플래그
---

- `IN_ACCESS` : file에 접근했을떄 (read나 exec).

- *`IN_ATTRIB` : file의 metadata(권한이나 타임스탬프 등)가 변경되었을 떄.

- `IN_CLOSE_WRITE` : 쓰려고 연 파일이 닫혔을 때.

- *`IN_CLOSE_NOWRITE` : 쓰기 이외로 연 파일/디렉토리가 닫혔을 때.

- `IN_CREATE` : 모니터링하는 디렉토리 내에 파일/디렉토리가 create 되었을 때.

- `IN_DELETE` : 모니터링하는 디렉토리 하위의 파일이나 디렉토리가 삭제되었을 때

- @`IN_DELETE_SELF` : 모니터링하는 파일이나 디렉토리 그 자체가 지워졌을 때, 혹은 다른 파일시스템으로 옮겨졌을 때.

- `IN_MODIFY` : 파일이 수정되었을 때(write, truncate-파일사이즈 지정 등).

- @`IN_MOVE_SELF` : 모니터링되는 파일이나 디렉토리가 옮겨졌을 때(아마 같은 파일시스템 안에서).

- `IN_MOVED_FROM` : 파일 이름이 바뀌었을 때, 이전 파일명을 갖고 있는 디렉토리에서 생성되는 이벤트.

- `IN_MOVED_TO` : 파일 이름이 바뀌었을 때,
 새로운 파일명을 갖고 있는 디렉토리에서 생성되는 이벤트.

- *`IN_OPEN` : 파일이나 디렉토리가 open 되었을 때.

---

*, @에대해 설명하자면..

### directory를 모니터링할 때에

- 별표(*) 가 붙어있는 이벤트는 모니터링 당하는 디렉토리 자체랑, 그 하위 오브젝트 모두에게 일어날 수 있는 이벤트
- 아무것도 안붙은거는 디렉토리 안 하위 오브젝트에만 일어날 수 있는 이벤트

- @ 붙은거는 그 자체에만 일어날 수 있는 이벤트(인듯..)

- 일일이 안 외워도 보면 왜 그러나 이해할 수 있음.

---

다시 이어가자

- `IN_ALL_EVENTS` : 모든 이벤트를 아우르는 매크로!

- `IN_MOVE` : IN_MOVED_FROM | IN_MOVED_TO
- `IN_CLOSE` : IN_CLOSE_WRITE | IN_CLOSE_NOWRITE
 
여기부터는 `inotify_add_watch`에서 추가로 설정할 수 있는 bit들이다

- `IN_DONT_FOLLOW` : pathname이 symbolic link 라면 참조하지 않음.

- `IN_EXCL_UNLINK` : 원래는 자식 프로세스가 부모가 모니터링하는 directory에서 unlink 되어도 자식 프로세스에 이벤트가 갔는데, 이 마스크를 넘겨주면 부모 모니터링 디렉토리에서 unlink 되었다면 자식 프로세스에는 이벤트가 안 간다.

- `IN_MASK_ADD` : 이미 해당 path에 대한 inotify instance가 존재할 때 때 mask 를 추가해주는 mask.

- `IN_ONESHOT` : watchlist 에 해당 path에 대해 이벤트 하나만 감지한 후에 리스트에서 제거.

- `IN_ONLYDIR` : pathname 이 directory일때만 watchlist에 추가.

여기부터는 read로 이벤트 읽어들어올 때 mask에 set될 수 있는 bit들이다

- `IN_IGNORED` : watchlist에서 명시적으로 제거되거나(inotify_rm_watch), 파일이 지워지거나 이동되서 자동으로 제거된 경우에 설정되는 bit.

- `IN_ISDIR` : 이벤트를 일으킨게 directory다.

- `IN_Q_OVERFLOW` : 이벤트 큐에 오버플로우가 일어남.

- `IN_UNMOUNT` : 모니터링하던 object가 포함된 파일시스템이 unmount 되었을 떄 설정됨.

## 이벤트 읽어오기/해석하기

inotify file descriptor로 `read` 하면 data를 읽어들여온다.

읽어들어오는 data 형식은 다음과 같다.
```C
struct inotify_event{
    int wd;             // watch descriptor
    uint32_t mask;      // event
    uint32_t cookie;    /* 짝지을 수 있는 이벤트 짝지을 때 사용, 다를때는 0으로 set. */
    uint32_t len;       // name field len
    char name[];        /* 해당 event의 파일. null-terminated */
}
```

이제 이걸 잘 응용하면 파일시스템 모니터링 툴을 만들 수 있다 `:p`

2017.11.28 너무오랜만에 쓰는 TIL