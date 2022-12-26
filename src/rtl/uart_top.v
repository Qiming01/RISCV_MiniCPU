// 
// Module: uart_top
//

module uart_top (
input               clk     , // Top level system clock input.
input               rst_n    , // reset_n .
input   wire        uart_rxd, // UART Recieve pin.
output  wire        uart_txd, // UART transmit pin.
output  wire [7:0]  led,

output  [31:0] uart_read_data,     // uart -> cpu
input   [31:0] uart_write_data,    // cpu -> uart
input   [31:0] uart_addr,          // cpu -> uart
input          uart_wen
);

// Clock frequency in hertz.
parameter CLK_HZ = 10_000000;
parameter BIT_RATE =   9600;
parameter PAYLOAD_BITS = 8;

wire [PAYLOAD_BITS-1:0]  uart_rx_data;
wire        		     uart_rx_valid;
wire        		     uart_rx_break;

wire        		     uart_tx_busy;
wire [PAYLOAD_BITS-1:0]  uart_tx_data;
wire        		     uart_tx_en;

reg  [PAYLOAD_BITS-1:0]  led_reg;


assign      led = led_reg;

// ------------------------------------------------------------------------- 

//assign uart_tx_data = uart_rx_data;
//assign uart_tx_en   = uart_rx_valid;

assign uart_tx_data   = uart_tx_busy ? 8'b0 : uart_write_data[PAYLOAD_BITS-1:0];
assign uart_tx_en     = uart_tx_busy ? 1'b0 : uart_wen;
assign uart_read_data = uart_wen    ? 32'b0 : {24'b0,uart_rx_data};

always @(posedge clk) begin
    if(!rst_n) begin
        led_reg <= 8'hF0;
    end else if(uart_rx_valid) begin
        led_reg <= uart_rx_data[7:0];
    end else if (uart_wen) begin
        led_reg <= uart_write_data[7:0];
    end
end

// ------------------------------------------------------------------------- 
//
// UART RX
uart_rx #(
.BIT_RATE(BIT_RATE),
.PAYLOAD_BITS(PAYLOAD_BITS),
.CLK_HZ  (CLK_HZ  )
) i_uart_rx(
.clk          (clk          ), // Top level system clock input.
.resetn       (rst_n         ), // Asynchronous active low reset.
.uart_rxd     (uart_rxd     ), // UART Recieve pin.
.uart_rx_en   (1'b1         ), // Recieve enable
.uart_rx_break(uart_rx_break), // Did we get a BREAK message?
.uart_rx_valid(uart_rx_valid), // Valid data recieved and available.
.uart_rx_data (uart_rx_data )  // The recieved data.
);

//
// UART Transmitter module.
//
uart_tx #(
.BIT_RATE(BIT_RATE),
.PAYLOAD_BITS(PAYLOAD_BITS),
.CLK_HZ  (CLK_HZ  )
) i_uart_tx(
.clk          (clk          ),
.resetn       (rst_n         ),
.uart_txd     (uart_txd     ),
.uart_tx_en   (uart_tx_en   ),
.uart_tx_busy (uart_tx_busy ),
.uart_tx_data (uart_tx_data ) 
);


endmodule
