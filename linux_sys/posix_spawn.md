
# __TIL__ (~~Today~~ I Learned)
linux system programming

사전지식
--------

+ 예약어 restrict는 여러 포인터 변수가 이 가리키는 값을 가리키지 않는다는 의미이다.
    + 비동기 환경에서 최적화를 위해 사용한다. 
+ 리눅스 시그널, 프로세스에 부여되는 여러 id 값에 대한 지식이 필요하다.
    + 중간중간에 간략하게 설명 나올 것이다.
+ C 언어 기본지식 등 

------------------------

child process create - LINUX
------

fork 나 exec계열은 프로세스 자원 관리에 있어서 세밀한 조작을 지원하지 못한다.<br/>
옛날 함수들이 업그레이드 되기는 했지만, 새로운 함수가 나온 이상 교체될 수도 있음.
그래서 소개하는..


#### posix_spawn 함수 원형


```c
    int posix_spawn(pid_t* restrict pid, const char* restrict path, 
        const posix_spawn_file_actions_t* file_actions,
        const posix_spawnattr_t* restrict attrp,
        char* const argv[restrict], char* const envp[restrict]);
```    
 
 * 반환값
    + 비동기 상황에서 전역번수 errno를 읽어들이는 구조는 문제가 있을 수 있음<br/>그래서 요즘 POSIX에 새롭게 추가되는 시스템 함수들은 성공 시 0, 실패시 errno를 자체적으로 반환.

 * 원래 fork 계열 함수에서 반환하던 pid는 첫 포인터 매개변수로 넘겨준다.
 * 두번째 매개변수는 는 실행파일 경로 ( 종류에 따라 상대/절대경로 )
 * __세번쨰__ 는 열고 닫을 파일 정보 (descriptor) 를 갖고 있는 구조체
 * __네번째__ 는 EUID, process group, signal관련 정보, schedule 관련 정보를 갖은 구조체
 * 다섯번째는 parameter를 담은 vector
 * 여섯번째는 환경변수 담은 vector

 여기서 세번째, 네번째가 세밀한 동작에 있어서 필요한 매개변수이다. 
<br><br>
 ## posix_spawn_file_actions_t

세번째 매개변수이다.<br/>

이 구조체에서 posix_spawn 함수 실행시에, 자식 프로세스가 특정 fd를 열어두거나, 닫거나, 수정하는 추상화된 함수들로 조작한다.

* init , destroy 함수<br/>
할당하고 free 해주는 함수이다.
    ```c
        int posix_spawn_file_actions_init (posix_spawn_file_actions_t*);
        int posix_spawn_file_actions_destroy (posix_spawn_file_actions_t*);
    ```
* addopen 함수<br/>
추가로 open 할 file을 지정해준다
open 함수가 받는 매개변수들이 있다.
    ```c
        int posix_spawn_file_actions_addopen (posix_spanw_file_actions_t* file actions,
            int fildes, const char* restrict path, int oflag, mode_t mode);
    ```
   변수이름 보면 open() 매개변수들이 보일 것이다.

* addclose 함수<br>
닫을 fd를 지정해준다.
    ```c
        int posix_spanw_file_actions_addclose (posix_spawn_file_actions_t* file_actions, int fildes);
    ```
* adddup2 함수 (d 3개임) - dup2 함수와 작동방식 같음<br>
fd number를 바꿔준다 (기존 fd를 닫고, 새로운 fd를 연다)
    ```c    
        int posix_spawn_file_actions_adddup2 (posix_spawn_file_actions_t* file_actions, int fildes, int newfildes);
    ```
<br>

## posix_spawnattr_t

그 네번째 매개변수이다.<br>
구조체로 어떤걸 정의하는지 추상화된 함수로 알아보자!

* init, destroy
    ```c
        int posix_spawnattr_init(posix_spawnattr_t*);
        int posix_spawnattr_init(posix_spawnattr_t*);
    ```
* getflags, setflags<br><br>
이 구조체는 기능을 사용하려면 플래그를 설정해 준 후에 추상화된 함수로 접근해야 한다.<br>
setflags로 플래그를 설정한다.
    ```c
        int posix_spawnattr_setflags (posix_spawnattr_t* attr, short flags);
        int posix_spawnattr_getflags (const cons_spawnattr_t* attr, short *restrict flags);
    ```
+ FLAGS and functions
    + <code>POSIX_SPAWN_RESETIDS </code><br><br>
    자식 프로세스 EUID 를 부모 프로세스의 RUID로 설정하는 플래그<br>
    이 기능은 플래그만 설정해도 기능이 활성화 된다.<br><br>
    ~~RUID와 SUID가 뭔지 모른다구??~~<br>
    
        + EUID(Effective uid) : 프로세스의 실질적 휘두를 수 있는 권한은 EUID로 결정. setuid로 바뀜. 
        + RUID(Real uid) : 프로세스 실제 소유자, 시그널 보낼떄 권한.
        setuid로 바꿀 수 있음.
        + EUID 권한은 RUID 권한보다 같거나 낮아야 함.

    <br>

    ---------
    
    <br>

    + <code>POSIX_SPAWN_SETPGROUP</code><br><br>
    구조체의 process group 속성을 변경함을 알리는 flag.
    
    <br>

    + <code>setgroup, getgroup</code><br><br>
    자식 프로세스의 PGID 설정
        + PGID : process group id
     ```c       
        int posix_spawnattr_setpgroup (posix_spawnattr_t* attr, pid_t pgroup);
        int posix_spawnattr_setpgrout (const posix_spawnattr_t* restrict attr, pid_t* restrict pgroup);
    ```
    
    + 소속 시킬 그룹의 pgid 값을 넘겨준다.
    + 0값을 넣어준 것은 getpid() 값을 넘겨준 것과 같다. 즉 자식 프로세스를 독립시킨다.

    <br>

    ---------------------

    <br>

    + <code>POSIX_SPAWN_SETSIGDEF</code><br><br>
    구조체의 signal 관련 속성을 변경함을 알리는 flag

    <br>

    + <code>posix_spawnattr_setsigdefault<br>
    posix_spawnattr_setsigmask</code><br><br>
    ```c
    int posix_spanwattr_setsigdefault(posix_spawnattr_t* restrict attr, 
        sigset_t * restrict sigdefault);
    int posix_spawnattr_setsigmask(posix_spawnattr_t* restrict attr, 
        const sigset_t* restrict sigmask);
    ```
    
    + setsigdefault 함수는 부모 프로세스에서 등록된 signal 처리기를 리셋시키는 역할을 한다.<br>sigset에 add 된 시그널들만 리셋시킨다. 
    

    <br>

    -----------------------

    <br>
    
    + <code>POSIX_SPAWN_SETSIGMASK</code><br><br>
    자식 프로세스가 갖을 signal mask 관련 속성을 변경함을 알리는 flag 

    + <code>posix_spawnattr_setsigmask</code><br><br>
    ```C
    int posix_spawnattr_setsigmask (posix_spawnattr_t* restrict attr,
            sigset_t* restrict sigdefault);
    ```
    + 자식 프로세스가 지닐 시그널 블로킹 마스크를 설정한다
        + 블로킹 마스크를 설정하면, 해당 sigset을 default로 바꾸는 게 아니라 시그널무시하도록 한다.

    <br>

    -------

    <br>

    + <code>POSIX_SPAWN_SETSCHEDPARAM</code><br><br>

    + <code>posix_spawnattr_setschedparam</code><br><br>

    <br>
    
    ------

    <br>

    + <code>POSIX_SPAWN_SETSCHEDULER</code><br><br>

    + <code>posix_spawn_setschedpolicy</code><br><br>
