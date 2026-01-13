`timescale 1ns / 1ps

module WriteBack_Cycle(ResultSrcW, ALUResultW, ReadDataW, PCPlus4W, ResultW );

//Input Declaration
//input clk,rst;
input [1:0] ResultSrcW;
input [31:0] ALUResultW, ReadDataW, PCPlus4W;

//Output Declaration
output [31:0] ResultW;

Wb_Mux Wb_Mux(.I0(ALUResultW),
              .I1(ReadDataW),
              .I2(PCPlus4W),
              .Sel(ResultSrcW),
              .Out(ResultW));
endmodule
