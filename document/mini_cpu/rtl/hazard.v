// 控制冒险模块
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

  output reg    pcFromTaken,// pcFromTaken 是分支指令执行之后，判断和分支预测方向是否一致的信号
  output reg    pcStall,// pcStall 是控制程序计数器停止的信号，如果程序计数器停止，那么流水线将不会读取新的指令
  output reg    IF_ID_stall,// IF_ID_stall 是流水线中从取指到译码的阶段的停止信号
  output reg    ID_EX_stall,// ID_EX_stall 是流水线从译码到执行阶段的停止信号
  // 当流水线需要冲刷时，就会产生取指、译码、执行、访存阶段的清零信号，分别对应着 ID_EX_flush、EX_MEM_flush 和 IF_ID_flush 信号
  output reg    ID_EX_flush,
  output reg    EX_MEM_flush,
  output reg    IF_ID_flush
);

  // branch_do：条件分支指令的条件比较结果，由 ALU 运算结果和立即数的最高位（符合位）通过“与”操作得到
  wire branch_do = ((alu_result_0 & ~id_ex_imm_31) | (~alu_result_0 & id_ex_imm_31));
  // ex_mem_taken 是确认分支指令跳转的信号，由无条件跳转（jump）“或”条件分支指令（branch）产生
  wire ex_mem_taken = id_ex_jump[0] | (id_ex_branch & branch_do);
  // id_ex_memAccess 是存储器的选通信号，当对存储器的“读”或者“写”控制信号有效时产生
  wire id_ex_memAccess = id_ex_memRead | id_ex_memWrite; 
  // ex_mem_need_stall 信号表示流水线需要停顿，当执行 sb 或者 sh 指令时就会出现这样的情况
  wire ex_mem_need_stall = ex_mem_memWrite & (ex_mem_maskMode == 2'h0 | ex_mem_maskMode == 2'h1); 

  always @(*) begin
    // 第一种情况是解决数据相关性问题。数据相关指的是指令之间存在的依赖关系。当两条指令之间存在相关关系时，它们就不能在流水线中重叠执行。
    // 例如，前一条指令是访存指令 Store，后一条也是 Load 或者 Store 指令，因为我们采用的是同步 RAM，需要先读出再写入，占用两个时钟周期，所以这时要把之后的指令停一个时钟周期。
    if(id_ex_memAccess && ex_mem_need_stall) begin
      pcFromTaken  <= 0;
      pcStall      <= 1;
      IF_ID_stall  <= 1;
      IF_ID_flush  <= 0;
      ID_EX_stall  <= 1;
      ID_EX_flush  <= 0;
      EX_MEM_flush <= 1;
    end
    // 第二种情况是分支预测失败的问题，当分支指令执行之后，如果发现分支跳转的方向与预测方向不一致。这时就需要冲刷流水线，清除处于取指、译码阶段的指令数据，更新 PC 值。
    else if(ex_mem_taken) begin 
      pcFromTaken  <= 1;
      pcStall      <= 0; 
      IF_ID_flush  <= 1;
      ID_EX_flush  <= 1;
      EX_MEM_flush <= 0;
    end
    // 第三种情况就是解决数据冒险问题。当前一条指令是 Load，后一条指令的源寄存器 rs1 和 rs2 依赖于前一条从存储器中读出来的值，需要把 Load 指令之后的指令停顿一个时钟周期，而且还要冲刷 ID _EX 阶段的指令数据。
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