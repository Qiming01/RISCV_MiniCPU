/**
* 描述：Regfile 模块实现了32个32位通用整数寄存器，可以同时进行两个寄存器的读操作和一个寄存器的写操作
* @Author:Qi_Ming
* @Date:2022.12.13
*/

`include "defines.v"

module regfile(input wire                   clk,    // 时钟信号
               input wire                   rst,    // 复位信号，高电平有效
               input wire                   we,     // 写使能信号
               input wire[`RegAddrBus]      waddr,  // 要写入的寄存器地址，宽度5位(32个寄存器)
               input wire[`RegBus]          wdata,  // 要写入的数据，宽度32bit
               input wire                   re1,    // 第一个读寄存器端口的 读使能信号
               input wire[`RegAddrBus]      raddr1, // 第一个读寄存器端口的 读取寄存器地址，5bit
               input wire                   re2,    // 第二个读寄存器端口的 读使能信号
               input wire[`RegAddrBus]      raddr2, // 第二个读寄存器端口的 读取寄存器地址，5bit
               
               output reg[`RegBus]          rdata1, // 第一个读寄存器端口的 输出的寄存器的值，宽度32bit
               output reg[`RegBus]          rdata2  // 第二个读寄存器端口的 输出的寄存器的值，宽度32bit
               );
    
    /*******************************************************
    ********************定义32个32位寄存器********************
    *******************************************************/
    reg[`RegBus]  regs[0:`RegNum-1];
    

    /*******************************************************
    *************************写操作**************************
    *******************************************************/
    // ！ 写操作是时序逻辑电路，写操作发生在时钟信号的上升沿
    always @ (posedge clk) begin
        // 当复位信号无效时
        if (rst == `RstDisable) begin
            // 在写使能信号有效时并且操作数不是0号寄存器(0号寄存器只能是0)
            if ((we == `WriteEnable) && (waddr ! = `RegNumLog2'h0)) begin
                // 将要写入的数据写到目的寄存器中
                regs[waddr] <= wdata;
            end
        end
    end
    

    /*******************************************************
    *********************读端口1的读操作**********************
    *******************************************************/
    // ! 读寄存器是组合逻辑电路，一旦输入的要读取的寄存器的地址（addr1和addr2）的值发生了变化，立刻给出新地址对应的寄存器的值
    always @ (*) begin
        // 当复位信号有效时
        if (rst == `RstEnable) begin
            // 第一个读寄存器端口的输出是0
            rdata1 <= `ZeroWord;
            // 当复位信号无效时，如果读取0号寄存器则输出是0
            end else if (raddr1 == `RegNumLog2'h0) begin
            rdata1 <= `ZeroWord;
            // 如果第一个读寄存器端口要读取的目标寄存器与要写入的目的寄存器是同一个寄存器
            end else if ((raddr1 == waddr) && (we == `WriteEnable)
            && (re1 == `ReadEnable)) begin
            // 直接将要写入的值输出
            rdata1 <= wdata;
            // 上述情况都不满足，就可以给出第一个读寄存器端口要读取的目标寄存器地址对应寄存器的值
            end else if (re1 == `ReadEnable) begin
            rdata1 <= regs[raddr1];
            // 第一个读寄存器端口不能使用时，直接输出0
            end else begin
            rdata1 <= `ZeroWord;
        end
    end


     /*******************************************************
    *********************读端口2的读操作**********************
    *******************************************************/   
    always @ (*) begin
        // 当复位信号有效时
        if (rst == `RstEnable) begin
            // 第2个读寄存器端口的输出是0
            rdata2 <= `ZeroWord;
            // 当复位信号无效时，如果读取0号寄存器则输出是0
            end else if (raddr2 == `RegNumLog2'h0) begin
            rdata2 <= `ZeroWord;
            // 如果第2个读寄存器端口要读取的目标寄存器与要写入的目的寄存器是同一个寄存器
            end else if ((raddr2 == waddr) && (we == `WriteEnable)
            && (re2 == `ReadEnable)) begin
            // 直接将要写入的值输出
            rdata2 <= wdata;
            // 上述情况都不满足，就可以给出第2个读寄存器端口要读取的目标寄存器地址对应寄存器的值
            end else if (re2 == `ReadEnable) begin
            rdata2 <= regs[raddr2];
            // 第2个读寄存器端口不能使用时，直接输出0
            end else begin
            rdata2 <= `ZeroWord;
        end
    end
    
endmodule
