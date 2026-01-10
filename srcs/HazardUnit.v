`timescale 1ns / 1ps

module HazardUnit(rst, RegWriteM, RegWriteW, RdM, RdW, RD1_E, RD2_E, ForwardAE, ForwardBE, //Forwading I/O
                  Src1D, Src2D, DestE, ResultSrcE, StallD, StallF, FlashE, FlashD, PCSrc_in);                //Stalling I/O

// Forwarding
//Input Declaration
input rst;
input RegWriteM, RegWriteW;
input [4:0] RdM, RdW, RD1_E, RD2_E;
//Output Declaration
output [1:0] ForwardAE, ForwardBE;

//Stalling
//Input Declaration
input [4:0] Src1D, Src2D, DestE;
input [1:0] ResultSrcE;
input PCSrc_in; //ctrl haz ctrl signal
//Output Declaration
output StallD, StallF, FlashE;
output FlashD; // ctrl haz to flush the fetch registers

FordwardingUnit FordwardingUnit(.rst(rst), 
                                .RegWriteM(RegWriteM), 
                                .RegWriteW(RegWriteW), 
                                .RdM(RdM), 
                                .RdW(RdW), 
                                .RD1_E(RD1_E), 
                                .RD2_E(RD2_E), 
                                .ForwardAE(ForwardAE), 
                                .ForwardBE(ForwardBE));

StallingUnit StallingUnit(.Src1D(Src1D), 
                          .Src2D(Src2D), 
                          .DestE(DestE), 
                          .ResultSrcE(ResultSrcE), 
                          .StallD(StallD), 
                          .StallF(StallF), 
                          .FlashE(FlashE),
                          .FlashD(FlashD), 
                          .PCSrc_in(PCSrc_in));
endmodule
