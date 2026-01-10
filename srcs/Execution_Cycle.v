`timescale 1ns / 1ps

module Execution_Cycle(clk, rst, RD1_E, RD2_E, PCE, Imm_ExtE, PCPlus4E, RdE, RegWriteE,
                       MemWriteE, JumpE, BranchE, ALUSrcE, ResultSrcE, ALU_CtrlE, 
                       RegWriteM, MemWriteM, PCSrc_out, PCTargetE, ResultSrcM, ALUResultM,
                       WriteDataM, PCPlus4M, RdM, ForwardAE, ForwardBE, ResultW);

//Input Port Declatation
input clk, rst;
input RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE;
input [31:0] RD1_E, RD2_E, PCE, Imm_ExtE, PCPlus4E, ResultW;
input [4:0] RdE;
input [1:0] ResultSrcE;
input [2:0] ALU_CtrlE;
input [1:0] ForwardAE, ForwardBE;

//Output Port Declatation
output RegWriteM,MemWriteM;
output PCSrc_out;
output [1:0] ResultSrcM;
output [31:0] ALUResultM, WriteDataM, PCPlus4M, PCTargetE; 
output [4:0] RdM;

//Interim Wire Declaration
wire Zero_wire;
wire [31:0] SrcBE;
wire [31:0] ALUResult,PCTargetE_w;
wire [31:0] Src_A,Src_B;

//Interim Register /declaration
reg RegWriteE_reg, MemWriteE_reg;
reg [1:0] ResultSrcE_reg;
reg [31:0] ALUResultM_reg, WriteDataE_reg, PCPlus4E_reg;
reg [4:0] RdE_reg;

//Instantiation Of Modules


//ALU SrcA
Wb_Mux ALU_SrcA(.I0(RD1_E),
                .I1(ResultW),
                .I2(ALUResultM),
                .Sel(ForwardAE),
                .Out(Src_A));

//ALU SrcB
Wb_Mux ALU_SrcB(.I0(RD2_E),
                .I1(ResultW),
                .I2(ALUResultM),
                .Sel(ForwardBE),
                .Out(SrcBE));
//ALU SRC B MUX
ExeCy_Mux ExeCy_Mux(.A(SrcBE),
                    .B(Imm_ExtE),
                    .Sel(ALUSrcE),
                    .Y(Src_B));
                
//ALU                                           
ALU ALU(.A(Src_A),
        .B(Src_B),
        .ALU_crtl(ALU_CtrlE),
        .ALU_Result(ALUResult),
        .Zero(Zero_wire),
        .Negative(),
        .Overflow(),
        .Carry());            
            
PC_Adder ExeCy_Adder(.A(PCE),
                     .B(Imm_ExtE),
                     .Y(PCTargetE_w));
                                              

//Registers assignment
always@(posedge clk)begin
    if(rst)begin
        RegWriteE_reg  <= 1'b0 ;
        MemWriteE_reg  <= 1'b0 ;
        ResultSrcE_reg <= 2'b00 ;
        ALUResultM_reg <= 32'h00000000 ;
        WriteDataE_reg <= 32'h00000000 ;
        PCPlus4E_reg   <= 32'h00000000 ;
        RdE_reg        <= 5'h00;
    end
    else begin
        RegWriteE_reg  <= RegWriteE ;
        MemWriteE_reg  <= MemWriteE ;
        ResultSrcE_reg <= ResultSrcE ;
        ALUResultM_reg <= ALUResult  ;
        WriteDataE_reg <= SrcBE ;
        PCPlus4E_reg   <= PCPlus4E ;
        RdE_reg        <= RdE ;    
    end
end

//ouptut assignment
assign PCSrc_out   = JumpE | (BranchE & Zero_wire) ;
assign RegWriteM   = RegWriteE_reg ;
assign MemWriteM   = MemWriteE_reg ;
assign ResultSrcM  = ResultSrcE_reg ;
assign ALUResultM  = ALUResultM_reg ;
assign WriteDataM  = WriteDataE_reg ; 
assign PCPlus4M    = PCPlus4E_reg ; 
assign RdM         = RdE_reg ;
assign PCTargetE   = PCTargetE_w;


endmodule
