
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