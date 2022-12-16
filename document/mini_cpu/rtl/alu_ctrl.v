/**
* 译码模块产生了信号aluCtrlOp和opcode
* 如果 aluCrtlOp 等于（00），对应的指令类型就是 Load 和 Store 指令
* 也就是通过加法运算来计算访存地址；
* 如果 aluCrtlOp 等于（01），相应的指令类型就是 ALUI/ALUR
* 同样也是根据输入的 funct7 和 funct3 字段决定执行哪些算术运算
* 比如加减运算、移位操作等；
* 如果类型字段等于（10），就对应着分支跳转指令
* 流水线就会相应去完成条件分支的解析工作。
* 11作为拓展功能，暂不考虑
* 根据2位的aluCtrlOp字段设计控制模块
*/

module alu_ctrl (
    input [2:0]  funct3,
    input [6:0]  funct7,
    input [1:0]  aluCtrlOp,
    // I 型指令类型的判断信号 itype。
    // 如果是 itype 信号等于“1”，操作码直接由 funct3 和高位补“0”组成；
    // 如果不是 I 型指令，ALU 操作码则要由 funct3 和 funct7 的第五位组成
    input        itype,
    
    // 输出一个4位的ALU操作信号aluOp
    output reg [3:0] aluOp
);
    always @(*) begin
      case(aluCtrlOp)
        2'b00:  aluOp <= `ALU_OP_ADD;           // Load or Store
        // 当 aluCtrlOp 等于（01）时，需要根据 funct3 和 funct7 产生 ALU 的操作码
        2'b01:  begin
          if(itype & funct3[1:0] != 2'b01)
            aluOp <= {1'b0, funct3};
          else
            aluOp <= {funct7[5], funct3};   // normal ALUI/ALUR
        end
        2'b10:  begin
         // $display("~~~aluCtrl bxx~~~%d", funct3);
          case(funct3)                    // bxx
            `BEQ_FUNCT3:  aluOp <= `ALU_OP_EQ;
            `BNE_FUNCT3:  aluOp <= `ALU_OP_NEQ;
            `BLT_FUNCT3:  aluOp <= `ALU_OP_SLT;
            `BGE_FUNCT3:  aluOp <= `ALU_OP_GE;
            `BLTU_FUNCT3: aluOp <= `ALU_OP_SLTU;
            `BGEU_FUNCT3: aluOp <= `ALU_OP_GEU;
            default:      aluOp <= `ALU_OP_XXX;
          endcase
          end
        default: aluOp <= `ALU_OP_XXX;
      endcase
    end
endmodule