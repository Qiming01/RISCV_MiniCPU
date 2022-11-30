# Test the RISC-V processor in simulation
#
#
#		Assembly                Description

main:   
        li      x2, 0x20000000          # uart address
        li      x6,  0x1500             #x6 <== 0x1500, delay 1ms
        addi    x7, x0, 0               #x7 <== 0

        addi    x5, x0, 0x48            #x5 <== "H"
        sw      x5, 0(x2)  

delay1: addi    x7, x7, 1               #x7 <== x7 + 1
        bne     x7, x6, delay1          #x6 != x7 
        addi    x7, x0, 0               #x7 <== 0
        addi    x5, x0, 0x65            #x5 <== "e"
        sw      x5, 0(x2)  

delay2: addi    x7, x7, 1               #x7 <== x7 + 1
        bne     x7, x6, delay2           #x6 != x7
        addi    x7, x0, 0               #x7 <== 0
        addi    x5, x0, 0x6c            #x5 <== "l"
        sw      x5, 0(x2) 

delay3: addi    x7, x7, 1               #x7 <== x7 + 1
        bne     x7, x6, delay3           #x6 != x7
        addi    x7, x0, 0               #x7 <== 0
        addi    x5, x0, 0x6c            #x5 <== "l"
        sw      x5, 0(x2)  

delay4: addi    x7, x7, 1               #x7 <== x7 + 1
        bne     x7, x6, delay4           #x6 != x7
        addi    x7, x0, 0               #x7 <== 0
        addi    x5, x0, 0x6f            #x5 <== "o"
        sw      x5, 0(x2)  

delay5: addi    x7, x7, 1               #x7 <== x7 + 1
        bne     x7, x6, delay5           #x6 != x7
        addi    x7, x0, 0               #x7 <== 0
        addi    x5, x0, 0x00            #x5 <== " "
        sw      x5, 0(x2) 

delay6: addi    x7, x7, 1               #x7 <== x7 + 1
        bne     x7, x6, delay6          #x6 != x7 
        addi    x7, x0, 0               #x7 <== 0
        addi    x5, x0, 0x4d            #x5 <== "M"
        sw      x5, 0(x2)  

delay7: addi    x7, x7, 1               #x7 <== x7 + 1
        bne     x7, x6, delay7           #x6 != x7
        addi    x7, x0, 0               #x7 <== 0
        addi    x5, x0, 0x69            #x5 <== "i"
        sw      x5, 0(x2) 

delay8: addi    x7, x7, 1               #x7 <== x7 + 1
        bne     x7, x6, delay8           #x6 != x7
        addi    x7, x0, 0               #x7 <== 0
        addi    x5, x0, 0x6e            #x5 <== "n"
        sw      x5, 0(x2) 

delay9: addi    x7, x7, 1               #x7 <== x7 + 1
        bne     x7, x6, delay9           #x6 != x7
        addi    x7, x0, 0               #x7 <== 0
        addi    x5, x0, 0x69            #x5 <== "i"
        sw      x5, 0(x2) 

delay10: addi    x7, x7, 1               #x7 <== x7 + 1
        bne     x7, x6, delay10           #x6 != x7
        addi    x7, x0, 0               #x7 <== 0
        addi    x5, x0, 0x43            #x5 <== "C"
        sw      x5, 0(x2)  

delay11: addi    x7, x7, 1               #x7 <== x7 + 1
        bne     x7, x6, delay11           #x6 != x7
        addi    x7, x0, 0               #x7 <== 0
        addi    x5, x0, 0x50            #x5 <== "P"
        sw      x5, 0(x2)  

delay12: addi    x7, x7, 1               #x7 <== x7 + 1
        bne     x7, x6, delay12           #x6 != x7
        addi    x7, x0, 0               #x7 <== 0
        addi    x5, x0, 0x55            #x5 <== "U"
        sw      x5, 0(x2) 

delay13: addi    x7, x7, 1               #x7 <== x7 + 1
        bne     x7, x6, delay13           #x6 != x7
        addi    x7, x0, 0               #x7 <== 0
        addi    x5, x0, 0x21            #x5 <== "!"
        sw      x5, 0(x2) 

end:    j       end

        ret