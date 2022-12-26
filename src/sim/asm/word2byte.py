#!/usr/bin/python3
import os

fin = open("./sim/asm/build/miniCPU_sim.hex","r")
fout = open("./sim/asm/build/test.dat","w")

datrow = ["0"]*5
num_row = 0

for lines in fin.readlines():
    if(lines[0]=="@"):
        fout.writelines( lines )
        continue
    else:
        #line = lines.replace("\n", "")
        line = lines.split()
        for i in range(len(line)):
          #  print(i)
            num_row = i+1
            # if(line[i]=="\n"):
            #     print( datrow )
            #     continue
            if((num_row%4!=0)):
                datrow[4-num_row%4] = line[i]
            else:
                if((num_row%4 == 0) ):  
                    datrow[0] = line[i]
                    datrow[4] = "\n"
                    print( datrow )
                    fout.writelines( datrow )
                    num_row =0
                else:
                    continue

fin.close()
fout.close()