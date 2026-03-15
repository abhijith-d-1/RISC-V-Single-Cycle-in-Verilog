`timescale 1ns / 1ps
module Reg_file(A1,A2,A3,WE,clk,rst,WD3,RD1,RD2);

    input [4:0]A1,A2,A3;
    input WE,clk,rst;
    input [31:0]WD3;

    output [31:0]RD1,RD2;

    reg [31:0] Registers [1023:0];

    assign RD1 = (rst == 1'b0) ? 32'h00000000 : Registers[A1];
    assign RD2 = (rst == 1'b0) ? 32'h00000000 : Registers[A2];

    always @(posedge clk)
    begin

        if (WE == 1'b1 )
        begin
          Registers[A3] <= WD3;
        end  
          
    end
    
    integer i;
    initial begin
    // Clear everything to 0 first (avoid Xs)
    for (i = 0; i < 32; i = i + 1)
        Registers[i] = 32'h00000000;
    
        // Now set some useful starting values
        Registers[1]  = 32'h00000020; // x1 = base address 0x20
        Registers[2]  = 32'h00000008; // x2 = 8  (will store to memory)
       
    end


endmodule   
