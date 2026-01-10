`timescale 1ns / 1ps

module StallingUnit(Src1D, Src2D, DestE, ResultSrcE, StallD, StallF, FlashE, FlashD, PCSrc_in);

input [4:0] Src1D, Src2D, DestE;
input [1:0] ResultSrcE;
input PCSrc_in;
output StallD, StallF, FlashE, FlashD;
wire lwStall;

assign lwStall = (((Src1D == DestE) || (Src2D == DestE)) && (ResultSrcE[0] == 1'b1) && (DestE != 5'h00))? 1'b1 : 1'b0;
assign FlashD = PCSrc_in;
assign StallF = lwStall;
assign StallD = lwStall;
assign FlashE = lwStall || PCSrc_in;

endmodule
