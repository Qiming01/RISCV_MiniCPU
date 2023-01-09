init:
        li      x1, 0xfffffff
        li      x3, 0xffffffff
        li      x5, 64
        li      x6, 0x1fffffff


main:
        sub     x2 , x1, x3
        and     x12, x2, x5
        or      x13, x6, x2
        and     x14, x2, x2
        sw      x15, 100(x2)

end:    j       end
        ret
