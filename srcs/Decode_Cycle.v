`timescale 1ns / 1ps

module Decode_Cycle(clk,rst,InstrD, PCD, PCPlus4D, RegWriteW, ResultW, RdD, 
                    RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE, ALU_CtrlE, ResultSrcE,
                    RD1_E, RD2_E, PCE, Imm_ExtE, PCPlus4E,
                    RdE, RS1_E, RS2_E, FlashE);

//Input Ports
input clk,rst;
input [31:0] InstrD, PCD, PCPlus4D, ResultW;
input RegWriteW, FlashE;
input [4:0] RdD;

//Output ports
output RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE;
output [31:0] RD1_E, RD2_E, PCE, Imm_ExtE, PCPlus4E;
output [4:0] RdE;
output [1:0] ResultSrcE;
output [2:0] ALU_CtrlE;
//Output ports for Hazard handling
output [4:0] RS1_E, RS2_E;

//Interim wires
wire ALUSrcD, RegWriteD, MemWriteD, JumpD, BranchD ;
wire [1:0]  ResultSrcD, ImmSrcD;
wire [2:0]  ALU_CtrlD;
wire [31:0] RD1_D, RD2_D, Imm_ExtD;

//Interim Registers
reg RegWriteD_reg, MemWriteD_reg, JumpD_reg, BranchD_reg, ALUSrcD_reg;
reg [1:0]  ResultSrcD_reg;
reg [31:0] RD1_D_reg, RD2_D_reg, Imm_ExtD_reg, PCD_reg, PCPlus4D_reg;
reg [4:0]  RdD_reg;
reg [2:0]  ALU_CtrlD_reg;
reg [4:0] RS1_E_reg, RS2_E_reg;

//Instantiation

Control_Unit Control_Unit(.Op(InstrD[6:0]),
                          .funct7(InstrD[31:25]),
                          .funct3(InstrD[14:12]),
                          .ResultSrc(ResultSrcD),
                          .ALUSrc(ALUSrcD),
                          .ImmSrc(ImmSrcD),
                          .RegWrite(RegWriteD),
                          .MemWrite(MemWriteD),
                          .ALU_Ctrl(ALU_CtrlD),
                          .Jump(JumpD),
                          .Branch(BranchD));

Register_File Register_File(.clk(clk),
                            .rst(rst),
                            .A1(InstrD[19:15]),
                            .A2(InstrD[24:20]),
                            .A3(RdD),
                            .RD1(RD1_D),
                            .RD2(RD2_D),
                            .WE_reg(RegWriteW),
                            .WD_reg(ResultW));

Sign_Extender Sign_Extender(.Imm_In(InstrD),
                            .Imm_En(ImmSrcD),
                            .Imm_Ext(Imm_ExtD));

//Registers Assignment

always@(posedge clk )begin
    if(rst)begin
        RegWriteD_reg  <= 1'b0;
        ResultSrcD_reg <= 2'b00;
        MemWriteD_reg  <= 1'b0;
        JumpD_reg      <= 1'b0;
        BranchD_reg    <= 1'b0;
        ALU_CtrlD_reg  <= 3'b000;
        ALUSrcD_reg    <= 1'b0;
        RD1_D_reg      <= 32'h00000000;
        RD2_D_reg      <= 32'h00000000;
        PCD_reg        <= 32'h00000000;
        RdD_reg        <= 5'h00000;
        Imm_ExtD_reg   <= 32'h00000000;
        PCPlus4D_reg   <= 32'h00000000;    
        RS1_E_reg      <= 5'h00;
        RS2_E_reg      <= 5'h00;
    end
    else begin
        if(FlashE)begin
            RegWriteD_reg  <= 1'b0;
            ResultSrcD_reg <= 2'b00;
            MemWriteD_reg  <= 1'b0;
            JumpD_reg      <= 1'b0;
            BranchD_reg    <= 1'b0;
            ALU_CtrlD_reg  <= 3'b000;
            ALUSrcD_reg    <= 1'b0;
            RD1_D_reg      <= 32'h00000000;
            RD2_D_reg      <= 32'h00000000;
            PCD_reg        <= 32'h00000000;
            RdD_reg        <= 5'h00000;
            Imm_ExtD_reg   <= 32'h00000000;
            PCPlus4D_reg   <= 32'h00000000;    
            RS1_E_reg      <= 5'h00;
            RS2_E_reg      <= 5'h00;
        end
        else begin
            RegWriteD_reg  <= RegWriteD;
            ResultSrcD_reg <= ResultSrcD;
            MemWriteD_reg  <= MemWriteD;
            JumpD_reg      <= JumpD;
            BranchD_reg    <= BranchD;
            ALU_CtrlD_reg  <= ALU_CtrlD;
            ALUSrcD_reg    <= ALUSrcD;
            RD1_D_reg      <= RD1_D;
            RD2_D_reg      <= RD2_D;
            PCD_reg        <= PCD;
            RdD_reg        <= InstrD[11:7];
            Imm_ExtD_reg   <= Imm_ExtD;
            PCPlus4D_reg   <= PCPlus4D;
            RS1_E_reg      <= InstrD[19:15];
            RS2_E_reg      <= InstrD[24:20];
        end
    end

end

//Output Assignment
assign RegWriteE  = RegWriteD_reg ;
assign ResultSrcE = ResultSrcD_reg;
assign MemWriteE  = MemWriteD_reg;
assign JumpE      = JumpD_reg;
assign BranchE    = BranchD_reg;
assign ALU_CtrlE  = ALU_CtrlD_reg;
assign ALUSrcE    = ALUSrcD_reg;
assign RD1_E      = RD1_D_reg;
assign RD2_E      = RD2_D_reg;
assign PCE        = PCD_reg;
assign RdE        = RdD_reg;
assign Imm_ExtE   = Imm_ExtD_reg;
assign PCPlus4E   = PCPlus4D_reg;    
assign RS1_E      = RS1_E_reg;
assign RS2_E      = RS2_E_reg;

endmodule
