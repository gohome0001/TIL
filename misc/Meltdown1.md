# Meltdown attack

컴알못 친구가 Meltdown이 뭐냐면서 물어볼 정도로 크게 issue가 된 Hardware 취약점을 이용한 공격입니다. :frog: 

배경지식이 없으면 내용 이해에 구멍이 많이 생기기 때문에, 어느 정도 세부적인 내용도 짚어 가면서 설명하도록 하겠습니다ㅎㅎ :p

## Overview

보통 이런 큰 issue가 일어났을 때 전용 웹 페이지가 하나씩 생겼었는데.. 하고 검색해 봤더니 [요 사이트](http://www.meltdownattack.com)가 있었습니다. 

들어가 보면, Meltdown과 Specture 취약점을 묶어서 다루고 있습니다.

우선 사이트에 나온 소개글을 보면 Meltdown을 다음과 같이 설명하고 있습니다.

> Meltdown은 user application과 운영체제(kernel) 사이 `근본적인 분리 개념`을 깨버린다.

> 이 공격으로 일반 프로그램이 다른 프로그램과 운영 체제의 메모리에 있는 secret(중요 정보)에 접근할 수 있게 한다.

우리가 사용하는 대부분의 프로세서(CPU), 운영체제는 `가상 메모리`로 각 프로세스의 메모리를 관리합니다.

![virt_mem](/uploads/3d647b86ef8a0efbfde016d693eb3d1d/virt_mem.png)

user process에서 kernel 기능을 사용할 때 overhead를 줄이기 위해서, 위의 그림처럼 모든 프로세스의 가상 메모리에는 kernel 프로세스가 매핑되어 ~~있습니다~~있었습니다.

이때, user 프로세스에서 kernel 프로세스의 메모리 공간을 침범하지 않도록(분리), ring level이라는 매커니즘으로 접근 권한을 설정해 두었습니다

x86 arch같은 경우에는, ring0 ~ ring3까지 protection ring이 설정되어 있고, 숫자가 낮을수록 높은 레벨이며`(ring0 : kernel, ring3 : user)`, 높은 레벨은 낮은 레벨의 메모리 공간에 접근할 수 있습니다. 물론 반대로는 안돼야 하겠죠?

그러나 Meltdown은 **명령어의 유효성을 확인하기 전에, Kernel 영역의 메모리를 읽어들여, 이후에 복원할 수 있도록 특정한 동작을 하는 코드를 실행시키는 방식**으로 공격이 진행됩니다.

Meltdown Attack을 이해하기 위해
<h4>
- address space (조금 더 자세히)

- cache side-channel attack (flush+reload)

- out-of-order execution
<h4>

에 대해 알아봅시다 :point_down: 

## Background

### address space

위에 overview할 때 간략하게 설명했듯이, 운영체제와 processor에선 physical memory를 추상화 한 가상 메모리로 각 프로세스의 메모리를 관리합니다. 이 가상 메모리는 user 부분과 kernel 부분으로 나뉘어져 있고, 각각 접근 level이 설정되어 있습니다.

여기에 추가로, Kernel process의 가상 메모리에는 전체/일부 physical memory가 매핑되어 있습니다.

![address_space](/uploads/1dd135ddb591ec9e3046528f1fbd9a87/address_space.PNG)
( 출처 : [Meltdown official Paper](https://meltdownattack.com/meltdown.pdf) )

위 사진은 Linux와 OS X에 해당되는 개념입니다. 

user process에서 Kernel의 기능을 사용하는 것과 반대로, Kernel process에서 다른 메모리에 접근하기 위해서 저렇게 전체 물리 메모리를 자신의 가상 메모리 공간에 매핑해 뒀다고 하네요.

Windows같은 경우에는 조금 다릅니다. Windows는 kernel process 공간에 paged/non-paged pool, system cache라는 메모리 공간에 대한 mapping을 갖고 있습니다. 이는 전체 물리 메모리의 상당한 크기의 공간입니다. 

( paging에 대한 자세한 내용은 [여기](https://en.wikipedia.org/wiki/Paging) )

즉, **kernel 메모리를 읽으면, 전체/일부 물리 메모리 공간의 data를 읽어올 수 있습니다**

---

### cache side-channel attack

컴퓨터의 메모리 계층은 다음과 같습니다.

![memory_hierarchy](/uploads/5afe5d23abed70f8f219bc5e85f41ac7/memory_hierarchy.jpg)

(출처 : [여기](http://www.moreprocess.com/devices/computer-memory-hierarchy-internal-register-cache-ram-hard-disk-magnetic-tape) )

더 빠르게 접근해야 하는 데이터는 높은 계층의 메모리에 로드됩니다.

캐시 메모리는 `지역성의 원리` 중 시간 지역성과 공간 지역성을 따르도록 구현되어 있습니다.

- 시간 지역성 : 한번 참조된 데이터는 다시 참조될 가능성이 높다
- 공간 지역성 : 참조된 데이터 근처에 있는 데이터가 이후에 사용될 가능성이 높다

캐시에 이미 로드되어 있는 메모리 주소를 참조할 때는 다른 로드되어있지 않은 주소에 비해 접근 속도가 빠르겠죠?

이를 이용한 [flush+reload](https://eprint.iacr.org/2013/448.pdf)라는 cache side-channel attack을 Meltdown에서 Kernel memory를 뽑아내는 데에 이용합니다.

과정은 다음과 같습니다

1. 캐시 메모리를 비운다(clflush 등).
2. Kernel 영역에서 가져온 data (bit 단위가 가장 빠르다)를 base로 메모리 주소에 데이터를 읽어온다.
3. 이후에 메모리 접근 시간 측정을 통해 cache에 load된 주소를 알 수 있음
4. 주소를 알게 되면, Kernel에서 읽어온 data를 알아낼 수 있음

---

### out-of-order execution

이제 그러면 kernel data를 어떻게든 가져오고 + code 몇줄만 실행할 수 있으면 됩니다 ㅎㅎ

취약점이 발생한 Processor에는 out-of-order execution이라는 최적화 기술이 포함되어 있습니다.

이 기술이 적용된 Processor에선, 실제 code가 실행될 때는 (이름 그대로)명령어가 정직하게 순서대로 실행되지 않습니다.

Processor를 최대한 바쁘게 돌리기 위해서, 먼저 실행되어도 상관없는 명령어들은 미리 실행시킵니다.

```Assembly
mov bl, byte [메모리 어딘가]
add al, bl
mov ecx, eax
```

저렇게 명령어 operand의 값이 이전 명령어에 의해 결정되는, 선행되어야 하는 과정이 존재하는 명령어를 `의존성이 있다`고 말합니다.

다음에 실행되리라 예측되는 경로에 있는 명령어들 중 의존성이 없는(즉시 실행될 수 있는) 명령어를 미리 실행해 둡니다. x86 architecture에서의 구체적인 과정은 다음과 같습니다.

![processor](/uploads/705831ad78de758136cbaa1e398662b7/processor.png)

(간략하게 표현된 그림입니다)

모든 명령어들은 최소 실행 단위 micro opcode로 변환되어 reorder buffer라는 queue에 넘겨줍니다. 이곳에서는 operand로 사용되는 register등을 가상으로 할당, rename하고 이후에 buffer를 정리하는 등의 작업이 이루어지고, 의존성이 있는/없는 명령어에 따라 실행 순서가 정해집니다.

queue에 들어온 명령어들은 의존성이 없는(해결된) 명령어 순으로 먼저 각각의 분류에 따른 execution unit으로 보내집니다(산술연산, load, store 등). 의존성이 있는 명령어들은 execution unit에서 해당되는 operand 값이 처리될 때 까지 대기하고 있습니다.

out-of-order execution은 Branch predictor를 통해 다음에 실행되리라 예측되는 명령어를 reorder buffer에 넣어줍니다.

예측한 명령어가 실제로 실행되었고, exception이 발생하지 않았으면 실행 결과를 적용합니다

그러나, 예측이 틀렸거나(실제로 코드가 실행되지 않았거나), 실행할 때 exception이 발생했다면 reorder buffer를 비우고 결과값을 rollback 합니다. 

Meltdown kernel space에서 data를 load해오는 명령어를 실행합니다. exception이 발생하게 되면서, 실행 결과가 rollback 되겠죠.

하지만, 이 exception은 나중에 reorder buffer를 정리할 때가 되어야 확인합니다. exception이 발생되는 micro opcode가 실행되었을 경우, reorder buffer에 표시만 해두고 이후에 정리할 때 이에 대한 처리를 하기 때문입니다.

즉, exception을 일으킨 micro opcode는 실행되었습니다. 이 실행 결과를 어떻게..가져올 수 있을까요? 

이때, 앞에서 설명한 cache side-channel attack을 활용합니다. 

이 공격을 위해, Kernel에서 데이터를 읽어오는 코드 이외에 다른 코드들이 덧붙여서 실행되어야 합니다. 

결과적으로, out-of-order execution으로 실행되어야 할 코드는 다음과 같습니다.

+ kernel 메모리 읽어오기

+ 읽어온 값으로 cache side-channel attack

이를 out-of-order execution으로 처리되게 하기 위해서, Meltdown Paper에서는 아래의 code를 예시로 들었습니다

```
raise_exception()
access(array[data*4096])
```

첫줄과 두번째 줄 사이에는 의존성이 없으므로, 두번째 줄의 code는 미리 실행될 것입니다. 하지만, exception으로 인해 두번째 줄이 실행되리라 한 예측이 틀렸으므로, 가지고 온 array[data*4096] 값은 폐기될 되겠죠? 그러나 참조된 값은 캐시에 로드되어 있을 것이므로, Kernel에서 읽어온 값을 data에 넣어준 다음 이후에 접근 시간 측정을 통해 접근한 주소를 알게 되면 kernel data 값을 알아낼 수 있습니다.

## Attack!

사실 바로 위에 나온 과정을 반복하면 됩니다. 

다음은 Meltdown Paper에서 말한 공격 핵심 코드입니다.

```Assembly
; rcx = kernel address
; rbx = probe array
retry:
  mov al, byte [rcx]
  shl rax, 0xc
  jz retry
  mov rbx, qword [rbx + rax]
```

공격이 어떻게 진행되는지는 앞서서 설명했으니, code에 대한 부수적인 설명을 해드릴게요 :baby_chick:

kernel에서 가져온 data를 shl 연산으로 12bit 밀어버립니다( 4096을 곱한 것과 같음, 4KiB ). 왜 4KiB씩 띄엄띄엄 접근할까요?

캐시 메모리의 공간 지역성 때문에, 특정 주소에 접근하면 그 주변의 메모리도 같이 load 됩니다. 

Page size(일반적으로 4KiB)만큼의 거리를 둔다면, 그 load 되는 ‘주변’의 범위보다 더 넓은 단위로 접근하게 되므로, 이후에 접근 시간을 측정했을 때 정확한 값을 얻어낼 수 있을 겁니다.

그 이후에, kernel에서 불러온 값이 0이면 계속 kernel에서 값을 다시 불러오는 부분입니다. 

이렇게 하는 이유는, 권한 없는 메모리 접근에 대한 exception 처리로는 모든 레지스터 값을 0으로 만든 후에 종료합니다.

이때, 0으로 레지스터 값을 비워 나가는 과정 중에, 5번 line이 실행된다면, kernel 데이터와는 무관하게 0x00값이 이용됩니다. 그래서 확인 차 다시 커널 메모리를 불러오는 것입니다.

만약 불러온 data가 진짜로 0x00이라면 이후에 메모리 주소 접근 시간 측정 할 때에 cache에 load된 값이 아무것도 없다는 것을 통해 data가 0임을 확인할 수 있다 합니다.

실제 공격의 효율을 높이기 위해서, data는 1bit 단위로 알아낸다고 하네요.

또한, 프로세스가 매번 죽어버리면 곤란하므로, fork로 만든 child process에서 data를 전송(?) 하고, 부모 프로세스에서 cache hit 검사를 통해 data를 복구한다고 합니다.

## 위험성

종합하면, Meltdown Attack은 일반 user가 전체/일부 물리 메모리를 dump할 수 있는 공격입니다. Kernel 뿐만 아니라 다른 프로세스에 있는 data도 얻을 수 있으니, Cloud 서비스 같은 경우에는 큰 위협이 될 것이라 하네요.

## Mitigation

리눅스에선 KASLR (Kernel Address Space Layout Randomization) 을 보완하기 위해 KAISER (Kernel Address Isolation to have Side-channels Efficiently Removed)패치로 커널 page table이 user 프로세스에 공유되지 않도록 패치가 있었습니다. 이를 KPTI (Kernel Page Table Isolation)라고 합니다.

Meltdown Paper에서는 이 KAISER가 Meltdown을 막기 위해서 취약한 Processor위에서 돌아가는 운영체제에
 적용되야 한다고 말하고 있습니다.

KAISER가 적용된다면, 유저의 가상 메모리에 커널 프로세스의 주소 공간이 공유되지 않습니다. 그러나 x86 arch의 설계에 의해 일부 Kernel code가 user space에 load되어야 한다고 하네요. 하지만 이전처럼 전체 물리 메모리 dump를 뜰 수 는 없겠죠? 물론 성능 향상을 위해 user에 매핑되었던 kernel이 더이상 매핑되지 않는다면, 성능이 이전에 비해서 저하될 수 밖에 없습니다..

## 마치며

언제 끝마칠까요..

18.01.16

