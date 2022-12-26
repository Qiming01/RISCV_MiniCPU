
module cpu(
  input         clk,
  input         reset,
  output [31:0] imem_addr,
  output        imem_valid,
  input         imem_good,
  input  [31:0] imem_instr,

  output [31:0] dmem_addr,
  output        dmem_valid,
  input         dmem_good,
  output [31:0] dmem_writeData,
  output        dmem_memRead,
  output        dmem_memWrite,
  output [1:0]  dmem_maskMode,
  output        dmem_sext,
  input  [31:0] dmem_readData,
  output [31:0] dmem_readBack
);

  wire [4:0] decode_rs1_addr; 
  wire [4:0] decode_rs2_addr; 
  wire [4:0] decode_rd_addr; 
  wire [6:0] decode_funct7; 
  wire [2:0] decode_funct3; 
  wire  decode_branch; 
  wire [1:0] decode_jump; 
  wire  decode_memRead; 
  wire  decode_memWrite; 
  wire  decode_regWrite; 
  wire  decode_toReg; 
  wire [1:0] decode_resultSel; 
  wire  decode_aluSrc; 
  wire  decode_pcAdd; 
  wire [6:0] decode_types; 
  wire [1:0] decode_aluCtrlOp; 
  wire  decode_validInst; 
  wire [31:0] decode_imm; 

  wire  regs_wen; 
  wire [4:0] regs_regWAddr; 
  wire [31:0] regs_regWData; 
  wire [31:0] regs_regRData1; 
  wire [31:0] regs_regRData2; 

  wire [2:0] aluControl_funct3; 
  wire [6:0] aluControl_funct7; 
  wire       aluControl_itype; 
  wire [1:0] aluControl_aluCtrlOp; 
  wire [3:0] aluControl_aluOp; 

  wire [31:0] alu_aluIn1; 
  wire [31:0] alu_aluIn2; 
  wire [3:0] alu_aluOp; 
  wire [31:0] alu_aluOut; 
  wire [31:0] branch_add;

  wire [4:0] forwarding_rs1; 
  wire [4:0] forwarding_rs2; 
  wire [4:0] forwarding_exMemRd; 
  wire  forwarding_exMemRw; 
  wire [4:0] forwarding_memWBRd; 
  wire  forwarding_memWBRw; 
  wire [1:0] forwarding_forwardA; 
  wire [1:0] forwarding_forwardB; 

  wire  hazard_ID_EX_memRead; 
  wire [4:0] hazard_ID_EX_rd; 
  wire  hazard_EX_MEM_taken; 
  wire  hazard_ID_EX_memAccess; 
  wire  hazard_EX_MEM_need_stall; 
  wire  hazard_pcFromTaken; 
  wire  hazard_pcStall; 
  wire  hazard_IF_ID_stall; 
  wire  hazard_ID_EX_stall; 
  wire  hazard_ID_EX_flush; 
  wire  hazard_EX_MEM_flush; 
  wire  hazard_IF_ID_flush; 

  wire [31:0] pre_pc; 

  wire [31:0] if_id_in_instr; 
  wire  if_id_in_noflush; 
  wire  if_id_flush; 
  wire  if_id_valid; 
  wire [31:0] if_id_instr; 
  wire [31:0] if_id_pc; 
  wire  if_id_noflush; 

  wire [31:0] id_ex_in_regRData2; 
  wire [31:0] id_ex_in_regRData1; 
  wire  id_ex_flush; 
  wire  id_ex_valid; 
  wire [4:0] id_ex_rd_addr; 
  wire [6:0] id_ex_data_funct7; 
  wire [2:0] id_ex_data_funct3; 
  wire [31:0] id_ex_data_imm; 
  wire [31:0] id_ex_data_regRData2; 
  wire [31:0] id_ex_data_regRData1; 
  wire [31:0] id_ex_data_pc; 
  wire [4:0] id_ex_data_rs1; 
  wire [4:0] id_ex_data_rs2; 

  wire  id_ex_ctrl_in_ex_ctrl_itype; 
  wire [1:0] id_ex_ctrl_in_ex_ctrl_aluCtrlOp; 
  wire [1:0] id_ex_ctrl_in_ex_ctrl_resultSel; 
  wire  id_ex_ctrl_in_ex_ctrl_aluSrc; 
  wire  id_ex_ctrl_in_ex_ctrl_pcAdd; 
  wire  id_ex_ctrl_in_ex_ctrl_branch; 
  wire [1:0] id_ex_ctrl_in_ex_ctrl_jump; 
  wire  id_ex_ctrl_in_mem_ctrl_memRead; 
  wire  id_ex_ctrl_in_mem_ctrl_memWrite; 
  wire [1:0] id_ex_ctrl_in_mem_ctrl_maskMode; 
  wire  id_ex_ctrl_in_mem_ctrl_sext; 
  wire  id_ex_ctrl_in_wb_ctrl_toReg; 
  wire  id_ex_ctrl_in_wb_ctrl_regWrite; 
  wire  id_ex_ctrl_in_noflush; 
  wire  id_ex_ctrl_flush; 
  wire  id_ex_ctrl_valid; 
  wire  id_ex_ctrl_data_ex_ctrl_itype; 
  wire [1:0] id_ex_ctrl_data_ex_ctrl_aluCtrlOp; 
  wire [1:0] id_ex_ctrl_data_ex_ctrl_resultSel; 
  wire  id_ex_ctrl_data_ex_ctrl_aluSrc; 
  wire  id_ex_ctrl_data_ex_ctrl_pcAdd; 
  wire  id_ex_ctrl_data_ex_ctrl_branch; 
  wire [1:0] id_ex_ctrl_data_ex_ctrl_jump; 
  wire  id_ex_ctrl_data_mem_ctrl_memRead; 
  wire  id_ex_ctrl_data_mem_ctrl_memWrite; 
  wire [1:0] id_ex_ctrl_data_mem_ctrl_maskMode; 
  wire  id_ex_ctrl_data_mem_ctrl_sext; 
  wire  id_ex_ctrl_data_wb_ctrl_toReg; 
  wire  id_ex_ctrl_data_wb_ctrl_regWrite; 
  wire  id_ex_ctrl_data_noflush; 

  wire [4:0] ex_mem_in_regWAddr; 
  wire [31:0] ex_mem_in_regRData2; 
  wire [31:0] ex_mem_in_pc; 
  wire  ex_mem_flush; 
  wire [4:0] ex_mem_data_regWAddr; 
  wire [31:0] ex_mem_data_regRData2; 
  wire [31:0] ex_mem_data_result; 
  wire [31:0] ex_mem_data_pc; 

  wire  ex_mem_ctrl_in_mem_ctrl_memRead; 
  wire  ex_mem_ctrl_in_mem_ctrl_memWrite; 
  wire [1:0] ex_mem_ctrl_in_mem_ctrl_maskMode; 
  wire  ex_mem_ctrl_in_mem_ctrl_sext; 
  wire  ex_mem_ctrl_in_wb_ctrl_toReg; 
  wire  ex_mem_ctrl_in_wb_ctrl_regWrite; 
  wire  ex_mem_ctrl_flush; 
  wire  ex_mem_ctrl_data_mem_ctrl_memRead; 
  wire  ex_mem_ctrl_data_mem_ctrl_memWrite; 
  wire [1:0] ex_mem_ctrl_data_mem_ctrl_maskMode; 
  wire  ex_mem_ctrl_data_mem_ctrl_sext; 
  wire  ex_mem_ctrl_data_wb_ctrl_toReg; 
  wire  ex_mem_ctrl_data_wb_ctrl_regWrite; 

  wire [4:0] mem_wb_in_regWAddr; 
  wire [31:0] mem_wb_in_result; 
  wire [31:0] mem_wb_in_readData; 
  wire [31:0] mem_wb_in_pc; 
  wire [4:0] mem_wb_data_regWAddr; 
  wire [31:0] mem_wb_data_result; 
  wire [31:0] mem_wb_data_readData; 
  wire [31:0] mem_wb_data_pc; 

  wire  mem_wb_ctrl_in_wb_ctrl_toReg; 
  wire  mem_wb_ctrl_in_wb_ctrl_regWrite; 
  wire  mem_wb_ctrl_data_wb_ctrl_toReg; 
  wire  mem_wb_ctrl_data_wb_ctrl_regWrite; 

  wire [31:0] forward_rs1_data;
  wire [31:0] forward_rs2_data;

  wire [31:0] pc; 


  gen_regs u_gen_regs ( 
    .clk(clk),
    .reset(reset),
    .wen(regs_wen),
    .regRAddr1(decode_rs1_addr),
    .regRAddr2(decode_rs2_addr),
    .regWAddr(regs_regWAddr),
    .regWData(regs_regWData),
    .regRData1(regs_regRData1),
    .regRData2(regs_regRData2)
  );
  
  alu_ctrl u_alu_ctrl( 
    .funct3(aluControl_funct3),
    .funct7(aluControl_funct7),
    .itype(aluControl_itype),
    .aluCtrlOp(aluControl_aluCtrlOp),
    .aluOp(aluControl_aluOp)
  );

  alu u_alu ( 
    .alu_data1_i(alu_aluIn1),
    .alu_data2_i(alu_aluIn2),
    .alu_op_i(alu_aluOp),
    .alu_result_o(alu_aluOut)
  );

  forwarding u_forwarding ( 
    .rs1(forwarding_rs1),
    .rs2(forwarding_rs2),
    .exMemRd(forwarding_exMemRd),
    .exMemRw(forwarding_exMemRw),
    .memWBRd(forwarding_memWBRd),
    .memWBRw(forwarding_memWBRw),
    .mem_wb_ctrl_data_toReg(mem_wb_ctrl_data_wb_ctrl_toReg  ),
    .mem_wb_readData(mem_wb_data_readData  ),
    .mem_wb_data_result(mem_wb_data_result  ),
    .id_ex_data_regRData1(id_ex_data_regRData1  ),
    .id_ex_data_regRData2(id_ex_data_regRData2  ),
    .ex_mem_data_result(ex_mem_data_result  ),
    .forward_rs1_data(forward_rs1_data),
    .forward_rs2_data(forward_rs2_data)
  );

  hazard u_hazard ( 
    .rs1(decode_rs1_addr),
    .rs2(decode_rs2_addr),
    .alu_result_0(alu_aluOut[0] ),
    .id_ex_jump(id_ex_ctrl_data_ex_ctrl_jump ),
    .id_ex_branch(id_ex_ctrl_data_ex_ctrl_branch ),
    .id_ex_imm_31(id_ex_data_imm[31] ),
    .id_ex_memRead(id_ex_ctrl_data_mem_ctrl_memRead ),
    .id_ex_memWrite(id_ex_ctrl_data_mem_ctrl_memWrite ),
    .id_ex_rd(id_ex_rd_addr ),
    .ex_mem_maskMode(ex_mem_ctrl_data_mem_ctrl_maskMode ),
    .ex_mem_memWrite(ex_mem_ctrl_data_mem_ctrl_memWrite ),
    .pcFromTaken(hazard_pcFromTaken),
    .pcStall(hazard_pcStall),
    .IF_ID_stall(hazard_IF_ID_stall),
    .ID_EX_stall(hazard_ID_EX_stall),
    .ID_EX_flush(hazard_ID_EX_flush),
    .EX_MEM_flush(hazard_EX_MEM_flush),
    .IF_ID_flush(hazard_IF_ID_flush)
  );
  
  pre_if u_pre_if ( 
    .instr(imem_instr),
    .pc(pc),
    .pre_pc(pre_pc)
  );

  if_id u_if_id ( 
    .clk(clk),
    .reset(reset),
    .in_instr(if_id_in_instr),
    .in_pc(pc),
    .flush(if_id_flush),
    .valid(if_id_valid),
    .out_instr(if_id_instr),
    .out_pc(if_id_pc),
    .out_noflush(if_id_noflush)
  );

  decode u_decode ( 
    .instr(if_id_instr),
    .rs1_addr(decode_rs1_addr),
    .rs2_addr(decode_rs2_addr),
    .rd_addr(decode_rd_addr),
    .funct3(decode_funct3),
    .funct7(decode_funct7),
    .branch(decode_branch),
    .jump(decode_jump),
    .mem_read(decode_memRead),
    .mem_write(decode_memWrite),
    .reg_write(decode_regWrite),
    .to_reg(decode_toReg),
    .result_sel(decode_resultSel),
    .alu_src(decode_aluSrc),
    .pc_add(decode_pcAdd),
    .types(decode_types),
    .alu_ctrlop(decode_aluCtrlOp),
    .valid_inst(decode_validInst),
    .imm(decode_imm)
  );

  id_ex u_id_ex ( 
    .clk(clk),
    .reset(reset),
    .in_rd_addr(decode_rd_addr),
    .in_funct7(decode_funct7),
    .in_funct3(decode_funct3),
    .in_imm(decode_imm),
    .in_rs2_data(id_ex_in_regRData2),
    .in_rs1_data(id_ex_in_regRData1),
    .in_pc(if_id_pc),
    .in_rs1_addr(decode_rs1_addr),
    .in_rs2_addr(decode_rs2_addr),
    .flush(id_ex_flush),
    .valid(id_ex_valid),
    .out_rd_addr(id_ex_rd_addr),
    .out_funct7(id_ex_data_funct7),
    .out_funct3(id_ex_data_funct3),
    .out_imm(id_ex_data_imm),
    .out_rs2_data(id_ex_data_regRData2),
    .out_rs1_data(id_ex_data_regRData1),
    .out_pc(id_ex_data_pc),
    .out_rs1_addr(id_ex_data_rs1),
    .out_rs2_addr(id_ex_data_rs2)
  );

  id_ex_ctrl u_id_ex_ctrl ( 
    .clk(clk),
    .reset(reset),
    .in_ex_ctrl_itype(id_ex_ctrl_in_ex_ctrl_itype),
    .in_ex_ctrl_alu_ctrlop(id_ex_ctrl_in_ex_ctrl_aluCtrlOp),
    .in_ex_ctrl_result_sel(id_ex_ctrl_in_ex_ctrl_resultSel),
    .in_ex_ctrl_alu_src(id_ex_ctrl_in_ex_ctrl_aluSrc),
    .in_ex_ctrl_pc_add(id_ex_ctrl_in_ex_ctrl_pcAdd),
    .in_ex_ctrl_branch(id_ex_ctrl_in_ex_ctrl_branch),
    .in_ex_ctrl_jump(id_ex_ctrl_in_ex_ctrl_jump),
    .in_mem_ctrl_mem_read(id_ex_ctrl_in_mem_ctrl_memRead),
    .in_mem_ctrl_mem_write(id_ex_ctrl_in_mem_ctrl_memWrite),
    .in_mem_ctrl_mask_mode(id_ex_ctrl_in_mem_ctrl_maskMode),
    .in_mem_ctrl_sext(id_ex_ctrl_in_mem_ctrl_sext),
    .in_wb_ctrl_to_reg(id_ex_ctrl_in_wb_ctrl_toReg),
    .in_wb_ctrl_reg_write(id_ex_ctrl_in_wb_ctrl_regWrite),
    .in_noflush(id_ex_ctrl_in_noflush),
    .flush(id_ex_ctrl_flush),
    .valid(id_ex_ctrl_valid),
    .out_ex_ctrl_itype(id_ex_ctrl_data_ex_ctrl_itype),
    .out_ex_ctrl_alu_ctrlop(id_ex_ctrl_data_ex_ctrl_aluCtrlOp),
    .out_ex_ctrl_result_sel(id_ex_ctrl_data_ex_ctrl_resultSel),
    .out_ex_ctrl_alu_src(id_ex_ctrl_data_ex_ctrl_aluSrc),
    .out_ex_ctrl_pc_add(id_ex_ctrl_data_ex_ctrl_pcAdd),
    .out_ex_ctrl_branch(id_ex_ctrl_data_ex_ctrl_branch),
    .out_ex_ctrl_jump(id_ex_ctrl_data_ex_ctrl_jump),
    .out_mem_ctrl_mem_read(id_ex_ctrl_data_mem_ctrl_memRead),
    .out_mem_ctrl_mem_write(id_ex_ctrl_data_mem_ctrl_memWrite),
    .out_mem_ctrl_mask_mode(id_ex_ctrl_data_mem_ctrl_maskMode),
    .out_mem_ctrl_sext(id_ex_ctrl_data_mem_ctrl_sext),
    .out_wb_ctrl_to_reg(id_ex_ctrl_data_wb_ctrl_toReg),
    .out_wb_ctrl_reg_write(id_ex_ctrl_data_wb_ctrl_regWrite),
    .out_noflush(id_ex_ctrl_data_noflush)
  );

  ex_mem u_ex_mem ( 
    .clk(clk),
    .reset(reset),
    .in_regWAddr(ex_mem_in_regWAddr),
    .in_regRData2(ex_mem_in_regRData2),
    .ex_result_sel(id_ex_ctrl_data_ex_ctrl_resultSel),
    .id_ex_data_imm(id_ex_data_imm),
    .in_pc(ex_mem_in_pc),
    .alu_result(alu_aluOut),
    .flush(ex_mem_flush),
    .data_regWAddr(ex_mem_data_regWAddr),
    .data_regRData2(ex_mem_data_regRData2),
    .data_result(ex_mem_data_result),
    .data_pc(ex_mem_data_pc)
  );

  ex_mem_ctrl u_ex_mem_ctrl ( 
    .clk(clk),
    .reset(reset),
    .in_mem_ctrl_memRead(ex_mem_ctrl_in_mem_ctrl_memRead),
    .in_mem_ctrl_memWrite(ex_mem_ctrl_in_mem_ctrl_memWrite),
    .in_mem_ctrl_maskMode(ex_mem_ctrl_in_mem_ctrl_maskMode),
    .in_mem_ctrl_sext(ex_mem_ctrl_in_mem_ctrl_sext),
    .in_wb_ctrl_toReg(ex_mem_ctrl_in_wb_ctrl_toReg),
    .in_wb_ctrl_regWrite(ex_mem_ctrl_in_wb_ctrl_regWrite),
    .flush(ex_mem_ctrl_flush),
    .out_mem_ctrl_memRead(ex_mem_ctrl_data_mem_ctrl_memRead),
    .out_mem_ctrl_memWrite(ex_mem_ctrl_data_mem_ctrl_memWrite),
    .out_mem_ctrl_maskMode(ex_mem_ctrl_data_mem_ctrl_maskMode),
    .out_mem_ctrl_sext(ex_mem_ctrl_data_mem_ctrl_sext),
    .out_wb_ctrl_toReg(ex_mem_ctrl_data_wb_ctrl_toReg),
    .out_wb_ctrl_regWrite(ex_mem_ctrl_data_wb_ctrl_regWrite)
  );

  dmem_rw u_dmem_rw(
    .reset(reset),
    .clk(clk),
    .ex_mem_ctrl_data_mem_ctrl_memWrite(ex_mem_ctrl_data_mem_ctrl_memWrite ),
    .ex_mem_ctrl_data_mem_ctrl_maskMode(ex_mem_ctrl_data_mem_ctrl_maskMode ),
    .ex_mem_data_result(ex_mem_data_result ),
    .ex_mem_data_regRData2(ex_mem_data_regRData2 ),
    .ex_mem_ctrl_data_mem_ctrl_memRead(ex_mem_ctrl_data_mem_ctrl_memRead ),
    .ex_mem_ctrl_data_mem_ctrl_sext(ex_mem_ctrl_data_mem_ctrl_sext ),
    .dmem_addr(dmem_addr ),
    .dmem_valid(dmem_valid ),
    .dmem_writeData(dmem_writeData ),
    .dmem_memRead(dmem_memRead ),
    .dmem_memWrite(dmem_memWrite ),
    .dmem_maskMode(dmem_maskMode ),
    .dmem_sext(dmem_sext ),
    .dmem_readData(dmem_readData ),
    .dmem_readBack(dmem_readBack)
  );

  mem_wb u_mem_wb ( 
    .clk(clk),
    .reset(reset),
    .in_regWAddr(mem_wb_in_regWAddr),
    .in_result(mem_wb_in_result),
    .in_readData(mem_wb_in_readData),
    .in_pc(mem_wb_in_pc),
    .data_regWAddr(mem_wb_data_regWAddr),
    .data_result(mem_wb_data_result),
    .data_readData(mem_wb_data_readData),
    .data_pc(mem_wb_data_pc)
  );

  mem_wb_ctrl u_mem_wb_ctrl ( 
    .clk(clk),
    .reset(reset),
    .in_wb_ctrl_toReg(mem_wb_ctrl_in_wb_ctrl_toReg),
    .in_wb_ctrl_regWrite(mem_wb_ctrl_in_wb_ctrl_regWrite),
    .data_wb_ctrl_toReg(mem_wb_ctrl_data_wb_ctrl_toReg),
    .data_wb_ctrl_regWrite(mem_wb_ctrl_data_wb_ctrl_regWrite)
  );

  pc_gen u_pc_gen(
    .reset(reset  ),
    .clk(clk  ),
    .alu_result(alu_aluOut  ),
    .branch_add(branch_add  ),
    .hazard_pcStall(hazard_pcStall  ),
    .hazard_pcFromTaken(hazard_pcFromTaken  ),
    .id_ex_ctrl_data_ex_ctrl_jump(id_ex_ctrl_data_ex_ctrl_jump  ),
    .pre_pc(pre_pc  ),
    .pc_o(pc)
  );

  assign regs_wen = mem_wb_ctrl_data_wb_ctrl_regWrite & mem_wb_data_regWAddr != 5'h0; 
  assign regs_regWAddr = mem_wb_data_regWAddr;
  assign regs_regWData = mem_wb_ctrl_data_wb_ctrl_toReg ? mem_wb_data_readData : mem_wb_data_result;  
  
  assign aluControl_funct3 = id_ex_data_funct3; 
  assign aluControl_funct7 = id_ex_data_funct7; 
  assign aluControl_itype = id_ex_ctrl_data_ex_ctrl_itype; 
  assign aluControl_aluCtrlOp = id_ex_ctrl_data_ex_ctrl_aluCtrlOp; 

  assign alu_aluIn1 = id_ex_ctrl_data_ex_ctrl_pcAdd ? id_ex_data_pc : forward_rs1_data;
  assign alu_aluIn2 = id_ex_ctrl_data_ex_ctrl_aluSrc ? id_ex_data_imm : forward_rs2_data; 
  assign alu_aluOp = aluControl_aluOp; 
  assign branch_add = id_ex_data_pc + id_ex_data_imm;

  assign forwarding_rs1 = id_ex_data_rs1; 
  assign forwarding_rs2 = id_ex_data_rs2;
  assign forwarding_exMemRd = ex_mem_data_regWAddr; 
  assign forwarding_exMemRw = ex_mem_ctrl_data_wb_ctrl_regWrite; 
  assign forwarding_memWBRd = mem_wb_data_regWAddr; 
  assign forwarding_memWBRw = mem_wb_ctrl_data_wb_ctrl_regWrite; 

  assign if_id_in_instr = imem_instr;  
  assign if_id_flush = hazard_IF_ID_flush; 
  assign if_id_valid = ~hazard_IF_ID_stall; 

  assign id_ex_in_regRData2 = regs_regRData2; 
  assign id_ex_in_regRData1 = regs_regRData1; 
  assign id_ex_flush = hazard_ID_EX_flush; 
  assign id_ex_valid = ~hazard_ID_EX_stall; 
  assign id_ex_ctrl_in_ex_ctrl_itype = decode_types[5]; 
  assign id_ex_ctrl_in_ex_ctrl_aluCtrlOp = decode_aluCtrlOp; 
  assign id_ex_ctrl_in_ex_ctrl_resultSel = decode_resultSel;
  assign id_ex_ctrl_in_ex_ctrl_aluSrc = decode_aluSrc; 
  assign id_ex_ctrl_in_ex_ctrl_pcAdd = decode_pcAdd;
  assign id_ex_ctrl_in_ex_ctrl_branch = decode_branch; 
  assign id_ex_ctrl_in_ex_ctrl_jump = decode_jump; 
  assign id_ex_ctrl_in_mem_ctrl_memRead = decode_memRead; 
  assign id_ex_ctrl_in_mem_ctrl_memWrite = decode_memWrite; 
  assign id_ex_ctrl_in_mem_ctrl_maskMode = if_id_instr[13:12]; 
  assign id_ex_ctrl_in_mem_ctrl_sext = ~if_id_instr[14];
  assign id_ex_ctrl_in_wb_ctrl_toReg = decode_toReg; 
  assign id_ex_ctrl_in_wb_ctrl_regWrite = decode_regWrite; 
  assign id_ex_ctrl_in_noflush = 1'h1; 
  assign id_ex_ctrl_flush = hazard_ID_EX_flush; 
  assign id_ex_ctrl_valid = ~hazard_ID_EX_stall; 

  assign ex_mem_in_regWAddr = id_ex_rd_addr;
  assign ex_mem_in_regRData2 = forward_rs2_data; 
  assign ex_mem_in_pc = id_ex_data_pc; 
  assign ex_mem_flush = hazard_EX_MEM_flush; 
  assign ex_mem_ctrl_in_mem_ctrl_memRead = id_ex_ctrl_data_mem_ctrl_memRead; 
  assign ex_mem_ctrl_in_mem_ctrl_memWrite = id_ex_ctrl_data_mem_ctrl_memWrite; 
  assign ex_mem_ctrl_in_mem_ctrl_maskMode = id_ex_ctrl_data_mem_ctrl_maskMode; 
  assign ex_mem_ctrl_in_mem_ctrl_sext = id_ex_ctrl_data_mem_ctrl_sext; 
  assign ex_mem_ctrl_in_wb_ctrl_toReg = id_ex_ctrl_data_wb_ctrl_toReg;
  assign ex_mem_ctrl_in_wb_ctrl_regWrite = id_ex_ctrl_data_wb_ctrl_regWrite;
  assign ex_mem_ctrl_flush = hazard_EX_MEM_flush;

  assign mem_wb_in_regWAddr = ex_mem_data_regWAddr; 
  assign mem_wb_in_result = ex_mem_data_result; 
  assign mem_wb_in_readData = dmem_readData; 
  assign mem_wb_in_pc = ex_mem_data_pc; 
  assign mem_wb_ctrl_in_wb_ctrl_toReg = ex_mem_ctrl_data_wb_ctrl_toReg; 
  assign mem_wb_ctrl_in_wb_ctrl_regWrite = ex_mem_ctrl_data_wb_ctrl_regWrite; 

  assign imem_addr = pc; 
  assign imem_valid = ~hazard_IF_ID_stall;

endmodule
