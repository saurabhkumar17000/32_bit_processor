`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2024 05:39:55 PM
// Design Name: 
// Module Name: pro_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module micropro_32bit_tb();
reg clk;
reg [31:0]instr;
wire [31:0]result;
wire invalid;
micropro_32bit mp1(clk,instr,result,invalid);
initial clk=0;
always #5 clk=~clk;
initial
begin
instr=32'b0000000_00001_00000_000_01000_0000001; //add
#10 instr=32'b0000000_00001_00000_001_01001_0000001; //sub
#10 instr=32'b0000000_00011_00010_000_01010_0000011; //SLL
#10 instr=32'b0000000_00101_00100_000_01011_0000111; //SLT
#10 instr=32'b0000000_00101_00100_001_01100_0000111; //SLTU
#10 instr=32'b0000000_00001_00000_000_01101_0001111; //XOR
#10 instr=32'b0000000_00011_00010_001_01110_0000011; //SRL
#10 instr=32'b0000000_00011_00010_010_01111_0000011; //SRA
#10 instr=32'b0000000_00001_00000_001_10000_0001111; //OR
#10 instr=32'b0000000_00001_00000_010_10001_0001111; //AND
#80 $finish;
end
endmodule
