`timescale 1ns / 1ps
module ALU(
    input  [31:0] A,
    input  [31:0] B,
    input  [2:0]  ALUControl,   // selects op
    input         is_arith_shift, // NEW: 1 for SRA/SRAI, 0 for SRL/SRLI
    input         is_unsigned_cmp, // NEW: 1 for SLTU/SLTIU, 0 for SLT/SLTI
    output [31:0] Result,
    output        Zero,
    output        Negative,
    output        Carry,
    output        Overflow
);

    wire [31:0] sum, mux1;
    wire cout;

    // ADD/SUB block (unchanged idea)
    assign mux1      = (ALUControl == 3'b001) ? ~B : B;  // use SUB when control=001
    assign {cout,sum} = A + mux1 + (ALUControl == 3'b001);

    // Logic ops
    wire [31:0] a_and_b = A & B;
    wire [31:0] a_or_b  = A | B;
    wire [31:0] a_xor_b = A ^ B;

    // Shifts (shamt = low 5 bits of B)
    wire [4:0] shamt    = B[4:0];
    wire [31:0] sll_res = A << shamt;
    wire [31:0] srl_res = A >> shamt;
    wire [31:0] sra_res = $signed(A) >>> shamt;
    wire [31:0] shift_res = is_arith_shift ? sra_res : srl_res;

    // SLT / SLTU
    wire signed_lt   = ($signed(A) < $signed(B));
    wire unsigned_lt = (A < B);
    wire slt_bit     = is_unsigned_cmp ? unsigned_lt : signed_lt;
    wire [31:0] slt_res = {31'b0, slt_bit};

    reg [31:0] res_r;
    assign Result = res_r;

    always @(*) begin
        case (ALUControl)
            3'b000: res_r = sum;        // ADD / ADDI / address calc
            3'b001: res_r = sum;        // SUB
            3'b010: res_r = a_and_b;    // AND / ANDI
            3'b011: res_r = a_or_b;     // OR / ORI
            3'b100: res_r = slt_res;    // SLT / SLTU / SLTI / SLTIU
            3'b101: res_r = a_xor_b;    // XOR / XORI
            3'b110: res_r = sll_res;    // SLL / SLLI
            3'b111: res_r = shift_res;  // SRL / SRLI / SRA / SRAI
            default: res_r = 32'h0;
        endcase
    end

    assign Zero     = (Result == 32'h0);
    assign Negative = Result[31];
    assign Carry    = cout;   // only meaningful for add/sub
    assign Overflow = 1'b0;   // can refine later if needed

endmodule
