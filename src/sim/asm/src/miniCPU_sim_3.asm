# Test the RISC-V processor in simulation
#
#
#		Assembly                Description

main:   
        addi x1,x0,0x100
        addi x2,x0,0x200
        blt x2,x1,return
        addi x3,x0,0x05
        sll x1,x1,x3
        beq x2,x1,return
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        bne x2,x1,return
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
        addi x3,x3,1
end:
        j       end

return:
        ret
