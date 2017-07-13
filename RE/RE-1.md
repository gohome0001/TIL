IT Expert 리버스 엔지니어링 2권
=============================

170712

## FPU, 확장 및 기타 레지스터

+ FPU 레지스터 - 부동소수점(Floating Point) 계산용

    + 원래는 따로 있었는데, 현재는 CPU에 내장됨

    + ST(0) ~ ST(7), 80bit 짜리, 스택을 통해서 접근 가능 (괄호안 번호) 가 stack의 TOP을 
    참조해서 가야 함 맨위부터 0~7

    + MMX Register
        + FPU 레지스터의 하위 64bit를 취하여 사용
        + 64bit 연산에 사용 부동소수점 연산과 같이 사용 x
        + 번호가 상대적이지 않음 MMX0~7

하위 레지스터들는 명령어로 접근한다

+ SSE Register 
    + MMX의 사이즈, FPU와의 공유를 보완한 레지스터 set
    + 128bit 짜리 XMM 레지스터
    + IA-32에서는 XMM0~7, AMD64는 XMM0~15까지 제공한다
+ AVX Register
    + AMD64에서 지원한다
    + XMM 레지스터 16개를 256bit까지 확장한 YMM 레지스터
    + AVX-512라고, 미래 확장성까지 고려한 512bit 짜리 ZMM 32개도 포함되어 있다

+ ETC
    + CR (Control Registers)
        + CR0 ~ CR4 제공됨 사이즈는 아키텍처 word
        + 프로세서의 운영 모드나 실행 중인 작업의 특성을 결정하는 데 이용됨
        + 64bit에선 태스크 우선순위 레지스터 C8이 추가됨, AMD64에선 EPER이라고 별도로 제공됨

    + DR (Debugger Registers)
        + DR0 ~ DR7 제공됨
        + 프로세스 디버깅 작용 감시 및 제어에 사용
        + 아케텍쳐 word 사이즈
    + DTR (Descriptor Table Registers)
        + 가상 메모리를 실제 물리적 메모리로 변환하는데 사용
        + 32bit에선 48bit GDTR (Global DTR)과 LDTR (Local DTR)이 제공됨
        + 인터럽트 처리를 위해 IDTR (Interrupt DTR) 제공됨
        + 64bit에선 80bit로 확장되었음 (3개 다)

## Instruction Format

### Instruction 기본 형식

```
[Prefix] 명령 [Operand1], [Operand2], 
```

+ Prefix

    + 명령을 보조하는 역할
    + 자주 나오는거 : REP - 명령 반복
+ 명령(Instruction)
    + CPU에 내리는 명령
    + 아키텍처별로 제각각
+ Operand
    + 명령어의 피연산자
    + 상수, 메모리 주소값, 레지스터 등을 갖을 수 있다
    + AMD64는 최대 4개까지 가질 수 있음 필요없는거도 있음
    + 명령별로 가변적이다

### 연산의 기본 원칙

오퍼랜드가 2개 이상일 경우 다음을 원칙으로 함
```
명령 target, source
```

+ 연산방향 : target -> source __(intel 명령어 형식)__

+ 연산결과 : target에 저장 (즉, target에는 상수 x)
+ Intel 계열 CPU에서는 source, target이 둘 다 메모리 참조인 경우를 금지함
    + 메모리 to 메모리는 레지스터를 경유해야 한다

### Operand 형식

오퍼랜드끼리는 Size를 맞춰주어야 한다.

### 메모리 참조

source operand가 이런 형식일 때가 있따
```
operand_size ptr [address]
```

+ operand_size

    + BYTE는 8bit

    + WORD는 16bit
    + DWORD는 32bit, QWORD는 64bit, MMWORD - 64, XMMWORD - 128, YMMWORD - 256
    + 만약 사이즈를 명시하지 않아도 충분히 짐작할 수 있는 상황이면 지정하지 않아도 됨
        + 하지만, 지정하지 않으면 다른 동작을 할 수도 있음
+ ptr (pointer)
    + operand_size의 값을 가리키는 포인터임을 알리는 지시어
+ address
    + 참조할 가상메모리의 주소.

### 유효 주소 지정

위의 address 부분은 다음과 같은 형식으로 표현될 수 있음
```
[ BASE + ( INDEX * SCALE ) + DISP ]
```

+ [ BASE + DISP ]
    + BASE는 기준 레지스터
    + DISP는 변위 (Displacement) - BASE에 대한 OFFSET 역할을 함.
    + 매개변수나 지역변수, 구조체의 멤버필드에 접근할떄 많이 사용된다.
    ```
    mov eax, [esp]
    mov ebx, [ebp + 22]
    ```
+ INDEX 랑 SCALE
    + SCALE은 SIZE
    + INDEX는 말 그대로 INDEX
    + 배열을 참조할 떄 사용.
    ```
    mov eax, [ebx + ecx * 8];           ebx가 base고, size가 8인 배열의 ecx index 값에 접근 
    ```


### 64bit에서 RIP의 상대적 번지지정

64bits는 PE file에서 .reloc 엔트리 수가 적다<br/>
바로 64bit는 RIP로 상대주소 지정이 가능해졌기 때문이다

+ jmp나 call 명령은 x86때부터 명령어 포인터에 대한 상대주소로 계산되었음.

+ 위의 유효 주소지정방식을 사용하는 Operand로써 RIP를 사용할 수 있게 바뀜.

```
mov rax, qword ptr [rip + 32];      64bit에서 가능
mov eax, dword ptr [eip + 32];      32bit에서 불가능. 혹은 eip를 무시해서 32만 남음.
```


