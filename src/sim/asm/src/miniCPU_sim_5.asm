
main:
        li      x2, 0x10000000          # 10000137
        li      x1, 0x100               # 10000093
        li      x3, 0x10                # 01000193
        sw      x1, 0(x2)               # 00112023
        lw      x1, 0(x2)               # 00012083
        sub     x4, x1, x3              # 40308233

end:    j       end                     # 0000006F
        ret                             # 00008067
