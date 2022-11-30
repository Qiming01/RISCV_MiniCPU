module dmem(
    input [11:0] addr,
    input we,
    input [31:0] din,
    input clk,

    output reg [31:0] dout
);
    reg[31:0] dmem_reg[0:4095];

    always @(posedge clk) begin
        if(we) begin
            dmem_reg[addr] <= din;
        end
        dout <= dmem_reg[addr];
    end
endmodule


module imem (
    input  [11:0] addr1,
    output [31:0] imem_o1,
    input  [11:0] addr2,
    output [31:0] imem_o2
);
    reg [31:0] imem_reg[0:4096];

    assign imem_o1 = imem_reg[addr1];
    assign imem_o2 = imem_reg[addr2];

endmodule
