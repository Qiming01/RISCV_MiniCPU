
module forwarding (
  // 前递模块输入的端口rs1和rs2，来自于指令译码后得到的两个通用寄存器索引
  input [4:0] rs1,
  input [4:0] rs2,
  input [4:0] exMemRd,// 来自访存模块对通用寄存器的访问地址
  input       exMemRw,// 流水线访存阶段对通用寄存器的写使能控制信号
  input [4:0] memWBRd,// 写回模块对通用寄存器的地址
  input       memWBRw,// 写回的使能控制信号

  input        mem_wb_ctrl_data_toReg,
  input [31:0] mem_wb_readData,
  input [31:0] mem_wb_data_result,
  
  // 流水线不发生数据冒险时，流水线正常选择的数据通路
  input [31:0] id_ex_data_regRData1,
  input [31:0] id_ex_data_regRData2,
  
  // 访存阶段需要写到通用寄存器的数据
  input [31:0] ex_mem_data_result,

  // 输出：
  output [31:0] forward_rs1_data,
  output [31:0] forward_rs2_data
);

  // 检查是否发生数据冒险
  // 当需要读取的通用寄存器的地址等于访存，或者写回阶段要访问通用寄存器地址时（也就是 rs1 == exMemRd 和 rs1 == memWBRd），就判断为将要发生数据冒险。
  // 由于通用寄存器中的零寄存器的值永远为“0”，所以不会发生数据冒险，需要排除掉这种特殊情况（也就是 exMemRd != 5’b0 和 memWBRd != 5’b0）。
  // 根据这样的判断结果，就会产生前递数据的两个选择信号 forward_rs1_sel 和 forward_rs2_sel。
  wire [1:0] forward_rs1_sel = (exMemRw & (rs1 == exMemRd) & (exMemRd != 5'b0)) ? 2'b01
                              :(memWBRw & (rs1 == memWBRd) & (memWBRd != 5'b0)) ? 2'b10
                              : 2'b00;
                  
  wire [1:0] forward_rs2_sel = (exMemRw & (rs2 == exMemRd) & (exMemRd != 5'b0)) ? 2'b01
                              :(memWBRw & (rs2 == memWBRd) & (memWBRd != 5'b0)) ? 2'b10
                              : 2'b00;

  wire [31:0] regWData = mem_wb_ctrl_data_toReg ? mem_wb_readData : mem_wb_data_result; 

  // 根据数据冒险的类型选择前递的数据
  // 00:流水线不发生数据冒险时，流水线正常选择的数据通路。
  // 01:访存阶段需要写到通用寄存器的数据
  // 10:回写阶段需要更新到通用寄存器的数据
  assign forward_rs1_data = (forward_rs1_sel == 2'b00) ? id_ex_data_regRData1 :
                            (forward_rs1_sel == 2'b01) ? ex_mem_data_result   :
                            (forward_rs1_sel == 2'b10) ? regWData : 32'h0; 

  assign forward_rs2_data = (forward_rs2_sel == 2'b00) ? id_ex_data_regRData2 :
                            (forward_rs2_sel == 2'b01) ? ex_mem_data_result   :
                            (forward_rs2_sel == 2'b10) ? regWData : 32'h0; 
endmodule