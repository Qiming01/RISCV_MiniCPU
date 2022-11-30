
module pre_if (
    input [31:0] instr,
    input [31:0] pc,

    output [31:0] pre_pc
);

    wire is_bxx = (instr[6:0] == `OPCODE_BRANCH);   //条件挑转指令的操作码
    wire is_jal = (instr[6:0] == `OPCODE_JAL) ;     //无条件跳转指令的操作码
    
    //B型指令的立即数拼接
    wire [31:0] bimm  = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
    //J型指令的立即数拼接
    wire [31:0] jimm  = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};

    //指令地址的偏移量
    wire [31:0] adder = is_jal ? jimm : (is_bxx & bimm[31]) ? bimm : 4;
    assign pre_pc = pc + adder;

endmodule