
module forwarding (
  input [4:0] rs1,
  input [4:0] rs2,
  input [4:0] exMemRd,
  input       exMemRw,
  input [4:0] memWBRd,
  input       memWBRw,

  input        mem_wb_ctrl_data_toReg,
  input [31:0] mem_wb_readData,
  input [31:0] mem_wb_data_result,
  input [31:0] id_ex_data_regRData1,
  input [31:0] id_ex_data_regRData2,
  input [31:0] ex_mem_data_result,

  output [31:0] forward_rs1_data,
  output [31:0] forward_rs2_data
);

  wire [1:0] forward_rs1_sel = (exMemRw & (rs1 == exMemRd) & (exMemRd != 5'b0)) ? 2'b01
                              :(memWBRw & (rs1 == memWBRd) & (memWBRd != 5'b0)) ? 2'b10
                              : 2'b00;
                  
  wire [1:0] forward_rs2_sel = (exMemRw & (rs2 == exMemRd) & (exMemRd != 5'b0)) ? 2'b01
                              :(memWBRw & (rs2 == memWBRd) & (memWBRd != 5'b0)) ? 2'b10
                              : 2'b00;

  wire [31:0] regWData = mem_wb_ctrl_data_toReg ? mem_wb_readData : mem_wb_data_result; 

  assign forward_rs1_data = (forward_rs1_sel == 2'b00) ? id_ex_data_regRData1 :
                            (forward_rs1_sel == 2'b01) ? ex_mem_data_result   :
                            (forward_rs1_sel == 2'b10) ? regWData : 32'h0; 

  assign forward_rs2_data = (forward_rs2_sel == 2'b00) ? id_ex_data_regRData2 :
                            (forward_rs2_sel == 2'b01) ? ex_mem_data_result   :
                            (forward_rs2_sel == 2'b10) ? regWData : 32'h0; 
endmodule