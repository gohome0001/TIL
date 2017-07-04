
# __TIL__ (~~Today~~ I Learned)
linux system programming

child process create - LINUX
------

fork 나 exec계열은 프로세스 자원 관리에 있어서 세밀한 조작을 지원함.<br/>
옛날 함수들이 업그레이드 되기는 했지만, 새로운 함수가 나온 이상 교체될 수도 있음.
#### posix_spawn 함수 원형


```c
    int posix_spawn(pid_t* restrict pid, const char* restrict path, 
        const posix_spawn_file_actions_t* file_actions,
        const posix_spawnattr_t* restrict attrp,
        char* const argv[restrict], char* const envp[restrict]);
```    
 
 * 비동기 상황에서 전역번수 errno를 읽어들이는 구조는 문제가 있을 수 있음<br/>그래서 요즘 POSIX에 새롭게 추가되는 시스템 함수들은 성공 시 0, 실패시 errno를 자체적으로 반환.

 * 원래 fork 계열 함수에서 반환하던 pid는 첫 포인터 매개변수로
 * 두번째는 실행파일 경로 ( 종류에 따라 상대/절대경로 )
 * 세번쨰는 열고 닫을 파일 정보 (descriptor) 를 갖고 있는 구조체
 * 네번째는 EUID, process group, signal관련 정보, schedule 관련 정보를 갖은 구조체
 * 다섯번째는 parameter를 담은 vector
 * 여섯번째는 환경변수 담은 vector

 여기서 세번째, 네번째가 세밀한 동작에 있어서 필요한 매개변수이다. 
<br><br>
 ## posix_spawn_file_actions_t

그 세번째 매개변수이다.<br/>

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
        int posix_spawn_file_actions_init (posix_spanw_file_actions_t* file actions,
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
    자식 프로세스 EUID 를 부모 프로세스 RUID로 설정하는 플래그<br>
    이 기능은 플래그만 설정해도 기능이 활성화 된다.

    <br>

    ---------
    
    <br>

    + <code>POSIX_SPAWN_SETPGROUP</code><br><br>
    구조체의 Process group 관련 속성 활성화
    
    <br>

    + <code>setgroup, getgroup</code><br><br>
    posix_spawnattr_t 구조체의 프로세스 그룹 속성을 활성화한다. (PGID 변경)
     ```c       
        int posix_spawnattr_setpgroup (posix_spawnattr_t* attr, pid_t pgroup);
        int posix_spawnattr_setpgrout (const posix_spawnattr_t* restrict attr, pid_t* restrict pgroup);
    ```
    <br>

    ---------------------

    <br>

    + <code>POSIX_SPAWN_SETSIGDEF</code><br><br>
    구조체의 signal 관련 속성 활성화

    <br>

    + <code>posix_spawnattr_setsigdefault</code><br><br>
    
    

    <br>

    -----------------------

    <br>
    
    + <code>POSIX_SPAWN_SETSIGMASK</code><br><br>

    + <code>posix_spawnattr_setsigmask</code><br><br>

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
