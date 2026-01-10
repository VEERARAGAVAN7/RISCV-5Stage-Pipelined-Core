`timescale 1ns / 1ps

module FordwardingUnit(rst, RegWriteM, RegWriteW, RdM, RdW, RD1_E, RD2_E, ForwardAE, ForwardBE);

//Input Declaration
input rst;
input RegWriteM, RegWriteW;
input [4:0] RdM, RdW, RD1_E, RD2_E;

//Output Declaration
output [1:0] ForwardAE, ForwardBE;

assign ForwardAE = (rst == 1'b1) ? 2'b00 : 
                   ((RegWriteM == 1'b1) & (RdM != 5'b00) & (RdM == RD1_E)) ? 2'b10 :
                   ((RegWriteW == 1'b1) & (RdW != 5'b00) & (RdW == RD1_E)) ? 2'b01 : 2'b00;

assign ForwardBE = (rst == 1'b1) ? 2'b00 : 
                   ((RegWriteM == 1'b1) & (RdM != 5'b00) & (RdM == RD2_E)) ? 2'b10 :
                   ((RegWriteW == 1'b1) & (RdW != 5'b00) & (RdW == RD2_E)) ? 2'b01 : 2'b00;
endmodule
