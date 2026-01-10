`timescale 1ns / 1ps

module Register_File(clk,rst,A1,A2,A3,RD1,RD2,WE_reg,WD_reg);

input clk,rst,WE_reg;
input [4:0] A1,A2,A3;
input [31:0] WD_reg;
output [31:0] RD1,RD2;
integer i;
reg [31:0] Register [31:0];

assign RD1 = (rst) ? 32'h00000000 : Register[A1];
assign RD2 = (rst) ? 32'h00000000 : Register[A2];

always@(posedge clk) begin
    if(WE_reg)begin
        Register[A3] <= WD_reg;
    end
end

initial begin
    for(i=0;i<32;i=i+1)begin
        Register[i] <= 32'h00000000;
    end
        Register[6] <= 32'h00000004;
        Register[19] <= 32'h00000002;
        Register[31] <= 32'h00000003;
        Register[31] <= 32'h00000003;
        Register[20] <= 32'h00000006;
end

endmodule
