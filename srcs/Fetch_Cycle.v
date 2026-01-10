`timescale 1ns / 1ps

module Fetch_Cycle(clk, rst, PCSrcE, PCTargetE, InstrD, PCD, PCPlus4D, StallF, StallD, FlashD);

//Inputs
input clk,rst;
input PCSrcE, StallF, StallD, FlashD;
input [31:0] PCTargetE;

//Output
output [31:0] InstrD, PCD, PCPlus4D;

//Interim Wire
wire [31:0] PCPlus4F, PC_F, PCF;
wire [31:0] RDF;

//Pipeline Registers
reg [31:0] InstrF_reg, PCF_reg, PCPlus4F_reg;

//Instantiations
PC_Mux PC_Mux(.I0(PCPlus4F),
              .I1(PCTargetE),
              .Sel(PCSrcE),
              .Out(PC_F));

Program_counter Program_counter (.clk(clk),
                                 .rst(rst),
                                 .PCNext(PC_F),
                                 .PC(PCF),
                                 .StallF(StallF));

Instruction_Mem Instruction_Mem(.rst(rst),
                                .A(PCF),
                                .RD(RDF));

PC_Adder PC_Adder(.A(PCF),
                  .B(32'd4),
                  .Y(PCPlus4F));

//Registers Assignment
always @(posedge clk) begin
    if (rst) begin
        InstrF_reg   <= 32'h00000000;
        PCF_reg      <= 32'h00000000;
        PCPlus4F_reg <= 32'h00000000;
    end 
    else if (FlashD) begin
        // When FlashD is high, we clear the instruction to a NOP
        // 32'h00000013 is the standard RISC-V NOP (addi x0, x0, 0)
        InstrF_reg   <= 32'h00000013; 
        PCF_reg      <= 32'h00000000;
        PCPlus4F_reg <= 32'h00000000;
    end
    else if (!StallD) begin
        // Normal operation: update registers if not stalled
        InstrF_reg   <= RDF;
        PCF_reg      <= PCF;
        PCPlus4F_reg <= PCPlus4F;
    end
    // else: if StallD is high and no FlashD, registers maintain their current value
end

//output port assignment to registers
assign InstrD   = rst ? 32'h00000000 :  InstrF_reg;
assign PCD      = rst ? 32'h00000000 :  PCF_reg;
assign PCPlus4D = rst ? 32'h00000000 :  PCPlus4F_reg;


endmodule
