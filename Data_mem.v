`timescale 1ns / 1ps
module Data_memory(
    input  [31:0] A,
    output [31:0] RD,
    input         WE,
    input  [31:0] WD,
    input         clk
);

    // 1024 words of 32-bit data memory
    reg [31:0] Data_mem [0:1023];

    // Word address is A[31:2]
    assign RD = Data_mem[A[31:2]];

    always @(posedge clk) begin
        if (WE) begin
            Data_mem[A[31:2]] <= WD;
            $display("MEM WRITE: Address=%d Data=%d", A, WD);
        end
    end

    // ---------- Initialization ----------
    integer j;
    initial begin
        // Clear all memory
        for (j = 0; j < 1024; j = j + 1) begin
            Data_mem[j] = 32'h00000000;
        end
    Data_mem[8] = 32'd23;
    end
    
endmodule