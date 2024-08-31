`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2024 05:28:44 PM
// Design Name: 
// Module Name: 32_processor
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

module DECODER_UNIT(clk,instr,opcode,func,rs1_add,rs2_add,rd_add);
input clk;
input [31:0]instr;
output reg [6:0]opcode;
output reg [2:0]func;
output reg [4:0]rs1_add;
output reg [4:0]rs2_add;
output reg [4:0]rd_add;
always@(posedge clk)
begin
opcode = instr[6:0];
rd_add = instr[11:7];
func = instr[14:12];
rs1_add = instr[19:15];
rs2_add = instr[24:20];
end
endmodule



//CONTROL UNIT
module CONTROL_UNIT(clk,func,opcode,operation,invalid);
input clk;
input [2:0]func;
input [6:0]opcode;
output reg [3:0]operation;
output reg invalid=0;
always@(posedge clk)
begin
case(opcode)
7'b000_0001:
begin
if(func==0)
begin
operation=0; //ADD
invalid=0;
end
else if(func==1)
begin
operation=1; //SUB
invalid=0;
end
end
7'b000_0011:
begin
if(func==0)
begin
operation=2; //SLL
invalid=0;
end
else if(func==1)
begin
operation=6; //SRL
invalid=0;
end
else if(func==2)
begin
operation=7; //SRA
invalid=0;
end
end
7'b000_0111:
begin
if(func==0)
begin
operation=3; //SLT
invalid=0;
end
else if(func==1)
begin
operation=4; //SLTU
invalid=0;
end
end
7'b000_1111:
begin
if(func==0)
begin
operation=5; //XOR
invalid=0;
end
else if(func==1)
begin
operation=8; //OR
invalid=0;
end
else if(func==2)
begin
operation=9; //AND
invalid=0;
end
end
default:
begin
operation=0; //ADD
invalid=1;
end
endcase
end
endmodule



//ALU UNIT
module ALU_UNIT(clk,operation,rs1,rs2,rd);
input clk;
input [3:0]operation;
input [31:0]rs1;
input [31:0]rs2;
output reg [31:0]rd;
always@(posedge clk)
begin
case(operation)
0: begin
rd=rs1+rs2; //ADD
end
1: begin
rd=rs1-rs2; //SUB
end
2: begin
rd=rs1<<rs2[4:0]; //SLL
end
3: begin
if(rs1[31]==1 & rs2[31]==0)
rd=1;
else if(rs1[31]==0 & rs2[31]==1)
rd=0;
else
rd=(rs1<rs2)?1:0; //Set Less Than
end
4: begin
rd=(rs1<rs2)?1:0; //Set Less Than Unsigned
end
5: begin
rd=rs1^rs2; //XOR
end
6: begin
rd=rs1>>rs2[4:0]; //SRL
end
7: begin
rd= $signed(rs1) >>>rs2[4:0]; //SRA
end
8: begin
rd=rs1|rs2; //OR
end
9: begin
rd=rs1&rs2; //AND
end
default:
begin
rd=rs1+rs2; //ADD
end
endcase
end
endmodule



//REGISTER BANK
module REG_BANK(clk,rs1_add,rs2_add,rd_add,rd,rs1,rs2);
input clk;
input [4:0]rs1_add,rs2_add,rd_add;
input [31:0]rd;
output reg [31:0]rs1,rs2;
reg [31:0]register[0:31];
always@(posedge clk)
begin
register[0]=32'h0000000F;
register[1]=32'h0000000C;
register[2]=32'hFF0000FF;
register[3]=32'h00000004;
register[4]=32'h70000000;
register[5]=32'hF0000000;
register[6]=32'h00000000;
register[7]=32'h00000001;
rs1=register[rs1_add];
rs2=register[rs2_add];
register[rd_add]=rd;
end
endmodule


//DELAY MODULE
module delay1(clk,rd_add,rdd_add);
input clk;
input [4:0]rd_add;
output reg [4:0]rdd_add;
always@(posedge clk)
begin
rdd_add=rd_add;
end
endmodule

//PROCESSOR MODULE
module micropro_32bit(clk,instr,result,invalid);
input clk;
input [31:0]instr;
output wire [31:0]result;
output wire invalid;
wire [6:0]opcode;
wire [2:0]func;
wire [4:0]rs1_add,rs2_add,rd_add;
wire [3:0]operation;
wire [31:0]rs1,rs2,rd;
wire [4:0]rdd_add1,rdd_add2;
DECODER_UNIT du1(clk,instr,opcode,func,rs1_add,rs2_add,rd_add);
delay1 d1(clk,rd_add,rdd_add1);
delay1 d2(clk,rdd_add1,rdd_add2);
CONTROL_UNIT cu1(clk,func,opcode,operation,invalid);
ALU_UNIT alu1(clk,operation,rs1,rs2,rd);
REG_BANK rb1(clk,rs1_add,rs2_add,rdd_add2,rd,rs1,rs2);
assign result=rd;
endmodule
