
module ex_mem_ctrl(
  input        clk,
  input        reset,
  input        in_mem_ctrl_memRead,   //memory读控制信号
  input        in_mem_ctrl_memWrite,  //memory写控制信号
  input  [1:0] in_mem_ctrl_maskMode,  //mask模式选择
  input        in_mem_ctrl_sext,      //符合扩展
  input        in_wb_ctrl_toReg,      //写回寄存器的数据选择，“1”时为mem读取的数据
  input        in_wb_ctrl_regWrite,   //寄存器写控制信号
  input        flush,                 //流水线数据冲刷信号
  output       out_mem_ctrl_memRead,
  output       out_mem_ctrl_memWrite,
  output [1:0] out_mem_ctrl_maskMode,
  output       out_mem_ctrl_sext,
  output       out_wb_ctrl_toReg,
  output       out_wb_ctrl_regWrite
);

  reg  reg_mem_ctrl_memRead; 
  reg  reg_mem_ctrl_memWrite; 
  reg [1:0] reg_mem_ctrl_maskMode; 
  reg  reg_mem_ctrl_sext; 
  reg  reg_wb_ctrl_toReg; 
  reg  reg_wb_ctrl_regWrite; 

  assign out_mem_ctrl_memRead = reg_mem_ctrl_memRead; 
  assign out_mem_ctrl_memWrite = reg_mem_ctrl_memWrite; 
  assign out_mem_ctrl_maskMode = reg_mem_ctrl_maskMode; 
  assign out_mem_ctrl_sext = reg_mem_ctrl_sext; 
  assign out_wb_ctrl_toReg = reg_wb_ctrl_toReg; 
  assign out_wb_ctrl_regWrite = reg_wb_ctrl_regWrite; 
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_mem_ctrl_memRead <= 1'h0; 
    end else if (flush) begin 
      reg_mem_ctrl_memRead <= 1'h0; 
    end else begin 
      reg_mem_ctrl_memRead <= in_mem_ctrl_memRead; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_mem_ctrl_memWrite <= 1'h0; 
    end else if (flush) begin 
      reg_mem_ctrl_memWrite <= 1'h0; 
    end else begin 
      reg_mem_ctrl_memWrite <= in_mem_ctrl_memWrite; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_mem_ctrl_maskMode <= 2'h0; 
    end else if (flush) begin 
      reg_mem_ctrl_maskMode <= 2'h0; 
    end else begin 
      reg_mem_ctrl_maskMode <= in_mem_ctrl_maskMode; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_mem_ctrl_sext <= 1'h0; 
    end else if (flush) begin 
      reg_mem_ctrl_sext <= 1'h0; 
    end else begin 
      reg_mem_ctrl_sext <= in_mem_ctrl_sext; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_wb_ctrl_toReg <= 1'h0; 
    end else if (flush) begin 
      reg_wb_ctrl_toReg <= 1'h0; 
    end else begin 
      reg_wb_ctrl_toReg <= in_wb_ctrl_toReg; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_wb_ctrl_regWrite <= 1'h0; 
    end else if (flush) begin 
      reg_wb_ctrl_regWrite <= 1'h0; 
    end else begin 
      reg_wb_ctrl_regWrite <= in_wb_ctrl_regWrite; 
    end
  end

endmodule