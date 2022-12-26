SOURCE_TB := ./tb/tb_top.v
TMP_DIR := ./tmp
SOURCE := ./rtl.f
TARGET := ${TMP_DIR}/tb_top.o

TEST_HEX := ./sim/asm/build/test.dat


# 编译汇编程序，输出二进制指令
asm:
	make -C ./sim/asm 
	python ./sim/asm/word2byte.py

# 对CPU进行仿真
cpu:
	rm -f ${TMP_DIR}/*
	cp ${SOURCE_TB} ${TMP_DIR}
	sed -i 's#.hex#${TEST_HEX}#' ${TMP_DIR}/tb_top.v
	iverilog -f ${SOURCE} -o ${TARGET}
	vvp ${TARGET}

# 查看波形
wave:
	gtkwave ${TMP_DIR}/tb_top.vcd &

# 清除临时文件
clean:
	make -C ./sim/asm clean
	rm ./tmp/* -rf
