
module top (
  input clk,
  input reset,

  input        uart_rx,
  output       uart_tx,
  output [7:0] led
);

//  wire [31:0] dmem_addr;
  wire        dmem_valid;
  wire        dmem_good;
  wire [31:0] dmem_writeData;
  wire        dmem_memRead;
  wire        dmem_memWrite;
  wire [1:0]  dmem_maskMode;
  wire        dmem_sext;
  wire [31:0] dmem_readData;
  wire [31:0] dmem_readBack;


  wire [31:0] cpu_imem_addr;
  wire [31:0] cpu_imem_data;

  wire [31:0] cpu_dmem_addr;       
  wire [31:0] cpu_dmem_data2cpu;
  wire        cpu_dmem_wen;
  wire [31:0] cpu_dmem_cpu2data;

  wire [31:0] imem_rd_addr;
  wire [31:0] imem_rd_data;

  wire [31:0] dmem_read_data;
  wire [31:0] dmem_write_data;
  wire [31:0] dmem_rd_addr;
  wire        dmem_wen;

  wire [31:0] dmem_rom_read_data;
  wire [31:0] dmem_rom_addr; 

  wire   [31:0] uart_read_data;
  wire   [31:0] uart_write_data;
  wire   [31:0] uart_addr;
  wire          uart_wen;

  cpu u_cpu(
            .clk(clk),
            .reset(reset),
            .imem_addr(cpu_imem_addr),
            .imem_valid(  ),
            .imem_good(1'b1),
            .imem_instr(cpu_imem_data),

            .dmem_addr(cpu_dmem_addr),
            .dmem_valid(dmem_valid),
            .dmem_good(dmem_good),
            .dmem_writeData(cpu_dmem_cpu2data),
            .dmem_memRead(dmem_memRead),
            .dmem_memWrite(cpu_dmem_wen),
            .dmem_maskMode(dmem_maskMode),
            .dmem_sext(dmem_sext),
            .dmem_readData(cpu_dmem_data2cpu),

            .dmem_readBack(dmem_readBack)
            );


sys_bus u_sys_bus(
    .cpu_imem_addr(cpu_imem_addr),
    .cpu_imem_data(cpu_imem_data),
     
    .cpu_dmem_addr(cpu_dmem_addr),          // device addr
    .cpu_dmem_data_in(cpu_dmem_cpu2data),   // cpu -> device
    .cpu_dmem_wen(cpu_dmem_wen),            // cpu -> device
    .cpu_dmem_data_out(cpu_dmem_data2cpu),  // device -> cpu

    .imem_addr(imem_rd_addr),                  // cpu -> imem
    .imem_data(imem_rd_data),                  // imem -> cpu
     
    .dmem_read_data(dmem_read_data),        // dmem -> cpu
    .dmem_write_data(dmem_write_data),      // cpu -> dmem
    .dmem_addr(dmem_rd_addr),               // cpu -> dmem
    .dmem_wen(dmem_wen),                    // cpu -> dmem
     
    .dmem_rom_read_data(dmem_rom_read_data),
    .dmem_rom_addr(dmem_rom_addr),
     
    .uart_read_data(uart_read_data),      // uart -> cpu
    .uart_write_data(uart_write_data),    // cpu -> uart
    .uart_addr(uart_addr),                // cpu -> uart
    .uart_wen(uart_wen)

);

  imem u_imem(
            .addr1(imem_rd_addr[13:2]),
            .imem_o1(imem_rd_data),
            .addr2(dmem_rom_addr[13:2]),
            .imem_o2(dmem_rom_read_data));

  dmem u_dmem(.addr(dmem_rd_addr[13:2]),
            .we(dmem_wen),
            .din(dmem_write_data),
            .clk(~clk),
            .dout(dmem_read_data));

  uart_top u_uart(
                  .rst_n(~reset)
                  ,.clk(clk)
                  ,.uart_rxd(uart_rx) // UART Recieve pin.
                  ,.uart_txd(uart_tx) // UART transmit pin.
                  ,.led(led)

                  ,.uart_read_data(uart_read_data)     // uart -> cpu
                  ,.uart_write_data(uart_write_data)    // cpu -> uart
                  ,.uart_addr(uart_addr)          // cpu -> uart
                  ,.uart_wen(uart_wen)
                  );

endmodule