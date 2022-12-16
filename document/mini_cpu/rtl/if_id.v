/**
* IF_ID
* 
*/
module if_id(           
  input         clk,
  input         reset,
  input  [31:0] in_instr,
  input  [31:0] in_pc,
  input         flush,
  input         valid,
  output [31:0] out_instr,
  output [31:0] out_pc,
  output        out_noflush
);

  reg [31:0] reg_instr; 
  reg [31:0] reg_pc; 
  reg [31:0] reg_pc_next; 
  reg        reg_noflush; 

  assign out_instr = reg_instr; 
  assign out_pc = reg_pc; 
  assign out_noflush = reg_noflush; 

  // 指令传递
  // 如果流水线没有发生冲突，也就是没有发出清除信号 flush，则把预读取的指令保存，否则把指令清“0”
  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_instr <= 32'h0; 
    end else if (flush) begin 
      reg_instr <= 32'h0; 
    end else if (valid) begin 
      reg_instr <= in_instr; 
    end
  end

  // PC值转递
  // 更新 PC 值，如果指令清除信号 flush=“0”，则把当前指令对应的 PC 值保存为 reg_pc，否则就把 reg_pc 清“0”
  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_pc <= 32'h0; 
    end else if (flush) begin 
      reg_pc <= 32'h0; 
    end else if (valid) begin 
      reg_pc <= in_pc; 
    end
  end

  // 流水线冲刷标志位
  // 当需要进行流水线冲刷时，reg_noflush=“0”，否则 reg_noflush=“1”。
  always @(posedge clk or posedge reset) begin  
    if (reset) begin 
      reg_noflush <= 1'h0; 
    end else if (flush) begin 
      reg_noflush <= 1'h0; 
    end else if (valid) begin 
      reg_noflush <= 1'h1; 
    end

  end

endmodule
