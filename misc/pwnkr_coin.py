from pwn import *

def f(x, y):
    ttts = ""
    if(x==y):
        return str(x)+" "
    for i in range(x, y):
        ttts+=str(i)+" "
    return ttts

def bs(x, y, sock):     # no exception filtering cause..there will be no exception in normal situation
    tsts=f(x,x+(y-x)/2)
    sock.sendline(tsts)
    temps=sock.recvline()
    if(temps.find("Correct") >= 0):
        return
    elif int(temps) == 9:
        bs(x,y,sock)
    elif int(temps)%10 != 0:
        bs(x, x+(y-x)/2, sock) # search for 'this' half
    else:
        bs(x+(y-x)/2, y, sock) # search for another half

conn = remote("pwnable.kr", 9007)

for i in range(31):
    print(conn.recvline())

for i in range(100):
    print "[+]loop {0}".format(i)
    s = conn.recvline().split(" ")
    n = int(s[0].split('=')[1])
    c = int(s[1].split('=')[1])

    bs(0, n, conn)
    if(i==99):
        print conn.recvline()
        print "flag : {0}".format(conn.recvline())
