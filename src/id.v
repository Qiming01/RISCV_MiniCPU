/**
 * 描述： id 模块 对指令进行译码，
 *       得到最终运算的类型、子类型、源操作数1、源操作数2、要写入的目的寄存器地址等信息
 * @Author:Qi_Ming
 * @Date:2022.12.13
 */

`include "defines.v"

module id(

	input wire                      rst,        // 复位信号
	input wire[`InstAddrBus]        pc_i,       // 译码阶段的指令的地址，32bit
	input wire[`InstBus]            inst_i,     // 译码阶段的指令

    // 读取的Regfile的值
	input wire[`RegBus]             reg1_data_i,// Regfile输入的第一个读寄存器端口的输入，32bit
	input wire[`RegBus]             reg2_data_i,// Regfile输入的第二个读寄存器端口的输入，32bit

    // 输出到Regfile的信息
	output reg                      reg1_read_o,// Regfile输入的第一个读寄存器端口的读使能信号
	output reg                      reg2_read_o,// Regfile输入的第二个读寄存器端口的读使能信号
	output reg[`RegAddrBus]         reg1_addr_o,// Regfile输入的第一个读寄存器端口的读地址
	output reg[`RegAddrBus]         reg2_addr_o,// Regfile输入的第二个读寄存器端口的读地址

    // 送到执行阶段的信息
	output reg[`AluOpBus]           aluop_o,    // 译码阶段要进行的运算的子类型
	output reg[`AluSelBus]          alusel_o,   // 译码阶段要进行的运算的类型
	output reg[`RegBus]             reg1_o,     // 源操作数1
	output reg[`RegBus]             reg2_o,     // 源操作数2
	output reg[`RegAddrBus]         wd_o,       // 要写入的目的寄存器地址
	output reg                      wreg_o      // 是否要写入目的寄存器
);

    // 取得指令的操作码和功能码
    /* **********************************字段**********************************
     * ************|   7位  |  5位  |   5位 | 3位  |  5位 |  7位   |****************
    // R型指令：    | funct7 |  rs2 |   rs1 |funct3|  rd  | opcode |

    */

    // ori : 0000000 rs2 rs1 110 rd 0110011
    wire[5:0] op = inst_i[31:26];
    wire[4:0] op2 = inst_i[10:6];
    wire[5:0] op3 = inst_i[5:0];
    wire[4:0] op4 = inst_i[20:16];
    reg[`RegBus]	imm;
    reg instvalid;
  
 
	always @ (*) begin	
		if (rst == `RstEnable) begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
			instvalid <= `InstValid;
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			imm <= 32'h0;			
	  end else begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= inst_i[15:11];
			wreg_o <= `WriteDisable;
			instvalid <= `InstInvalid;	   
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= inst_i[25:21];
			reg2_addr_o <= inst_i[20:16];		
			imm <= `ZeroWord;			
		  case (op)
		  	`EXE_ORI:			begin                        //ORIָ��
		  		wreg_o <= `WriteEnable;		aluop_o <= `EXE_OR_OP;
		  		alusel_o <= `EXE_RES_LOGIC; reg1_read_o <= 1'b1;	reg2_read_o <= 1'b0;	  	
					imm <= {16'h0, inst_i[15:0]};		wd_o <= inst_i[20:16];
					instvalid <= `InstValid;	
		  	end 							 
		    default:			begin
		    end
		  endcase		  //case op			
		end       //if
	end         //always
	

	always @ (*) begin
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
	  end else if(reg1_read_o == 1'b1) begin
	  	reg1_o <= reg1_data_i;
	  end else if(reg1_read_o == 1'b0) begin
	  	reg1_o <= imm;
	  end else begin
	    reg1_o <= `ZeroWord;
	  end
	end
	
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
	  end else if(reg2_read_o == 1'b1) begin
	  	reg2_o <= reg2_data_i;
	  end else if(reg2_read_o == 1'b0) begin
	  	reg2_o <= imm;
	  end else begin
	    reg2_o <= `ZeroWord;
	  end
	end

endmodule