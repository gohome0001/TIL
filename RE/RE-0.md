IT Expert 리버스 엔지니어링 2권
=============================
1권보단 2권부터 - 17.07.10~11

64bit CPU의 등장..
-----------------
1. 인텔이 PC에는 64bit로 충분할꺼라는 생각을 갖고 기존 x86과 호환되지 않는 IA-64 architecture를 출시(서버용).

2. AMD가 IA-32와 호환되는 AMD64를 출시.

3. 시장이 AMD를 손들어주자, intel은 AMD64 라이선스를 구매해 새로운 명칭을 붙여서 출시.
    + AMD64를 거의 복제했다 함
    + 처음에 인텔에서 명칭을 EM64T(Extended Memory 64 Technology)라 했다가 Intel 64로 바꿈.
    + MS에 의해 x86-64라는 명칭이 제안됨.
 
## AMD64의 운영(실행) 모드

+ Long Mode : 오퍼랜드 크기 32bit.
    + 64bit mode : 레지스터, 주소 표현 다 64bit로.
    + 호환 모드 : 기존 32bit로 (호환되게끔)

+ Legacy Mode : 과거에 MS-DOS가 돌아가게끔 16bit 모드 지원
    + 32bit architecture에 있던거 그대로 <br>( protected - 32bit, virtual - 16bit 호환, real - 16bit )

## AMD64 , IA-32 비교
+ 64bit 정수 수용
    + POP/PUSH, QWORD 단위 MOV, 범용 레지스터 확장.

+ 범용레지스터 개수 추가
    + R8 ~ R15

+ XMM register 추가
    - XMM이란?? (추가예정..)

+ 주소 공간(표현) 확대
    + 가상메모리는 하위 48bit로 표현, 256TB
    + 표현가능 RAM 메모리 공간 확대, 마찬가지로 48bit
    + 나중에는 64bit 다 활용할 수 있도록 지원될 것이다?!
+ RIP에 대해 상대작인 데이터 접근방법
    + 상대적인 참조로 접근. relocation 쉬워짐.
+ 확장된 SSE 명령
    - SSE란?? (추가예정..)
+ NX(No-Execute) bit 제공
    + 페이지를 실행 가능/불가능 설정하는 방법.
    + BOF 방어기법 중 하나.

+ 옛 기능 제거 - 64bit에선 의미없는 기능들
    + segment 주소지정 방법
    + task 상태전환
    + 가상 8086 mode 등

## GPR (Genral Purpose Register)
+ IP, SP, SB 등등..

## Segment Register

+ 과거에 메모리 번지 지정에 있어서 표현 범위를 늘리기 위해 사용한 레지스터.
두개의 레지스터를 사용하여 "세그먼트 : 오프셋" 방식으로 표현.

+ 그러나 32bit, 64bit에서는 표현 범위가 굉장히 넓어져서 더이상 의미가 없게 됨.
#### 그래서...
+ 32bit에서 FS 레지스터가, 64bit에선 GS 레지스터가 TIP(Thread Information Block)의 주소를 담고 있다.

+ 유저모드에서도 스레드 정보에 접근할 수 있게 제공됨

# TIB (Thread Information Block)

전체 구조
```C
struct _TEB                                         //      offset
{                                                   //    x86 | x64
    struct _NT_TIB      NtTib;                      //      0x0000

    ...

    struct _PEB*        ProcessEnvironmentBlock;    // 0x0030 | 0x0060
    DWORD               LastErrorValue;             // 0x0034 | 0x0068

    ...

    DWORD               CurrentLocale               // 0x00c4 | 0x0108

    ...

    PVOID               TlsSlots[64]                // 0x0e10 | 0x1480

    ...

    PVOID*              TlsExpansionSlots;          // 0x0f6c | 0x1780
}

```
주요 핵심 필드만 적어둠

+ ## 맨앞에 있는 NT_TIB 구조체

```C
typedef struct _NT_TIB              //      offset
{                                   //   x86  |  x64
    PVOID   ExceptionList;          //  0x000 | 0x000
    PVOID   StackBase;              //  0x004 | 0x008
    PVOID   StackLimit;             //  0x008 | 0x010
    PVOID   SubSystemTib;           //  0x00c | 0x018
    PVOID   FiberData;              //  0x010 | 0x020
    PVOID   ArbitaryUserPointer;    //  0x014 | 0x028
    struct  _NT_TIB* Self;          //  0x018 | 0x030
} NT_TIB;
typedef NT_TIB* PNT_TIB
```
+ 알아둘 만한 필드

    +  ExceptionList

        + 32bit에서는 SEH list의 첫 프레임 주소를 갖고 있다.
        + 64bit에서는 필요없다
            + SEH의 프레임 방식이 폐기되고 스택이 아닌 .pdata섹션에 배치됨
    + StackBasse
        + 해당 스레드 스택의 시작 번지를 담고 있다.
    + StackLimit
        + 스택 최대 상한 값을 갖고 있다.
    + Self
        + 자신의 시작 번지를 담고 있다. 이 값 참조시, FS, GS 레지스터를 통하지 않고도 TIB 내의 필드 참조 가능.
+ ## ProcessEnvironmentBlock
    + 프로세스 정보를 담고 있는 PEB(Process Environment Block)를 가리키는 포인터다.
+ ## LastErrorValue
    + 해당 스레드의 마지막 에러 코드다.
    + GetLastError 함수로 값을 읽어올 수 있음
+ ## CurrentLocale
    + 해당 스레드에 설정된 언어 ID 값이다.
    + GetUserDefaultLangID 함수로 값을 읽어들일 수 있음
+ ## TlsSlots
    + TLS (Thread Local Storage) 슬롯을 담기 위한 배열이다.
+ ## TlsExpansionSlots
    + 1024개의 확장 TLS 슬롯 버퍼를 위한 포인터이다.

-----------
## EFLAGS
flag 레지스터의 크기
+ EFLAGS : 32bit 
+ RFLAGS : 64bit, 그러나 33~64bit가 reserved 되어 있어 현재 사용하지 않는다.

그래서 지금은 EFLAGS만 알아도 된다. 이중에서도 주요 플래그들을 보자!

+ CF (Carry Flag)

    + 연산 결과에서 자리올림, 빌림이 필요하거나 unsigned 정수형 연산에서 오버플로우 발생시 1로.
+ PF (Parity flag)
    + 최하위 바이트에서 1 개수가 짝수면 1로 설정됨
+ AF (보조 캐리 플래그 - Auxiliary Carry)
    + BCD 연산 결과 캐리 또는 빌림이 필요한 경우 1로 설정됨
        + ## BCD 연산?? 추가예정
+ ## ZF (Zero Flag)
    + 명령 실행 결과가 0이면 설정
    + 많은 비교 명령에서 ZF에 리턴값 설정
+ SF (Sign Flag)
    + 명령실행 결과가 양수면 0, 음수면 1 (MSB - Most Significant Bit)
+ ## TF (Trap Flag) - 디버깅 용도로 사용됨
    + 이 플래그가 1이면, 명령 하나를 실행할 때 마다, 시스템은 EXCEPTION_SINGLE_STEP Exception을 발생시킴.
    + 이를 시스템에서 디버거에게 이벤트 형식으로 통지, 디버거가 이벤트를 감지해 하나의 명령이 실행되었음을 판단
    + Exception이 통지되면, TF는 다시 0으로 설정되어야 됨
+ DF (Direction Flag)
    + 문자열 명령이 하위주소에서 상위로 처리될 떄 0
    + 그 반대는 1
+ OF (Overflow Flag)
    + 오버, 언더플로우 발생시 1로 설정
+ ## IF (Interrupt Enable Flag)
    + 인터럽트 활성화시 1로 설정
    + 디버거에서는 항상 1로 설정됨.

# 레지스터 종류 (휘발성 vs 비휘발성)

+ 휘발성 레지스터

    + 함수 호출자가 함수 호출 전/후 레지스터 값이 변경되어도 무관하다 간주하는 레지스터.
+ 비휘발성 레지스터
    + 함수 호출 전/후 레지스터 값이 유지되어야 함.
    + 그래서 호출할 때 스택에 미리 저장시켜 두고 사용 후 복원시켜 줘야 함.

32bit에서는 명시적으로 구분하지 않음. EBP, EBX, ESI, EDI가 비휘발성임을 암묵적으로 전제하고 있긴 함(스택에 저장함)

하지만, 64bit에서는 명시적으로 휘발/비휘발 로 분류한다

+ ## 휘발성
    + RAX, RCX, RDX, R8~R9
    + R10, R11
        + 호출자가 필요에 따라 보존할 수 있음. syscall, sysret 명령에 사용된다
    + XMM0~5, YMM0~5
        + ## ?? 추가예정
+ ## 비휘발성
    + R12~R15
    + RDI, RSI, RBX, RBP, RSP
    + XMM6~15, YMM6~15
        + ## ?? 추가예정

-------------------------
EOF