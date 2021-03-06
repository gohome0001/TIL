# 파일 입출력

## 저수준

file descriptor 를 통해 파일 스트림에 접근하는 방식이다.

/proc/self/fd 에 file descriptor 가 등록되어 있다.

원자적(최소단위) 실행을 보장해준다.(system call)

- `pwrite`, `pread`

동기화된 io 가능(open 할 떄 flag)

- `O_SYNC` : 모든 input 데이터 동기화
- `O_DSYNC` : 메타 데이터 제외, input 데이터 동기화 
- `O_RSYNC` : 읽을 때에도 동기화된 읽기 사용
    - 캐시를 이용하지 않고 디스크에 접근. 별로임..

유닉스 호환 계열에서 사용 가능함.(운영체제 level에서 지원해주는 방식이므로)

## 고수준

FILE 구조체를 통해 파일 스트림에 접근.

C언어 표준.

형식화된 입,출력을 지원하는 함수가 있다.

라이브러리 level의 버퍼링을 이용. fflush나 setvbuf를 통해 강제로 버퍼를 비울 수 있음.

원자적 실행을 보장해 주지 않는다(라이브러리 level이다 보니..)
 
## 차이

이미 말한거 같음.

## 하나의 file에 대해 여러 interface를 갖게 될 때

`dup()`나 `fdopen()` 같은 방법으로 하나에 파일에 대한 여러개의 채널을 생성할 시, 파일의 offset 위치를 채널이 공유한다. 주의해서 사용 해야함.

하지만 `open`, `fopen`등으로 새로 열면 독립된 채널이 되어 파일 오프셋을 공유하지 않는다.

## posix_fadvise

파일 사용 패턴을 조언(..)하는 함수이다. 열린 파일이 `순차접근, 랜덤접근, 한번쓰고 안쓴다` 이 세 종류로 조언해줌
- 순차접근 : 파일을 미리 프래패칭해둠.
- 더이상 안씀 : 캐시 정책에 반영, 메모리에서 퇴출.

---

더 알고싶거나 필요한거는 man 페이지 참고.