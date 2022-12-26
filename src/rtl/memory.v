// 实现RAM功能
// 使用了时钟信号 clk，说明这里的 dmem 实现的是一个时钟同步 RAM。而且当写使能信号（we）为“1”时，才能往 RAM 里写数据，否则只能读取数据。
module dmem (
    input [11:0] addr,
    input we,
    input [31:0] din,
    input clk,

    output reg [31:0] dout
);
  reg [31:0] dmem_reg[0:4095];

  always @(posedge clk) begin
    if (we) begin
      dmem_reg[addr] <= din;
    end
    dout <= dmem_reg[addr];
  end
endmodule

// 实现ROM功能
module imem (
    input  [11:0] addr1,
    output [31:0] imem_o1,
    input  [11:0] addr2,
    output [31:0] imem_o2
);
  // 使用寄存器reg类型临时定义了一个指令存储器
  // 在仿真的顶层（tb_top.v）使用了 $readmemh（）函数，
  // 把编译好的二进制指令读入到 imem 中，以便 CPU 内部读取并执行这些指令。
  // 这里我们设置的存储器在功能上是只读的。

  reg [31:0] imem_reg[0:4096];

  assign imem_o1 = imem_reg[addr1];
  assign imem_o2 = imem_reg[addr2];

endmodule
