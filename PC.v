`timescale 1ns / 1ps
module PC(clk,rst,PC_Next,PC);

    input clk,rst;
    input [31:0]PC_Next;
    output reg[31:0]PC;

    always @(posedge clk )
    begin

      if (rst == 1'b0)
      begin
        PC <= {32{1'b0}};
      end
      
      else
      begin
        PC <= PC_Next;
      end

    end

endmodule

