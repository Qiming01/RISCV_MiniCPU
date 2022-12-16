// 写回数据通路模块
// 写回数据通路模块产生的信号主要包括写回目标寄存器的地址 reg_WAddr，流水线执行运算后的结果数据 result，从存储器读取的数据 readData
/*
写回阶段的模块没有了流水线的停止控制信号 stall 和流水线的冲刷控制信号 flush。这是因为写回阶段的数据经过了数据冒险和控制冒险模块的处理，已经可以确保流水线产生的结果无误了，所以写回阶段的数据不受停止信号 stall 和清零信号 flush 的控制
*/
module mem_wb(
  input         clk,
  input         reset,
  input  [4:0]  in_regWAddr,
  input  [31:0] in_result,
  input  [31:0] in_readData,
  input  [31:0] in_pc,

  output [4:0]  data_regWAddr,
  output [31:0] data_result,
  output [31:0] data_readData,
  output [31:0] data_pc
);

  reg [4:0]  reg_regWAddr; 
  reg [31:0] reg_result; 
  reg [31:0] reg_readData; 
  reg [31:0] reg_pc; 

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_regWAddr <= 5'h0; 
    end else  begin 
      reg_regWAddr <= in_regWAddr; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_result <= 32'h0; 
    end else begin 
      reg_result <= in_result; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_readData <= 32'h0; 
    end else begin 
      reg_readData <= in_readData; 
    end
  end

  always @(posedge clk or posedge reset) begin    
    if (reset) begin 
      reg_pc <= 32'h0; 
    end else  begin 
      reg_pc <= in_pc; 
    end
  end

  assign data_regWAddr = reg_regWAddr; 
  assign data_result = reg_result; 
  assign data_readData = reg_readData; 
  assign data_pc = reg_pc; 

endmodule