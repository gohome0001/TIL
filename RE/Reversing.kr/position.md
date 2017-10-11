## 풀이

serial key가 76876-77776 일 떄, 해당되는 name 값을 찾으라 한다.
name 값의 힌트는 ***p 라고 한다.

능력이 부족해서..IDA로 까 보고 함수들 뒤져보면 아래와 같은 함수가 나온다.
```cpp
void __thiscall sub_401CD0(void *this)
{
  void *v1 // esi@1
  signed int v2 // eax@1
  CWnd *v3 // ecx@1

  v1 = this
  v2 = sub_401740((int)this)
  v3 = (CWnd *)((char *)v1 + 188)
  if ( v2 )
    CWnd::SetWindowTextW(v3, L"Correct!")
  else
    CWnd::SetWindowTextW(v3, L"Wrong")
}
```

sub_401740 함수에 모든게 달려있는 듯 하다.
코드분석은 주석으로 달려있음

```cpp
signed int __stdcall sub_401740(int a1)
{
  int v1 // edi@1
  char *v2 // ecx@2
  int v4 // esi@4
  int v5 // esi@8
  __int16 v6 // bx@10
  unsigned __int8 v7 // al@15
  unsigned __int8 v8 // ST2C_1@15
  unsigned __int8 v9 // al@15
  unsigned __int8 v10 // bl@15
  wchar_t *v11 // eax@15
  __int16 v12 // di@15
  __int16 v13 // ax@15
  wchar_t *v14 // eax@16
  __int16 v15 // di@16
  __int16 v16 // ax@16
  wchar_t *v17 // eax@17
  __int16 v18 // di@17
  __int16 v19 // ax@17
  wchar_t *v20 // eax@18
  __int16 v21 // di@18
  __int16 v22 // ax@18
  wchar_t *v23 // eax@19
  __int16 v24 // di@19
  __int16 v25 // ax@19
  unsigned __int8 v26 // al@20
  unsigned __int8 v27 // ST2C_1@20
  unsigned __int8 v28 // al@20
  unsigned __int8 v29 // bl@20
  wchar_t *v30 // eax@20
  __int16 v31 // di@20
  __int16 v32 // ax@20
  wchar_t *v33 // eax@21
  __int16 v34 // di@21
  __int16 v35 // ax@21
  wchar_t *v36 // eax@22
  __int16 v37 // di@22
  __int16 v38 // ax@22
  wchar_t *v39 // eax@23
  __int16 v40 // di@23
  __int16 v41 // ax@23
  wchar_t *v42 // eax@24
  __int16 v43 // si@24
  __int16 v44 // ax@24
  unsigned __int8 v45 // [sp+10h] [bp-28h]@15
  unsigned __int8 v46 // [sp+10h] [bp-28h]@20
  unsigned __int8 v47 // [sp+11h] [bp-27h]@15
  unsigned __int8 v48 // [sp+11h] [bp-27h]@20
  unsigned __int8 v49 // [sp+13h] [bp-25h]@15
  unsigned __int8 v50 // [sp+13h] [bp-25h]@20
  unsigned __int8 v51 // [sp+14h] [bp-24h]@15
  unsigned __int8 v52 // [sp+14h] [bp-24h]@20
  unsigned __int8 v53 // [sp+19h] [bp-1Fh]@15
  unsigned __int8 v54 // [sp+19h] [bp-1Fh]@20
  unsigned __int8 v55 // [sp+1Ah] [bp-1Eh]@15
  unsigned __int8 v56 // [sp+1Ah] [bp-1Eh]@20
  unsigned __int8 v57 // [sp+1Bh] [bp-1Dh]@15
  unsigned __int8 v58 // [sp+1Bh] [bp-1Dh]@20
  unsigned __int8 v59 // [sp+1Ch] [bp-1Ch]@15
  unsigned __int8 v60 // [sp+1Ch] [bp-1Ch]@20
  int v61 // [sp+20h] [bp-18h]@1
  int v62 // [sp+24h] [bp-14h]@1
  char v63 // [sp+28h] [bp-10h]@1
  int v64 // [sp+34h] [bp-4h]@1

  ATL::CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>::CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>(&v61)
  v1 = 0
  v64 = 0
  ATL::CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>::CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>(&v62)
  ATL::CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>::CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>(&v63)
  // 문자열 객체를 초기화하는 과정으로 보인다.

  LOBYTE(v64) = 2 // 의미x
  CWnd::GetWindowTextW(a1 + 304, &v61)
  // a1은 this 포인터, v61은 문자열 포인터. 함수명을 보면 창에 text값을 가져오는것 같다.

  if ( *(_DWORD *)(v61 - 12) == 4 ) // 문자열 객체에서 어떤 값을 참조하고 있다. 문자열의 길이로 추정..?
  {
    v4 = 0
    while ( (unsigned __int16)ATL::CSimpleStringT<wchar_t,1>::GetAt(&v61, v4) >= 0x61u
         && (unsigned __int16)ATL::CSimpleStringT<wchar_t,1>::GetAt(&v61, v4) <= 0x7Au )  // 이 범위를 확인해 보면 알파벳 소문자 범위이다. a~z
    {
      if ( ++v4 >= 4 ) // 문자열 4개를 전부 확인.
      {
LABEL_8:
        v5 = 0
        while ( 1 )
        {
          if ( v1 != v5 ) // 같은문자가 있으면 안돼! 를 의미
          {
            v6 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v61, v5) 
            if ( (unsigned __int16)ATL::CSimpleStringT<wchar_t,1>::GetAt(&v61, v1) == v6 ) 
              goto LABEL_2 // Fail 했다는 의미.
          }
          if ( ++v5 >= 4 ) // 같은문자가 있으면...
          {
            if ( ++v1 < 4 ) 
              goto LABEL_8 // ..안돼!
            CWnd::GetWindowTextW(a1 + 420, &v62) // 시리얼넘버를 받아들이는 것으로 추정됨
            if ( *(_DWORD *)(v62 - 12) != 11 || (unsigned __int16)ATL::CSimpleStringT<wchar_t,1>::GetAt(&v62, 5) != 45 ) // 시리얼넘버 길이가 11, 가운데 5번째 글자가 '-'이어야 함.
              goto LABEL_2
            v7 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v61, 0) // name[0]
            v8 = (v7 & 1) + 5
            v59 = ((v7 >> 4) & 1) + 5
            v53 = ((v7 >> 1) & 1) + 5
            v55 = ((v7 >> 2) & 1) + 5
            v57 = ((v7 >> 3) & 1) + 5
            v9 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v61, 1) // name[1]
            v45 = (v9 & 1) + 1
            v51 = ((v9 >> 4) & 1) + 1
            v47 = ((v9 >> 1) & 1) + 1
            v10 = ((v9 >> 2) & 1) + 1
            v49 = ((v9 >> 3) & 1) + 1
            v11 = (wchar_t *)ATL::CSimpleStringT<wchar_t,1>::GetBuffer(&v63) // 임시 문자열 버퍼를 가져옴.
            itow_s(v8 + v10, v11, 0xAu, 10) // v8 + v10 을 최대 10진수로 10자리까지 v11에 저장.
            v12 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v63, 0) // 문자열
            v13 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v62, 0) // 가져와서
            v2 = &v63
            if ( v13 == v12 ) // 비교. 아래도 다 똑같음!
            {
              ATL::CSimpleStringT<wchar_t,1>::ReleaseBuffer(&v63, -1) // 버퍼 free~
              v14 = (wchar_t *)ATL::CSimpleStringT<wchar_t,1>::GetBuffer(&v63)
              itow_s(v57 + v49, v14, 0xAu, 10)
              v15 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v62, 1)
              v16 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v63, 0)
              v2 = &v63
              if ( v15 == v16 )
              {
                ATL::CSimpleStringT<wchar_t,1>::ReleaseBuffer(&v63, -1)
                v17 = (wchar_t *)ATL::CSimpleStringT<wchar_t,1>::GetBuffer(&v63)
                itow_s(v53 + v51, v17, 0xAu, 10)
                v18 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v62, 2)
                v19 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v63, 0)
                v2 = &v63
                if ( v18 == v19 )
                {
                  ATL::CSimpleStringT<wchar_t,1>::ReleaseBuffer(&v63, -1)
                  v20 = (wchar_t *)ATL::CSimpleStringT<wchar_t,1>::GetBuffer(&v63)
                  itow_s(v55 + v45, v20, 0xAu, 10)
                  v21 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v62, 3)
                  v22 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v63, 0)
                  v2 = &v63
                  if ( v21 == v22 )
                  {
                    ATL::CSimpleStringT<wchar_t,1>::ReleaseBuffer(&v63, -1)
                    v23 = (wchar_t *)ATL::CSimpleStringT<wchar_t,1>::GetBuffer(&v63)
                    itow_s(v59 + v47, v23, 0xAu, 10)
                    v24 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v62, 4)
                    v25 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v63, 0)
                    v2 = &v63
                    if ( v24 == v25 )
                    {
                      ATL::CSimpleStringT<wchar_t,1>::ReleaseBuffer(&v63, -1)
                      v26 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v61, 2)
                      v27 = (v26 & 1) + 5
                      v60 = ((v26 >> 4) & 1) + 5
                      v54 = ((v26 >> 1) & 1) + 5
                      v56 = ((v26 >> 2) & 1) + 5
                      v58 = ((v26 >> 3) & 1) + 5
                      v28 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v61, 3)
                      v46 = (v28 & 1) + 1
                      v52 = ((v28 >> 4) & 1) + 1
                      v48 = ((v28 >> 1) & 1) + 1
                      v29 = ((v28 >> 2) & 1) + 1
                      v50 = ((v28 >> 3) & 1) + 1
                      v30 = (wchar_t *)ATL::CSimpleStringT<wchar_t,1>::GetBuffer(&v63)
                      itow_s(v27 + v29, v30, 0xAu, 10)
                      v31 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v62, 6)
                      v32 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v63, 0)
                      v2 = &v63
                      if ( v31 == v32 )
                      {
                        ATL::CSimpleStringT<wchar_t,1>::ReleaseBuffer(&v63, -1)
                        v33 = (wchar_t *)ATL::CSimpleStringT<wchar_t,1>::GetBuffer(&v63)
                        itow_s(v58 + v50, v33, 0xAu, 10)
                        v34 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v62, 7)
                        v35 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v63, 0)
                        v2 = &v63
                        if ( v34 == v35 )
                        {
                          ATL::CSimpleStringT<wchar_t,1>::ReleaseBuffer(&v63, -1)
                          v36 = (wchar_t *)ATL::CSimpleStringT<wchar_t,1>::GetBuffer(&v63)
                          itow_s(v54 + v52, v36, 0xAu, 10)
                          v37 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v62, 8)
                          v38 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v63, 0)
                          v2 = &v63
                          if ( v37 == v38 )
                          {
                            ATL::CSimpleStringT<wchar_t,1>::ReleaseBuffer(&v63, -1)
                            v39 = (wchar_t *)ATL::CSimpleStringT<wchar_t,1>::GetBuffer(&v63)
                            itow_s(v56 + v46, v39, 0xAu, 10)
                            v40 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v62, 9)
                            v41 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v63, 0)
                            v2 = &v63
                            if ( v40 == v41 )
                            {
                              ATL::CSimpleStringT<wchar_t,1>::ReleaseBuffer(&v63, -1)
                              v42 = (wchar_t *)ATL::CSimpleStringT<wchar_t,1>::GetBuffer(&v63)
                              itow_s(v60 + v48, v42, 0xAu, 10)
                              v43 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v62, 10)
                              v44 = ATL::CSimpleStringT<wchar_t,1>::GetAt(&v63, 0)
                              v2 = &v63
                              if ( v43 == v44 )
                              {
                                // 모든 조건 만족시 해결~
                                ATL::CSimpleStringT<wchar_t,1>::ReleaseBuffer(&v63, -1)
                                ATL::CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>::~CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>(&v63)
                                ATL::CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>::~CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>(&v62)
                                ATL::CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>::~CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>(&v61)
                                return 1
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
            goto LABEL_3
          }
        }
      }
    }
  }
LABEL_2:
  v2 = &v63
LABEL_3:
  ATL::CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>::~CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>(v2)
  ATL::CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>::~CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>(&v62)
  ATL::CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>::~CStringT<wchar_t,StrTraitMFC_DLL<wchar_t,ATL::ChTraitsCRT<wchar_t>>>(&v61)
  return 0
}
```

보기에 복잡해 보이지만, 하나하나 분석해보면 많이 어렵지는 않다.
python code를 돌려서 문제를 해결해보자

```python
serial = "7687677776"
pattern = ((1,4),(5,5),(3,2),(4,1),(2,3))
crange = []
for i in range(0x61, 0x7a):
    crange.append(i)

n = [0,0,0,ord('p')]

def f(name):
    v7 = name[0]
    v8 = (v7 & 1) + 5
    v59 = ((v7 >> 4) & 1) + 5
    v53 = ((v7 >> 1) & 1) + 5
    v55 = ((v7 >> 2) & 1) + 5
    v57 = ((v7 >> 3) & 1) + 5

    v9 = name[1]
    v45 = (v9 & 1) + 1
    v51 = ((v9 >> 4) & 1) + 1
    v47 = ((v9 >> 1) & 1) + 1
    v10 = ((v9 >> 2) & 1) + 1
    v49 = ((v9 >> 3) & 1) + 1
    
    tmp = ""
    tmp = str(v8+v10)
    if serial[0] == tmp:
        tmp = str(v57+v49)
        if serial[1] == tmp:
            tmp = str(v53+v51)
            if serial[2] == tmp:
                tmp = str(v55+v45)
                if serial[3] == tmp:
                    tmp = str(v59+v47)
                    if serial[4] == tmp:
                        v26 = name[2]

                        v27 = (v26 & 1) + 5
                        v60 = ((v26 >> 4) & 1) + 5
                        v54 = ((v26 >> 1) & 1) + 5
                        v56 = ((v26 >> 2) & 1) + 5
                        v58 = ((v26 >> 3) & 1) + 5

                        v28 = name[3]

                        v46 = (v28 & 1) + 1
                        v52 = ((v28 >> 4) & 1) + 1
                        v48 = ((v28 >> 1) & 1) + 1
                        v29 = ((v28 >> 2) & 1) + 1
                        v50 = ((v28 >> 3) & 1) + 1 

                        tmp = str(v27+v29)
                        if serial[5] == tmp:
                            tmp = str(v58+v50)
                            if serial[6] == tmp:
                                tmp = str(v54+v52)
                                if serial[7] == tmp:
                                    tmp = str(v56+v46)
                                    if serial[8] == tmp:
                                        tmp = str(v60+v48)
                                        if serial[9] == tmp:
                                            s = ""
                                            for q in name:
                                                s += chr(q)
                                            print s


for i in crange:
    if i == ord('p'):
        continue
    n[0]=i
    for j in crange:
        if j == ord('p') or j == i:
            continue
        n[1]=j
        for k in crange:
            if k == ord('p') or k == j or k == i:
                continue
            n[2]=k
            f(n)
```

실행결과
```
qqq1ppp@HKY14:~$ python position.py
플래그는
알아서들
알아내길
qqq1ppp@HKY14:~$ 
```

답이 여러개 나올수 있다 했음. 근데 답인증은 하나만 됨 ㅋㅋ
P.S. : 편집기로 바꾸끼 하다가 소스코드 안에있는 세미콜론까지 날라갔..
