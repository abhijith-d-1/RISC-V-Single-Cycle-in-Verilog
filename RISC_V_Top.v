`timescale 1ns / 1ps
module Single_Cycle_Top(
    input clk,
    input rst
);

    wire [31:0] PC_next, PC_in, Instr_reg;
    wire [31:0] RD1_Top, RD2_Top;
    wire [31:0] Imm_out;
    wire [31:0] ALU_data, Data_reg;
    wire [31:0] Mux1_ALU, Mux2_Reg;

    wire [2:0] ALUControl_top;  
    wire       Reg_write, Mem_write, ALU_Src, Result_Src;
    wire       Zero, Branch, PCSrc;
    wire [1:0] Imm_Src;

    // NEW control bits from ALU_decoder
    wire       is_arith_shift;
    wire       is_unsigned_cmp;
   
    //==================== PC + instruction fetch ====================
    PC PC_module(   
        .clk(clk),
        .rst(rst),
        .PC_Next(PC_next),
        .PC(PC_in)
    );
    
    PC_adder PC_adder_module(
        .a(PC_in),
        .b(32'd4),
        .c(PC_next)
    );

    Instr_memory Instr_memory_module(
        .A(PC_in),
        .rst(rst),
        .RD(Instr_reg)
    );

    //==================== Register file ====================
    Reg_file Reg_file_module(
        .A1(Instr_reg[19:15]),
        .A2(Instr_reg[24:20]),
        .A3(Instr_reg[11:7]),
        .RD1(RD1_Top),
        .RD2(RD2_Top),
        .WD3(Mux2_Reg),
        .WE(Reg_write),
        .clk(clk),
        .rst(rst)
    );

    //==================== Immediate generator ====================
    Sign_extend Sign_extend_module(
        .in(Instr_reg),
        .Imm_Src(Imm_Src),
        .out(Imm_out)
    );

    Mux Mux_reg_alu(
        .a(RD2_Top),
        .b(Imm_out),
        .s(ALU_Src),
        .c(Mux1_ALU)
    );
    
    //==================== ALU ====================
    ALU ALU_module(
        .A(RD1_Top),
        .B(Mux1_ALU),
        .ALUControl(ALUControl_top),
        .is_arith_shift(is_arith_shift),
        .is_unsigned_cmp(is_unsigned_cmp),
        .Result(ALU_data),
        .Zero(Zero),
        .Negative(),   // unused
        .Carry(),      // unused
        .Overflow()    // unused
    );
    
    //==================== Control unit ====================
    CU_Top_module CU_Top_module(
        .op   (Instr_reg[6:0]), 
        .Zero (Zero),
        .PCSrc(PCSrc),
        .ResultSrc(Result_Src), 
        .ALUSrc(ALU_Src), 
        .Branch(Branch), 
        .ImmSrc(Imm_Src), 
        .MemWrite(Mem_write), 
        .RegWrite(Reg_write), 
        .func3 (Instr_reg[14:12]), 
        .func7 (Instr_reg[31:25]), 
        .ALUControl(ALUControl_top),
        .is_arith_shift(is_arith_shift),
        .is_unsigned_cmp(is_unsigned_cmp)  
    );

    // ==================== DATA MEMORY (SHARED) ====================
    Data_memory Data_memory_module(
        .A (ALU_data),
        .RD(Data_reg),
        .WE(Mem_write),
        .WD(RD2_Top),
        .clk(clk)
    );

    //==================== Write-back mux ====================
    Mux mux_result(
        .a(ALU_data),
        .b(Data_reg),
        .s(Result_Src),
        .c(Mux2_Reg)
    );

endmodule
