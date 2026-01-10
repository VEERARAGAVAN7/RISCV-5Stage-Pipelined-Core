`timescale 1ns / 1ps

module RISCV_Top(clk,rst);

//input Ports
input clk,rst;

//Interim Wire
wire RegWriteM, MemWriteM, RegWriteE, MemWriteE, RegWriteW, ALUSrcE, PCSrc;
wire Branch, Jump;
wire [31:0] InstrD, PC, PCE ;
wire [31:0] RD1_E, RD2_E, Imm_ExtE, PCTargetE, ALUResultE, ALUResultW; 
wire [31:0] PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W;
wire [31:0] WriteDataM, ResultW, ReadDataW;
wire [1:0] ResultSrcD, ResultSrcE, ResultSrcW;
wire [2:0] ALU_CtrlE; 
wire [4:0] RdE, RdM, RdW, RS1_E, RS2_E;

//hazard handling wires
wire [1:0] ForwardAE, ForwardBE;
wire StallF, StallD, FlashE, FlashD;

//Instantiation of modules

//FETCH CYCLE
Fetch_Cycle Fetch_Cycle(.clk(clk),
                        .rst(rst),
                        .PCSrcE(PCSrc),
                        .PCTargetE(PCTargetE),
                        .InstrD(InstrD),
                        .PCD(PC),
                        .PCPlus4D(PCPlus4D),
                        .StallF(StallF), //Stall input to fetch cycle (Program counter)
                        .StallD(StallD),
                        .FlashD(FlashD)); //Stall input to fetch cycle (Registers)

//DECODE CYCLE
Decode_Cycle Decode_Cycle(.clk(clk),
                          .rst(rst),
                          .InstrD(InstrD), 
                          .PCD(PC), 
                          .PCPlus4D(PCPlus4D), 
                          .RegWriteW(RegWriteW), 
                          .ResultW(ResultW), 
                          .RdD(RdW), 
                          .RegWriteE(RegWriteE),           
                          .MemWriteE(MemWriteE), 
                          .JumpE(Jump), 
                          .BranchE(Branch), 
                          .ALUSrcE(ALUSrcE), 
                          .ResultSrcE(ResultSrcD), 
                          .ALU_CtrlE(ALU_CtrlE),
                          .RD1_E(RD1_E), 
                          .RD2_E(RD2_E), 
                          .PCE(PCE), 
                          .Imm_ExtE(Imm_ExtE), 
                          .PCPlus4E(PCPlus4E), 
                          .RdE(RdE),
                          .RS1_E(RS1_E), //Forwarding output
                          .RS2_E(RS2_E), //Forwarding output
                          .FlashE(FlashE)); //Flush input 
                          
                          
//EXECUTION CYCLE                                                 
Execution_Cycle Execution_Cycle(.clk(clk),
                                .rst(rst), 
                                .RD1_E(RD1_E), 
                                .RD2_E(RD2_E), 
                                .PCE(PCE), 
                                .Imm_ExtE(Imm_ExtE), 
                                .PCPlus4E(PCPlus4E), 
                                .RdE(RdE),
                                .RegWriteE(RegWriteE),
                                .MemWriteE(MemWriteE), 
                                .JumpE(Jump), 
                                .BranchE(Branch), 
                                .ALUSrcE(ALUSrcE), 
                                .ResultSrcE(ResultSrcD), 
                                .ALU_CtrlE(ALU_CtrlE),
                                .PCSrc_out(PCSrc),
                                .PCTargetE(PCTargetE), 
                                .RegWriteM(RegWriteM),
                                .MemWriteM(MemWriteM),
                                .ResultSrcM(ResultSrcE),
                                .ALUResultM(ALUResultE),
                                .WriteDataM(WriteDataM),
                                .PCPlus4M(PCPlus4M),
                                .RdM(RdM),
                                .ForwardAE(ForwardAE), //Forwarding Stuffs
                                .ForwardBE(ForwardBE),
                                .ResultW(ResultW)); 
                                
//DATA MEMORY CYCLE
Data_Cycle Data_Cycle(.clk(clk), 
                      .rst(rst), 
                      .RegWriteM(RegWriteM), 
                      .MemWriteM(MemWriteM), 
                      .ResultSrcM(ResultSrcE), 
                      .ALUResultM(ALUResultE), 
                      .WriteDataM(WriteDataM), 
                      .PCPlus4M(PCPlus4M), 
                      .RdM(RdM),
                      .RegWriteW(RegWriteW), 
                      .ResultSrcW(ResultSrcW), 
                      .ALUResultW(ALUResultW), 
                      .ReadDataW(ReadDataW),
                      .PCPlus4W(PCPlus4W),
                      .RdW(RdW));

//WRITE BACK CYCLE
WriteBack_Cycle WriteBack_Cycle(.clk(clk),
                                .rst(rst),
                                .ResultSrcW(ResultSrcW), 
                                .ALUResultW(ALUResultW), 
                                .ReadDataW(ReadDataW), 
                                .PCPlus4W(PCPlus4W), 
                                .ResultW(ResultW));
//HAZARD HANDLING UNIT
HazardUnit HazardUnit(.rst(rst), 
                      .RegWriteM(RegWriteM), 
                      .RegWriteW(RegWriteW), 
                      .RdM(RdM), 
                      .RdW(RdW), 
                      .RD1_E(RS1_E), 
                      .RD2_E(RS2_E), 
                      .ForwardAE(ForwardAE), 
                      .ForwardBE(ForwardBE),
                      .Src1D(InstrD[19:15]), 
                      .Src2D(InstrD[24:20]), 
                      .DestE(RdE), 
                      .ResultSrcE(ResultSrcD), 
                      .StallD(StallD), 
                      .StallF(StallF), //stall output to fetch cycle
                      .FlashE(FlashE),
                      .FlashD(FlashD),
                      .PCSrc_in(PCSrc)); //input crtl signal from execution stage for control hazards


endmodule
