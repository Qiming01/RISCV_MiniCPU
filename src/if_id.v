module if_id(

	input wire				    clk,    // 时钟信号
	input wire					rst,    // 复位信号
	
    // 来自取指阶段的信号
	input wire[31:0]            if_pc,  // if阶段取出的地址
	input wire[31:0]            if_inst,// 指令的内容

    // 输出给译码阶段的信号
	output reg[31:0]            id_pc,
	output reg[31:0]            id_inst  
	
);

	always @ (posedge clk) begin
		if (rst == 1'b1) begin             // 复位
			id_pc <= 32'h00000000;         // pc为零
			id_inst <= 32'h00000000;       // 指令为零，即空指令
	  end else begin
		  id_pc <= if_pc;                  // 信号传给下一阶段输出
		  id_inst <= if_inst;
		end
	end

endmodule