/**
* 译码数据通路模块
* 译码数据通路模块会根据 CPU 相关控制模块产生的流水线冲刷控制信号，决定要不要把这些数据发送给后续模块
*/
module id_ex(
  input         clk,
  input         reset,
  input  [4:0]  in_rd_addr,
  input  [6:0]  in_funct7,
  input  [2:0]  in_funct3,
  input  [31:0] in_imm,
  input  [31:0] in_rs2_data,
  input  [31:0] in_rs1_data,
  input  [31:0] in_pc,
  input  [4:0]  in_rs1_addr,
  input  [4:0]  in_rs2_addr,
  input         flush,
  input         valid,
  output [4:0]  out_rd_addr,
  output [6:0]  out_funct7,
  output [2:0]  out_funct3,
  output [31:0] out_imm,
  output [31:0] out_rs2_data,
  output [31:0] out_rs1_data,
  output [31:0] out_pc,
  output [4:0]  out_rs1_addr,
  output [4:0]  out_rs2_addr
);
  reg [4:0] reg_rd_addr; 
  reg [6:0] reg_funct7; 
  reg [2:0] reg_funct3; 
  reg [31:0] reg_imm; 
  reg [31:0] reg_rs2_data; 
  reg [31:0] reg_rs1_data; 
  reg [31:0] reg_pc; 
  reg [4:0] reg_rs1_addr; 
  reg [4:0] reg_rs2_addr; 

  assign out_rd_addr = reg_rd_addr; 
  assign out_funct7 = reg_funct7; 
  assign out_funct3 = reg_funct3; 
  assign out_imm = reg_imm; 
  assign out_rs2_data = reg_rs2_data; 
  assign out_rs1_data = reg_rs1_data; 
  assign out_pc = reg_pc; 
  assign out_rs1_addr = reg_rs1_addr; 
  assign out_rs2_addr = reg_rs2_addr; 

  // 以目标寄存器的索引地址reg_rd_addr信号为例
  // 当流水线冲刷信号flush有效时
  // 目标寄存器的索引地址reg_rd_addr直接清0
  // 否则当信号有效标志valid为1时，把目标寄存器的索引地址传递给流水线的下一级
  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_rd_addr <= 5'h0; 
    end else if (flush) begin 
      reg_rd_addr <= 5'h0; 
    end else if (valid) begin 
      reg_rd_addr <= in_rd_addr; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_funct7 <= 7'h0; 
    end else if (flush) begin 
      reg_funct7 <= 7'h0; 
    end else if (valid) begin 
      reg_funct7 <= in_funct7; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_funct3 <= 3'h0; 
    end else if (flush) begin 
      reg_funct3 <= 3'h0; 
    end else if (valid) begin 
      reg_funct3 <= in_funct3; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_imm <= 32'h0; 
    end else if (flush) begin 
      reg_imm <= 32'h0; 
    end else if (valid) begin 
      reg_imm <= in_imm; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_rs2_data <= 32'h0; 
    end else if (flush) begin 
      reg_rs2_data <= 32'h0; 
    end else if (valid) begin 
      reg_rs2_data <= in_rs2_data; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_rs1_data <= 32'h0; 
    end else if (flush) begin 
      reg_rs1_data <= 32'h0; 
    end else if (valid) begin 
      reg_rs1_data <= in_rs1_data; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_pc <= 32'h0; 
    end else if (flush) begin 
      reg_pc <= 32'h0; 
    end else if (valid) begin 
      reg_pc <= in_pc; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_rs1_addr <= 5'h0; 
    end else if (flush) begin 
      reg_rs1_addr <= 5'h0; 
    end else if (valid) begin 
      reg_rs1_addr <= in_rs1_addr; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_rs2_addr <= 5'h0; 
    end else if (flush) begin 
      reg_rs2_addr <= 5'h0; 
    end else if (valid) begin 
      reg_rs2_addr <= in_rs2_addr; 
    end
  end

endmodule