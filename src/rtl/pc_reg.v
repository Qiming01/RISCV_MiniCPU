// pc_reg
// PC寄存器模块，用于产生PC寄存器的值，该值会被用作指令存储器的地址信号。
// Author:Qi_Ming
// email:qiming01@outlook.com


`include "defines.v"

module pc_reg(

	input wire					clk,	    	// 复位信号
	input wire					rst,    		// 时钟信号
	input wire[`InstAddrBus]	jump_addr_i,	// 跳转地址
	input wire[`Hold_Flag_Bus]	hold_flag_i,	// 流水线暂停标志

	output reg[`InstAddrBus]	pc_o           	// PC指针

	
);


    always @ (posedge clk) begin
        // 复位
        if (rst == `RstEnable || jtag_reset_flag_i == 1'b1) begin
            pc_o <= `CpuResetAddr;
        // 跳转
        end else if (jump_flag_i == `JumpEnable) begin
            pc_o <= jump_addr_i;
        // 暂停
        end else if (hold_flag_i >= `Hold_Pc) begin
            pc_o <= pc_o;
        // 地址加4
        end else begin
            pc_o <= pc_o + 4'h4;
        end
    end

endmodule