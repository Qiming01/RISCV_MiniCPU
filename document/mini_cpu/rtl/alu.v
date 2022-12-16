
module alu (
  input  [31:0] alu_data1_i,// 源操作数1
  input  [31:0] alu_data2_i,// 源操作数2
  input  [ 3:0] alu_op_i,// 控制模块产生的alu运算控制码J
  output [31:0] alu_result_o// 输出alu运算产生的结果
);

  reg  [31:0] result;
  // sum：两个源操作数的和，当aluop第三位或第一位为1时相减运算
  wire [31:0] sum    = alu_data1_i + ((alu_op_i[3] | alu_op_i[1]) ? -alu_data2_i : alu_data2_i);
  // neq：表示两个操作数是否相等，是sum的运算结果得出的，若sum=0则neq=1
  wire        neq    = |sum;
  // cmp：两个操作数的大小比较，
  // 如果他们的最高位（符号位）相等，则根据sum的符号位判断
  // 若sum正数，源操作数1大于源操作数2
  // 若最高位不等，根据aluop的最低位判断两者是有符号数比较还是无符号数比较
  // aluop最低位为1：无符号数比较，最高位1，0：1大，以0作为结果;0,1:2大，以1为结果。即可以拿操作数2的最高位作为结果
  // aluop最低位为0：有符号数比较，直接取操作数1的最高位作为结果
  wire        cmp    = (alu_data1_i[31] == alu_data2_i[31]) ? sum[31]
                     : alu_op_i[0] ? alu_data2_i[31] : alu_data1_i[31];
  // shamt：取自源操作数2的第五位，表示源操作数1需要移多少位。2^5=32
  wire [ 4:0] shamt  = alu_data2_i[4:0];
  // shin：取出要移位的数值，根据aluop判断左移还是右移，若右移直接等于源操作数1，左移就对操作数各个位数做镜像处理，转化为右移处理
  wire [31:0] shin   = alu_op_i[2] ? alu_data1_i : reverse(alu_data1_i);
  // shift：根据aluop判断是算数右移还是逻辑右移，如果是算数右移，则在最高位补充一个符号位；
  wire [32:0] shift  = {alu_op_i[3] & shin[31], shin};
  // shiftt：右移之后的结果，$signed作用是 决定如何对操作数扩位
  // 在右移操作前，$signed() 函数先把操作数的符号位，扩位成跟结果相同的位宽，然后再进行移位操作
  wire [32:0] shiftt = ($signed(shift) >>> shamt);
  // shirtr：移位的结果
  wire [31:0] shiftr = shiftt[31:0];
  // 如果是左移再翻转回来
  wire [31:0] shiftl = reverse(shiftr);

  always @(*) begin
    case(alu_op_i)
      `ALU_OP_ADD:    result <= sum;
      `ALU_OP_SUB:    result <= sum;
      `ALU_OP_SLL:    result <= shiftl;
      `ALU_OP_SLT:    result <= cmp;
      `ALU_OP_SLTU:   result <= cmp;
      `ALU_OP_XOR:    result <= (alu_data1_i ^ alu_data2_i);
      `ALU_OP_SRL:    result <= shiftr;
      `ALU_OP_SRA:    result <= shiftr;
      `ALU_OP_OR:     result <= (alu_data1_i | alu_data2_i);
      `ALU_OP_AND:    result <= (alu_data1_i & alu_data2_i);

      `ALU_OP_EQ:     result <= {31'b0, ~neq};
      `ALU_OP_NEQ:    result <= {31'b0, neq};
      `ALU_OP_GE:     result <= {31'b0, ~cmp};
      `ALU_OP_GEU:    result <= {31'b0, ~cmp};
      default:        begin 
                      result <= 32'b0; 
                      //$display("*** alu error ! ***%x", alu_op_i); 
        end
    endcase
  end

  // 用于左移的各个位的翻转
  function [31:0] reverse;
    input [31:0] in;
    integer i;
    for(i=0; i<32; i=i+1) begin
      reverse[i] = in[31-i];
    end
  endfunction  

  assign alu_result_o = result;

endmodule