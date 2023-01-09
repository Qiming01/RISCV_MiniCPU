
main:
        addi x9,x0,0x0A      # n
        li x1,1         # a=1;
        li x2,1         # b=1;
        li x3,0         # c=0;
        li x4,2         # i=2;
        li x6,2         # to check x9
        ble x9,x6,cond  # if n <= 2:   goto cond

loop:
        add x3,x1,x2    # c=a+b;
        add x1,x2,x0    # a=b;
        add x2,x3,x0    # b=c;
        addi x4,x4,1    # i+=1;
        beq x4,x9,cond
        j       loop  # if i < n:     goto loop



cond:   add x7,x2,x0
end:    add x7,x7,x0
        j       end
        ret
