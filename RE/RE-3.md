<head>
    <style type="text/css">
        @import url(http://fonts.googleapis.com/earlyaccess/nanumgothic.css);
        *{font-family:'Nanum Gothic'}
    </style>
</head>

# instruction format 

## 큰그림

```
[Prefix] [Opcode] [Mod R/M] [SIG] [DISP] [Imm]
```

### Prefix 
가나다라

- 명령어에 대한 보조, operand size 지정 등 보조하는 역할을 한다

- 없거나 3byte 까지 있을 수 있음

### Opcode

- 수행하는 명령어 식별코드. 

- 1~3byte로 구성된다. (들어봄직한건 거의 1byte에 있음)

### MOD R/M

- Operand를 지정하는 식별자, 없을수도 있다

- Operand Opcode 뒤에 붙는다

- 1Byte.

### SIB (Scale - Index - Base)

- 명령어에서 [scale*index+base] 이런식으로 표현할 필요가 있을 때 붙는다.

- 1Byte.

### Disp (displacement)

- 메모리 주소 지정시 변위값.

- 없거나 1, 2, 4byte값이 따라붙는다.

### Imm (Immediate, 상수)

- 상수가 사용되는 명령어에 사용되는 필드

- 1, 2, 4, 8byte가 따라붙는다.

---

## Prefix

`[Prefix]` [Opcode] [Mod R/M] [SIG] [DISP] [Imm]

### operand 및 주소 크기

- 메모리 오퍼랜드, 레지스터 오퍼랜드의 `기본 크기` 변경시, 주소참조 `기본 크기` 변경시 (0x66, 0x67)

### segment

- 메모리 참조 시, 세그먼트 레지스터를 붙이라 할 때 (64bit 모드에서는 무시!)

### lock 

- 명령어 Lock 할 때 (0xf0)

### 반복

- REP, REPE (0x32) , REPNE(0xf2)

<br/>

### REX (Register Extention...?)

64bit 를 위한 프리픽스

- 레지스터 확장 (범용 및 XMM, control, debuging, ..)
- 레지스터 size 확장.

8bit 레지스터를 그대로(여전히!?) 사용할 수 있다.

- 형식
    - 1 byte가 주어짐
    - 상위 4bit는 0100으로 고정. 즉 `0x4X` (X=0~3)
    - 하위에는 위에서부터 차례대로

- 의미
    - 5번쨰 
        - REX.W 
        - 0이면 기본 operand 크기, 1이면 64bit operand.
    - 6번째
        - REX.R
        - 뒤에 따라올 mod r/m byte의 reg 필드 앞에(최상위 bit) 이 bit를 붙임
        - 1일 경우 64bit 확장 레지스터를 사용함
    - 7번째
        - REX.X
        - 뒤에 나올 수 있는 SIB byte index 필드 앞에(최상위 bit) 이 bit 붙임
        - 요 index 필드는 레지스터 id를 지정하는 필드임. 즉 1일 경우 확장 레지스터를 사용함 
    - 8번째
        - REX.B
        - mod r/m byte의 r/m 혹은 op 필드 (flag 값에 의해 둘 중 하나로 결정됨), SIB byte의 base 필드 앞에(최상위 bit) 이 bit를 붙임. 즉 확장 레지스터 사용 혹은 표현범위 증가.

- 이 prefix가 필요없는 명령어
    - 64bit일 때, code의 주소 등 64bit 매개변수만 취하는 명령어들.

- etc
    - 보니까, 32bit의 inc, dec명령어와 겹침.(inc : 0x40~0x47, dec : 0x48~0x4f)
        - 그래서, 64bit에서는 각각 0xfe, 0xff로 바뀜.
    - avx 명령어 set을 위한 전용 prefix 가 따로 있음. 나중에..

---

## Opcode

[Prefix] `[Opcode]` [Mod R/M] [SIG] [DISP] [Imm]

명령어는 opcode : 명령어 에 있어서, n:1, 1:n, 1:1로 매칭된다.

1:n으로 매칭되는 경우에는 Opcode 외에 다른 symbol을 통해 어떤 명령어인지 결정짓는다

n:1로 매칭되는 경우에는 operand type 등의 이유로 나뉜다.

길이는 1byte~3byte 로 이루어져 있다.

## Mod r/m

[Prefix] [Opcode] `[Mod R/M]` [SIG] [DISP] [Imm]

해당 코드가 갖는 오프랜드의 type 또는 Opcode 식별을 위해 사용되는 심볼이다.

필드는 다음과 같다
```
bit  0 1   2 3 4    5 6 7
    [mod] [reg/op]  [r/m]
```

### Mod

Operand type을 지정한다.

- 11b 인 경우
    - r/m 필드는 레지스터 식별 id.
- 아닌경우
    - 메모리 참조. 레지스터 식별 id.


### reg/op

- Operand로 사용할 범용 regiser 식별 id, 혹은 op code 와 결합해서 opcode 식별에 사용.

- Opcode 중 /digit symbol을 갖는 Opcode의 식별에 사용.

- REX.R 필드가 최상위 비트로 추가됨. 이때, AMD64의 모든(지정 가능한) 레지스터를 지정할 수 있음.

### r/m

- 메모리 참조를 위해, 혹은 레지스터 값을 위해 레지스터 id 식별.

### MOD r/m 의 사용

- mod = 0
    - 메모리 참조 -> [base]
    - base는 레지스터.
- mod = 1
    - 메모리 참조 -> [base+disp8]
    - 8bit displacement를 위한 상수가 뒤따라옴.
- mod = 2
    - 메모리 참조 -> [base+disp32]
    - 4byte displacement를 위한 상수가 뒤따라온다.

base로 쓸 레지스터는 r/m에서 지정한다.

r/m field 가 100b 일때, 참조할 메모리를 SIB symbol 을 이용해 지정한다.
- 이떄, disp가 +되는거는 그대로 작용

특별히, r/m field 가 101b, mod가 0일 떄 RIP를 base로 해 메모리 주소를 지정한다.
- relocation 되는 경우가 많은데, 이떄 유용하게 사용될듯 

이후에 완성된 instruction 하나 가져다가 해당 필드 보면서 해석하는 연습이 필요할 거 같다.

---

다음엔 이어서 SIB byte 내용.
