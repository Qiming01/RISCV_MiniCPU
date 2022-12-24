# Test the RISC-V processor in simulation
#
#
#		Assembly                Description

main:   
        li x9,0x0a      # n
        li x1,1         # a=1;
        li x2,1         # b=1;
        li x3,0         # c=0;
        li x4,2         # i=2;
        li x6,2         # to check x9
        ble x9,x6,cond1 # if n <= 2:   goto cond1

head:
        add x3,x1,x2    # c=a+b;
        add x1,x2,x0    # a=b;
        add x2,x3,x0    # b=c;
        addi x4,x4,0x01 # i+=1;
        blt x4,x9,head  # if i < n:     goto head
        add x7,x2,x0    # b->x7
        j       end

cond1:
        li x7,1

end:    add x7,x7,x0
        j       end

        ret
