// pc_reg
// 

`include "defines.v"

module pc_reg(

	input wire					clk,    // 复位信号
	input wire					rst,    // 时钟信号
	
	output reg[31:0]            pc,     // 要读取的指令地址
	output reg                  ce      // 指令存储器使能信号
	
);

    always @ (posedge clk) begin        
		if (rst == 1'b1) begin          // 复位信号有效
			ce <= `ChipDisable;         // 复位时存储器禁止使用
		end else begin
			ce <= `ChipEnable;          // 复位完成重新使能
		end
	end

	always @ (posedge clk) begin
		if (ce == `ChipDisable) begin   // 芯片禁止信号有效 1'b0
			pc <= 32'h00000000;         // pc复位为全0
		end else begin
	 		pc <= pc + 4'h4;            // 下一个时钟周期pc+4
		end
	end

endmodule