
`timescale 1 ns / 1 ns

module alu_8bit_tb;
  reg[7:0] a, b;
  reg cin;
  reg[3:0] aluop;
  wire[7:0] y;
  integer idx;

  //对alu模块进行例化，类似于软件程序中的函数调用
  alu_8bit u_alu(.a(a), .b(b), .cin(cin), .aluop(aluop), .y(y));

  initial 
  begin
    //给 a 和 b 赋初值
    a = 8'h93;
    b = 8'hA7;
    for (idx = 0;  idx <= 15;  idx = idx + 1) 
    begin
      // 循环产生运算指令 aluop 的值
      aluop = idx;
      // 当指令 aluop = 7 时是加法操作，设定进位值cin=1
      if (idx == 7)
        cin = 1'b1;
      else
        cin = 1'b0;
      //每产生一个指令延时10ns
      #10
      // 延时之后打印出运算结果
      $display("%t: a=%h, b=%h, cin=%b, aluop=%h, y=%h", $time, a, b, cin, aluop, y);
    end 
  end
  
initial
begin
  $dumpfile("wave.vcd");        //生成波形文件vcd的名称
  $dumpvars(0, alu_8bit_tb);        //tb模块名称
end

endmodule