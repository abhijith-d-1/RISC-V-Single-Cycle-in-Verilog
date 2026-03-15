`timescale 1ns / 1ps
module Single_Cycle_Top_tb;

    reg clk,rst;

    Single_Cycle_Top Single_Cycle_Top_module(
        .clk(clk),
        .rst(rst)
        );

    initial begin
        clk = 0;
    end
    always 
    begin
      clk = ~clk;
      #50;
    end

    initial 
    begin
      rst = 1'b0;
      #100;

      rst = 1'b1;
      #10000;
      $finish;
    end


endmodule
