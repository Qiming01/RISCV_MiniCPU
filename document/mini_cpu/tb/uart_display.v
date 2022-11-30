
module uart_display (
input               clk     , // clock input.
input               rst_n    , // reset_n .
input              uart_tx  // UART transmit pin.

);

reg [9:0]   shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg   <= {10{1'b1}};
    end
    else if(shift_reg[0]==1'b0) begin
        shift_reg   <= {10{1'b1}};
    end
    else begin
        shift_reg   <= {uart_tx,shift_reg[9:1]};
    end
    
end

always @(negedge rst_n) begin

    //$display("uart display: %s \n", shift_reg[8:1]);
    $write("%s", shift_reg[8:1]);
end

endmodule