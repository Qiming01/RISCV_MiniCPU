/**
* 分支预测或者预读取模块
* 不管指令是否跳转，都提前把跳转之后的下一条指令从存储器中读取出来，以备流水线的下一阶段使用，这就提高了 CPU 的执行效率。
* 输入：当前pc的值和指令的内容
* 输出：预测的下一条指令的地址
*/
module pre_if (
    input [31:0] instr,
    input [31:0] pc,

    output [31:0] pre_pc
);

    // 根据指令的低7位操作码，判断是否是条件跳转指令或者是无条件跳转指令
    // 条件跳转指令的操作码，也就是指令中的低 7 位数都是 7’b1100011
    wire is_bxx = (instr[6:0] == `OPCODE_BRANCH);   // 条件挑转指令的操作码
    wire is_jal = (instr[6:0] == `OPCODE_JAL) ;     // 无条件跳转指令的操作码
    
    // 根据条件跳转指令的格式，对指令中的立即数进行拼接，为指令跳转时的 PC 提供偏移量。
    //B型指令的立即数拼接
    wire [31:0] bimm  = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
    //J型指令的立即数拼接
    wire [31:0] jimm  = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};

    //指令地址的偏移量
    // 预读取电路会根据当前的 PC 值和指令的偏移量相加，得到预测的 PC 值
    wire [31:0] adder = is_jal ? jimm : (is_bxx & bimm[31]) ? bimm : 4;
    assign pre_pc = pc + adder;

endmodule