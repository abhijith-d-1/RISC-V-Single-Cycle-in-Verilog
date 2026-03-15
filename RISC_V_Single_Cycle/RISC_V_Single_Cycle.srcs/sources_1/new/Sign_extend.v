`timescale 1ns / 1ps
module Sign_extend(in, Imm_Src, out);
    input  [31:0] in;           // Raw 32-bit instruction
    input  [1:0]  Imm_Src;      // 00=I, 01=S, 10=B, 11=U/J
    output [31:0] out;          // 32-bit signed immediate

    wire [31:0] imm_I, imm_S, imm_B, imm_UJ;

    assign imm_I = {{20{in[31]}}, in[31:20]};

    assign imm_S = {{20{in[31]}}, in[31:25], in[11:7]};

    assign imm_B = {{19{in[31]}}, in[31], in[7], in[30:25], in[11:8], 1'b0};

    assign imm_J = {{11{in[31]}}, in[31], in[19:12], in[20], in[30:21], 1'b0};

    assign out = (Imm_Src == 2'b00) ? imm_I  :  // LOAD/ADDI/JALR
                 (Imm_Src == 2'b01) ? imm_S  :  // STORE  
                 (Imm_Src == 2'b10) ? imm_B  :  // BRANCH
                 (Imm_Src == 2'b11) ? imm_J :  // JAL
                 32'h0;                          // Default

endmodule
