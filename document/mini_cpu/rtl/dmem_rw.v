
module dmem_rw(
      input       reset,
      input       clk,
      input       ex_mem_ctrl_data_mem_ctrl_memWrite,
      input [1:0] ex_mem_ctrl_data_mem_ctrl_maskMode,
      input [31:0] ex_mem_data_result,
      input [31:0] ex_mem_data_regRData2,
      input       ex_mem_ctrl_data_mem_ctrl_memRead,
      input       ex_mem_ctrl_data_mem_ctrl_sext,

    output [31:0] dmem_addr,
    output        dmem_valid,
    output [31:0] dmem_writeData,
    output        dmem_memRead,
    output        dmem_memWrite,
    output [1:0]  dmem_maskMode,
    output        dmem_sext,
    input  [31:0] dmem_readData,
    output [31:0] dmem_readBack

  );
  

  wire  dmem_sb_sh = ex_mem_ctrl_data_mem_ctrl_memWrite & (ex_mem_ctrl_data_mem_ctrl_maskMode == 2'h0 |
                     ex_mem_ctrl_data_mem_ctrl_maskMode == 2'h1); 

  wire [31:0] dmem_writeData_w = dmem_sb_sh ? 32'h0 : ex_mem_data_regRData2; 
  wire        dmem_memWrite_w = dmem_sb_sh ? 1'h0 : ex_mem_ctrl_data_mem_ctrl_memWrite; 
  wire [1:0]  dmem_maskMode_w = dmem_sb_sh ? 2'h2 : ex_mem_ctrl_data_mem_ctrl_maskMode; 

  reg        dmem_sb_sh_tmp; 
  reg [31:0] dmem_addr_tmp; 
  reg [31:0] dmem_writeData_tmp; 
  reg        dmem_memWrite_tmp; 
  reg [1:0]  dmem_maskMode_tmp;
  reg        dmem_sext_tmp; 
  reg [31:0] dmem_readData_tmp; 

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      dmem_sb_sh_tmp <= 1'h0; 
    end else begin
      dmem_sb_sh_tmp <= dmem_sb_sh; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      dmem_addr_tmp      <= 32'h0; 
      dmem_writeData_tmp <= 32'h0; 
      dmem_memWrite_tmp <= 1'b0; 
      dmem_maskMode_tmp <= 2'b0;
      dmem_sext_tmp     <= 1'b0; 
      dmem_readData_tmp <= 32'h0; 
    end else begin
      dmem_addr_tmp <= ex_mem_data_result; 
      dmem_writeData_tmp <= ex_mem_data_regRData2; 
      dmem_memWrite_tmp <= ex_mem_ctrl_data_mem_ctrl_memWrite; 
      dmem_maskMode_tmp <= ex_mem_ctrl_data_mem_ctrl_maskMode;
      dmem_sext_tmp <= ex_mem_ctrl_data_mem_ctrl_sext; 
      dmem_readData_tmp <= dmem_readData; 
    end
  end

  assign dmem_addr = dmem_sb_sh_tmp ? dmem_addr_tmp : ex_mem_data_result;
  assign dmem_valid = dmem_sb_sh_tmp | (dmem_memRead | dmem_memWrite);
  assign dmem_writeData = dmem_sb_sh_tmp ? dmem_writeData_tmp : dmem_writeData_w; 
  assign dmem_memRead = dmem_sb_sh_tmp ? 1'h0 : dmem_sb_sh | ex_mem_ctrl_data_mem_ctrl_memRead; 
  assign dmem_memWrite = dmem_sb_sh_tmp ? dmem_memWrite_tmp : dmem_memWrite_w;
  assign dmem_maskMode = dmem_sb_sh_tmp ? dmem_maskMode_tmp : dmem_maskMode_w; 
  assign dmem_sext = dmem_sb_sh_tmp ? dmem_sext_tmp : dmem_sb_sh | ex_mem_ctrl_data_mem_ctrl_sext; 
  assign dmem_readBack = dmem_sb_sh_tmp ? dmem_readData_tmp : 32'hffffffff; 

endmodule