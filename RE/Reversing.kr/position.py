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
