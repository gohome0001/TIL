# magic with bash script!

for `pwnable.kr - cmd3`

[reference](http://alkalinesecurity.com/blog/ctf-writeups/pwnable-challenge-cmd3/)

---

`__=$((($$/$$)))` : puts 1 in var `$__`
`___=$({.,.})` : array with two periods.
`____=${___[@]}` : array to string `. .`
`_____=${____:__:__}` : slice string as length 1, index 1. it would be space character

