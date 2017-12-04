# eXterenal Data Representation (XDR)

주소 경계를 특정 단위의 배수로 하자는 규칙. 32bit, 64bit 아키텍쳐인지에 따라 4byte, 8byte 경계를 사용한다(bus 크기)

다음과 같은 예제를 실행해 보면
```c
#include <stdio.h>

struct student
{
        char name[5];
        int age;
};
int main()
{        
    struct student s1;        
    printf("name address : %lx\n", &s1.name);
    printf("age address : %lx\n", &s1.age);
    return 0;
}
```
실행결과
```
qqq1ppp@HKY14:~/temp$ ./pack
name address : 7fffd52926c0
age address : 7fffd52926c8
```
이렇게 패딩이 붙는다. 이렇게 묵시적인 패딩은 여러모로(네트워크 데이터 전송 등) 좋지 않으므로 명시적으로 패딩을 준다

struct student 부분을 이렇게 바꿔주면 된다.

```c
struct student
{
        char name[5];
        char pad[8];
        int age;
};
```

패딩에 시달리기 싫다면, 팩화 구조체를 사용해 패딩을 없애줄 수 있다. 비표준이라는점.

```
struct student
{
        char name[5];
        int age;
}__attribute__((packed));
```

혹은 gcc에서 모든 구조체를 팩 하려면
`--pack-struct` 옵션을 추가해 주면 된다.