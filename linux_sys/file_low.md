# 파일 처리

리눅스에서는 저수준 파일 처리 방식과<br/>

고수준 파일 처리 방식을 지원한다

- 저수준 
    - 유닉스 계열에서만 지원
    - file descriptor 사용
    - 유닉스 계열에서는 보편적으로 사용 (많은 기능들이 파일로 취급되므로)
    - 원자적 실행을 보장함. (더 나뉘어질 수 없는 실행 단위)
    - 형식화된 입력은 아직 지원되지 않음

- 고수준
    - C 표준이므로, C가 포팅된 모든 플랫폼에서 지원
    - FILE 구조체 사용
    - 라이브러리 레벨 버퍼링이 있음
    - 형식화된 입,출력이 지원됨

즉, 저수준 입출력은 대형 서비스나, 여러 스레드가 동시에 돌아가는 상황에서 유용하게 사용됨.

-----------------

## 저수준 파일 처리 함수

### open, close, openat, create

### pread, pwrite

- 커서 위치를 사용하지 않고, 절대적인 오프셋 위치를 사용하여 입출력함. 고수준에서 입출력이 섞일 수 있는 것을 방지, 원자적 실행을 보장함.

### dfprintf

- 형식화된 문자열 출력 함수. sfprintf 계 함수랑 write랑 합쳐져 있는 것 같다. 

-----------

## 고수준 파일 처리 함수

너무 많아서(...)

이름과 간략한 기능만 쓸테니, 필요할 떄 man페이지 찾아보면서 해야겠다

### fopen, fclose
### freopen, fdopen
### setvbuf, setbuf
### fflush, fpurge
### fread, fwrite
### scanf, getc, printf, putc
### clearerr, feof, ferror
### ftruncate
### fileno
### fmemopen, open_memstream
### getline, getdelim
### getc_unlocked,...
- thread safe한(?) getc, putc 함수

## 기타

### umask
### mktemp
### remove, unlink
### link
### mkdir, rmdir
### opendir, closedir, fdopendir, dirfd
### readdir, rewinddir, seekdir, telldir
### scandir, alphasort

## inotify

- 파일 시스템 이밴트를 감시하는 API다.
- 한번 공부해 봐야겠다