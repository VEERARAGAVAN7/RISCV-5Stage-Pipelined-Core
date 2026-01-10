`timescale 1ns / 1ps

module RISV_V_TB();

//Input Declaration
reg clk = 0,rst;

//Instantiation of Top module
RISCV_Top RISCV_Top(.clk(clk),
                    .rst(rst));

always #50 clk = ~clk;

initial begin
    rst <= 1'b1;
    #200;
    rst <= 1'b0;
    #1200;
    $finish;
end

initial begin
    $dumpfile("RISC_V_Pipelined.vcd");
    $dumpvars(0);
end

endmodule
