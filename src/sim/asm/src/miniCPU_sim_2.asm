# Test the RISC-V processor in simulation
#
#
#		Assembly                Description

main:   
        xor x1,x1,x1
        xor x2,x2,x2
        addi x1,x0,0x100
        add x2,x1,x0
        bne x1,x2,end
        li x2,0x20000000
        addi x7,x0,0
        addi x7,x7,1
        addi x5,x0,0x43
        sw x5,0(x2)
        addi x2,x0,1
        addi x1,x0,0
        addi x3,x0,0x10
        beq x2,x7,loop
loop:
        addi x1,x1,1
        bne x3,x1,loop

end:    j       end

        ret
