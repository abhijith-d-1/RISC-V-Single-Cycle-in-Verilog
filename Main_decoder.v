`timescale 1ns / 1ps
module Main_decoder(op, func3, Zero, PCSrc, ResultSrc, ALUSrc, ImmSrc, 
                    MemWrite, RegWrite, ALUOP);
    input [6:0]op;
    input [2:0] func3;
    input Zero;

    output PCSrc, ResultSrc, ALUSrc, MemWrite, RegWrite;
    output [1:0]ImmSrc;
    output [1:0]ALUOP;

    wire Branch,Jump;

    assign Branch           = 1'b0;
    assign Jump             = (op == 7'b1100111) ? 1'b1 : 1'b0;

    assign MemWrite         = (op == 7'b0100011) ? 1'b1 : 1'b0;  //S-type

    assign RegWrite         = (op == 7'b0000011 | op == 7'b0110011 | op == 7'b0010011) ? 1'b1 : 1'b0;  //R,I-type

    assign ALUOP            = (op == 7'b0110011 || op == 7'b0010011) ? 2'b10 :  // R-type + I-type ALU
                              (op == 7'b1100011) ? 2'b01 : 2'b00;  // loads/stores etc. → ADD

    assign ResultSrc        = (op == 7'b0000011 | op == 7'b0010011) ? 1'b1 : 1'b0; 	//I-type
    
    assign ImmSrc           = (op == 7'b0100011) ? 2'b01 :	//S-type
                              (op == 7'b1100011) ? 2'b10 :	//B-type
                              (op == 7'b1100011) ? 2'b11 : 2'b00;	//J-type o.w I type

    assign ALUSrc           = (op == 7'b0000011 | op == 7'b0100011 | op == 7'b0010011) ?  1'b1 :1'b0; //I-type (if imm)

    assign PCSrc             = (Branch & Zero);

endmodule