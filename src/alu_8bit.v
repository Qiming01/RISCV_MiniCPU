// 8bit的alu
// a 和 b 是输入的两个 8 位二进制数
// cin 是 a 和 b 做加法运算时输入的进位值
// 4bit 位宽的 aluop[3:0] 则是 CPU 中通常所说的指令操作码。
module alu_8bit(a, b, cin, aluop, y);
  input [7:0] a, b;
  input cin;
  input [3:0] aluop;
  output [7:0] y;

  reg [7:0] y;
  reg [7:0] arithval;
  reg [7:0] logicval;

  // 算术执行单元
  // ALU 模块是组合逻辑，所以 always 块中使用阻塞赋值“=”
  // 运算单元是根据输入指令的低三位 sel[2:0]，来选择执行加减等运算。
  always @(a or b or cin or aluop) begin
    case (aluop[2:0])
      3'b000  : arithval = a;
      3'b001  : arithval = a + 1;
      3'b010  : arithval = a - 1;
      3'b011  : arithval = b;
      3'b100  : arithval = b + 1;
      3'b101  : arithval = b - 1;
      3'b110  : arithval = a + b;
      default : arithval = a + b + cin;
    endcase
  end

  // 逻辑处理单元
  always @(a or b or aluop) begin
    case (aluop[2:0])
      3'b000  : logicval =  ~a;
      3'b001  : logicval =  ~b;
      3'b010  : logicval = a & b;
      3'b011  : logicval = a | b;
      3'b100  : logicval =  ~((a & b));
      3'b101  : logicval =  ~((a | b));
      3'b110  : logicval = a ^ b;
      default : logicval =  ~(a ^ b);
    endcase
  end

  // 输出选择单元
  // 根据指令的最高位 sel[3]，来选择 Y 输出的是加减运算单元结果，还是逻辑处理的结果。
  always @(arithval or logicval or aluop) begin
    case (aluop[3])
      1'b0    : y = arithval;
      default : y = logicval;
    endcase
  end

endmodule