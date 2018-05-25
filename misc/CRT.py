
def xgcd(b, a):         # extended euclidean alg.
    x0, x1, y0, y1 = 1, 0, 0, 1
    while a != 0:
        q, b, a = b // a, a, b % a
        x0, x1 = x1, x0 - q * x1
        y0, y1 = y1, y0 - q * y1
    return  b, x0, y0   # gcd(a,b) = ax+by = b 


def mod_inverse(a,m):
    g, x, y = xgcd(a,m)
    if g == 1:
        return (x,y)
    else:
        return None

def CRT(ml, rl):         # Chinese Remainder Theorem
    m = 1
    for i in ml:
        m *= i
    r = 0
    for i in range(len(ml)):
        r += (mod_inverse(m/ml[i], ml[i])[0] * m/ml[i] * rl[i])
    return (r % m , m)      # root + m*k

if __name__ == '__main__':
    rl = [2,3,2]
    ml = [3,5,7]
    print CRT(ml,rl)
