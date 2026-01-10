`timescale 1ns / 1ps

module Program_counter(clk,rst,PC,PCNext,StallF);
input clk,rst;
input StallF;
input [31:0] PCNext;
output  reg [31:0] PC;

always@(posedge clk)begin

    if(rst) begin
        PC <= 32'h00000000;
        end
    else begin
        if(!StallF)begin
            PC <= PCNext;
        end
    end
end
endmodule
