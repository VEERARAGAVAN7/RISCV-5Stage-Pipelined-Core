`timescale 1ns / 1ps

module Data_Cycle(clk, rst, RegWriteM, MemWriteM, ResultSrcM, ALUResultM, WriteDataM, PCPlus4M, RdM,
                  RegWriteW, ResultSrcW, ALUResultW, ReadDataW, PCPlus4W, RdW );

//Input Declaration
input clk, rst, RegWriteM, MemWriteM;
input [1:0] ResultSrcM;
input [31:0] ALUResultM, WriteDataM, PCPlus4M; 
input [4:0] RdM;

//Output Declaration
output RegWriteW;
output [1:0] ResultSrcW;
output [31:0] ALUResultW, ReadDataW, PCPlus4W;
output [4:0] RdW;

//Interim Wire Declaration
wire [31:0] RD_dm_wire;

//Registers Declaration
reg RegWriteM_reg;
reg [1:0] ResultSrcM_reg;
reg [31:0] ALUResultM_reg, RD_dm_reg, PCPlus4M_reg;
reg [4:0] RdM_reg;

DataMem DataMem(.clk(clk),
                .A(ALUResultM),
                .WE_dm(MemWriteM),
                .WD_dm(WriteDataM),
                .RD_dm(RD_dm_wire));

//Register Assignment
always @(posedge clk)begin
    if(rst) begin
        RegWriteM_reg  <= 1'b0;
        ResultSrcM_reg <= 2'b00;
        ALUResultM_reg <= 32'h00000000;
        RD_dm_reg      <= 32'h00000000;
        PCPlus4M_reg   <= 32'h00000000;
        RdM_reg        <= 5'h00;
    end
    else begin
        RegWriteM_reg  <= RegWriteM;
        ResultSrcM_reg <= ResultSrcM;
        ALUResultM_reg <= ALUResultM;
        RD_dm_reg      <= RD_dm_wire;
        PCPlus4M_reg   <= PCPlus4M;
        RdM_reg        <= RdM;
    end
end

//Output ASsignment
assign RegWriteW  = RegWriteM_reg;
assign ResultSrcW = ResultSrcM_reg;
assign ALUResultW = ALUResultM_reg;
assign ReadDataW  = RD_dm_reg;
assign RdW        = RdM_reg;
assign PCPlus4W   = PCPlus4M_reg;

endmodule
