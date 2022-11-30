
module hazard (
  input  [4:0]  rs1,
  input  [4:0]  rs2,
  input         alu_result_0,
  input  [1:0]  id_ex_jump,
  input         id_ex_branch,
  input         id_ex_imm_31,
  input         id_ex_memRead,
  input         id_ex_memWrite,
  input  [4:0]  id_ex_rd,
  input  [1:0]  ex_mem_maskMode,
  input         ex_mem_memWrite,

  output reg    pcFromTaken,
  output reg    pcStall,
  output reg    IF_ID_stall,
  output reg    ID_EX_stall,
  output reg    ID_EX_flush,
  output reg    EX_MEM_flush,
  output reg    IF_ID_flush
);

  wire branch_do = ((alu_result_0 & ~id_ex_imm_31) | (~alu_result_0 & id_ex_imm_31));
  wire ex_mem_taken = id_ex_jump[0] | (id_ex_branch & branch_do);

  wire id_ex_memAccess = id_ex_memRead | id_ex_memWrite; 

  wire ex_mem_need_stall = ex_mem_memWrite & (ex_mem_maskMode == 2'h0 | ex_mem_maskMode == 2'h1); 

  always @(*) begin
    if(id_ex_memAccess && ex_mem_need_stall) begin
      pcFromTaken  <= 0;
      pcStall      <= 1;
      IF_ID_stall  <= 1;
      IF_ID_flush  <= 0;
      ID_EX_stall  <= 1;
      ID_EX_flush  <= 0;
      EX_MEM_flush <= 1;
    end
    else if(ex_mem_taken) begin 
      pcFromTaken  <= 1;
      pcStall      <= 0; 
      IF_ID_flush  <= 1;
      ID_EX_flush  <= 1;
      EX_MEM_flush <= 0;
    end
    else if(id_ex_memRead & (id_ex_rd == rs1 || id_ex_rd == rs2)) begin
      pcFromTaken <= 0;
      pcStall     <= 1;
      IF_ID_stall <= 1;
      ID_EX_flush <= 1;
    end
    else begin
      pcFromTaken    <= 0;  
      pcStall        <= 0; 
      IF_ID_stall    <= 0;
      ID_EX_stall    <= 0;
      ID_EX_flush    <= 0;
      EX_MEM_flush   <= 0;  
      IF_ID_flush    <= 0;
    end
  end

endmodule