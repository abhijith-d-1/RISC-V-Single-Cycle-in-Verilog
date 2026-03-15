module CU_Top_module(
    input  [6:0] op, func7,
    input  [2:0] func3,
    input        Zero,
    output       PCSrc, ResultSrc, ALUSrc, Branch, MemWrite, RegWrite,
    output [1:0] ImmSrc,
    output [2:0] ALUControl,
    output       is_arith_shift,
    output       is_unsigned_cmp
);
    wire [1:0] ALUOP;

    Main_decoder Main_decoder(
        .op(op), 
        .Zero(Zero), 
        .PCSrc(PCSrc), 
        .ResultSrc(ResultSrc), 
        .ALUSrc(ALUSrc), 
        .ImmSrc(ImmSrc), 
        .MemWrite(MemWrite), 
        .RegWrite(RegWrite), 
        .ALUOP(ALUOP),
        .func3(func3)      
    );

    ALU_decoder ALU_decoder(
        .op5(op[5]),
        .func3(func3),
        .func7(func7[5]),
        .ALUOP(ALUOP),
        .ALUControl(ALUControl),
        .is_arith_shift(is_arith_shift),
        .is_unsigned_cmp(is_unsigned_cmp)
    );
endmodule
