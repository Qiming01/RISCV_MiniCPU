// 访存数据通路模块
// 把访存阶段读取到的存储器数据，或者是指令执行产生的结果发送流水线的下一级处理。
// 和上面的访存控制模块类似，访存数据通路模块也是根据流水线的冲刷控制信号 flush，判断访存阶段的数据是否需要清零。如果不需要清零，就把上一阶段送过来的数据通过寄存器保存下来。

module ex_mem(
  input         clk,
  input         reset,
  input  [4:0]  in_regWAddr,    //写回寄存器的地址
  input  [31:0] in_regRData2,   //读存储器的数据
  input  [1:0]  ex_result_sel,  //执行结果选择
  input  [31:0] id_ex_data_imm, //指令立即数
  input  [31:0] alu_result,     //ALU运算结果
  input  [31:0] in_pc,          //当前PC值
  input         flush,          //流水线数据冲刷控制信号
  output [4:0]  data_regWAddr,
  output [31:0] data_regRData2,
  output [31:0] data_result,
  output [31:0] data_pc
);

  reg [4:0] reg_regWAddr; 
  reg [31:0] reg_regRData2; 
  reg [31:0] reg_result; 
  reg [31:0] reg_pc; 



  /*ex_result_sel 就是对流水线执行阶段的结果进行选择。
  当（ex_result_sel == 2’h0）时，就选择 ALU 的运算结果；
  当（ex_result_sel == 2’h1）时，就会选择指令解码得到的立即数（其实就是对应 LUI 指令）；
  当（ex_result_sel == 2’h2）时，选择 PC 加 4 的值，也就是下一个 PC 的值。*/
  wire [31:0] resulet_w = (ex_result_sel == 2'h0) ? alu_result :
                          (ex_result_sel == 2'h1) ? id_ex_data_imm :
                          (ex_result_sel == 2'h2) ? (in_pc + 32'h4): 32'h0;

  assign data_regWAddr = reg_regWAddr; 
  assign data_regRData2 = reg_regRData2; 
  assign data_result = reg_result; 
  assign data_pc = reg_pc; 

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_regWAddr <= 5'h0; 
    end else if (flush) begin 
      reg_regWAddr <= 5'h0; 
    end else begin 
      reg_regWAddr <= in_regWAddr; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_regRData2 <= 32'h0; 
    end else if (flush) begin 
      reg_regRData2 <= 32'h0; 
    end else begin 
      reg_regRData2 <= in_regRData2; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_result <= 32'h0; 
    end else if (flush) begin 
      reg_result <= 32'h0; 
    end else begin 
      reg_result <= resulet_w; 
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      reg_pc <= 32'h0; 
    end else if (flush) begin 
      reg_pc <= 32'h0; 
    end else begin 
      reg_pc <= in_pc; 
    end
  end

endmodule