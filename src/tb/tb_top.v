`timescale 1ns/1ps
`define CLOCK_TIME_HALF 50

`define HEXFILE ".hex"

module tb_top ();
    
    reg clk;
    reg reset;

    integer counter = -1;
    integer FILE;

    wire uart_tx;
    integer r;
    top MiniCPU(
        .clk(clk), 
        .reset(reset),
        .uart_tx(uart_tx)
    );

    always @(*) begin
        #`CLOCK_TIME_HALF clk <= ~clk;
        counter <= counter + 1;
        if(counter >= 350000) begin

            for (r = 0; r < 32; r = r + 1)
                $display("x%2d = 0x%x", r, tb_top.MiniCPU.u_cpu.u_gen_regs.regs[r]);
            $display("\n\n**********************************************");
            $display("*    MiniCPU:        Qi_Ming Zhang_Tairan    *");
            $display("*    Clock Cycles:    %d            *", cycle);
            $display("*    Test Ended ! %t       *", $time);
            $display("**********************************************\n");


            $finish;
        end
    end

    initial begin
        #10
        $display("\n***************** BEGIN TEST *****************");
        reset <= 1'b0;
        clk   <= 1'b0;
        #((`CLOCK_TIME_HALF)*2.1) reset <= 1;
        #((`CLOCK_TIME_HALF)*1.1) reset <= 0;
    end

    initial begin
        imem_init(0, 255);
        dmem_init(0, 255);

        #100
        $write("HEXFILE = ");
        $display(`HEXFILE);
        
        $readmemh(`HEXFILE, MiniCPU.u_imem.imem_reg);
        
        $display("pc = 0x0 : %x", MiniCPU.u_imem.imem_reg[0]);
        $display("pc = 0x4 : %x", MiniCPU.u_imem.imem_reg[1]);
        $display("pc = 0x8 : %x", MiniCPU.u_imem.imem_reg[2]);
        $display(" …………");
    end

    integer i;
    integer cycle = 0;
    always @(negedge clk) begin
        #1
        if(MiniCPU.u_cpu.pc == 32'b0) $display();
       // $write("\npc %x,\t instr %x\t\t\n", MiniCPU.u_cpu.pc, MiniCPU.cpu_imem_data);
        if(MiniCPU.u_cpu.mem_wb_data_pc != 32'b0 && MiniCPU.u_cpu.mem_wb_data_pc >= 32'b0) begin
            // $fwrite(FILE, "%x\n", MiniCPU.u_cpu.pc);
            cycle = cycle + 1;
        end
    end

    initial
    begin
        $dumpfile("./tmp/tb_top.vcd");  //生成的vcd文件名称
        $dumpvars(0, tb_top);       //tb模块名称
    end

    integer ii;
    task imem_init;
        input [4:0] in1, in2;
        begin
            for(ii = in1; ii<=in2; ii = ii+1) begin
                MiniCPU.u_imem.imem_reg[ii] <= 32'bx;
            end
        end
    endtask

    task dmem_init;
        input [4:0] in1, in2;
        begin
            for(ii = in1; ii<=in2; ii = ii+1) begin
                MiniCPU.u_dmem.dmem_reg[ii] <= 32'b0;
            end
        end
    endtask


wire uart_clk   = tb_top.MiniCPU.u_uart.i_uart_tx.next_bit;
wire uart_rst_n = tb_top.MiniCPU.u_uart.i_uart_tx.uart_tx_busy;

uart_display u_uart_display(
    .clk(uart_clk),
    .rst_n(uart_rst_n),
    .uart_tx(uart_tx)
);

endmodule
