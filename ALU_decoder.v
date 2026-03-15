`timescale 1ns / 1ps
module ALU_decoder(
    input       op5,         // instr[5], distinguishes R vs I sometimes
    input [2:0] func3,
    input       func7,       // instr[30]
    input [1:0] ALUOP,
    output reg [2:0] ALUControl,
    output     is_arith_shift,
    output     is_unsigned_cmp
);

    // For shifts: func7=1 means arithmetic right (SRA/SRAI)
    assign is_arith_shift  = (func3 == 3'b101) && func7;      // SRA / SRAI
    // For compares: func3=011 means unsigned
    assign is_unsigned_cmp = (func3 == 3'b011);               // SLTU / SLTIU

    always @(*) begin
        case (ALUOP)
            2'b00: ALUControl = 3'b000; // ADD for lw, sw, etc.
            2'b01: ALUControl = 3'b001; // SUB for branches (beq/bne etc.)
            2'b10: begin
                case (func3)
                    3'b000: begin
                        // ADD / SUB / ADDI
                        // R-type SUB/SRA indicated by func7=1 and op5=1
                        if (op5 && func7)
                            ALUControl = 3'b001; // SUB
                        else
                            ALUControl = 3'b000; // ADD / ADDI
                    end
                    3'b111: ALUControl = 3'b010; // AND / ANDI
                    3'b110: ALUControl = 3'b011; // OR / ORI
                    3'b100: ALUControl = 3'b101; // XOR / XORI
                    3'b010: ALUControl = 3'b100; // SLT / SLTI
                    3'b011: ALUControl = 3'b100; // SLTU / SLTIU
                    3'b001: ALUControl = 3'b110; // SLL / SLLI
                    3'b101: ALUControl = 3'b111; // SRL / SRLI / SRA / SRAI
                    default: ALUControl = 3'b000;
                endcase
            end
            default: ALUControl = 3'b000;
        endcase
    end

endmodule
