`timescale 1ns / 1ps

module ALU(A,B,ALU_crtl,ALU_Result,Zero,Negative,Overflow,Carry);
input [31:0]A,B;
input [2:0]ALU_crtl;
output [31:0]ALU_Result;
output Zero,Negative,Overflow,Carry;

wire [31:0]A_and_B;
wire [31:0]A_or_B;
wire [31:0]B_not;
wire [31:0]B_mux;
wire [31:0]sum; 
wire [31:0]ALU_mux;
wire cout;
wire [31:0]slt;

assign A_and_B = A & B; //AND

assign A_or_B  = A | B; //OR

assign B_not   = ~B; //NOT

assign B_mux   = ALU_crtl[0]? B_not : B ; // mux for sub / add

assign {cout,sum}  = A + B_mux + ALU_crtl[0]; //sum for sub / add

assign slt = {31'b0000000000000000000000000000000,sum[31]};

assign ALU_mux = (ALU_crtl[2:0] == 3'b000) ? sum :
                 (ALU_crtl[2:0] == 3'b001) ? sum : 
                 (ALU_crtl[2:0] == 3'b010) ? A_and_B :
                 (ALU_crtl[2:0] == 3'b011) ? A_or_B :
                 (ALU_crtl[2:0] == 3'b101) ? slt : 32'h00000000 ;
                 
assign ALU_Result = ALU_mux; //Result


//Flag Assignments
assign Zero     = &(~ALU_Result);
assign Negative = ALU_Result[31];
assign Overflow = (~ALU_crtl[1]) & ~(ALU_crtl[0]^A[31]^B[31]) & (sum[31]^A[31]);
assign Carry    = ~ALU_crtl[1] & cout;

endmodule
