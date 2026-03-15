`timescale 1ns / 1ps
module Instr_memory(A,rst,RD);

    input [31:0]A;
    input rst;

    output [31:0]RD;

    reg [31:0] Instr_mem [1023:0];

    assign RD = (rst == 1'b0) ? 32'h00000000 : Instr_mem[A[31:2]]; 
    integer i;
    initial begin
        
        // default all to NOP = addi x0,x0,0
        for (i = 0; i < 1024; i = i + 1)
            Instr_mem[i] = 32'h00000013;

            Instr_mem[1] = 32'h00A00093;
            Instr_mem[2] = 32'h00300113;
            Instr_mem[3] = 32'h002081B3;
            Instr_mem[4] = 32'h40208233;
            Instr_mem[5] = 32'h0020F2B3;
            Instr_mem[6] = 32'h0020E333;
            Instr_mem[7] = 32'h0020C3B3;
            Instr_mem[8] = 32'h02000413;
            Instr_mem[9] = 32'h00042483;
            Instr_mem[10] = 32'h00918533;
            Instr_mem[11] = 32'h00A42223;

    end
    
endmodule
