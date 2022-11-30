
module pc_gen(
    reset,
    clk,
    alu_result,
    branch_add,
    hazard_pcStall,
    hazard_pcFromTaken,
    id_ex_ctrl_data_ex_ctrl_jump,
    pre_pc,
    pc_o
);

input         reset;
input         clk;
input [31:0]  alu_result;
input [31:0]  branch_add;
input         hazard_pcStall;
input         hazard_pcFromTaken;
input [1:0]   id_ex_ctrl_data_ex_ctrl_jump;
input [31:0]  pre_pc;

output [31:0] pc_o;

reg [31:0] pc;

wire [31:0] next_pc = alu_result[0] ? branch_add : pc + 32'h4; 

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      pc <= 32'h0; 
    end else if (!(hazard_pcStall)) begin 
      if (hazard_pcFromTaken) begin 
        if (id_ex_ctrl_data_ex_ctrl_jump[1]) begin 
          pc <= alu_result;
        end else begin
          pc <= next_pc;
        end
      end else begin
        pc <= pre_pc;
      end
    end
  end

  assign pc_o = pc;

endmodule