`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.10.2026 10:37:44
// Design Name: 
// Module Name: dice_game
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


module dice_game(
input clk,
input  rst,
input RTN, // roll button
output reg [3:0] SUM_0,
output reg [3:0] point_out
);
reg [3:0] dice_1  ; 
reg [3:0]dice_2 ;
reg [3:0] POINT = 4'b0; 
reg [1:0] game_status ;

reg rtn1, rtn2 ;
wire rtn_fall_edge ;
always@(posedge clk or posedge rst) begin 
if(rst) begin 
rtn1 <= 0 ; 
rtn2 <= 0 ;
end
else begin 
rtn1 <= RTN; 
rtn2 <= rtn1 ;
end
end
assign rtn_fall_edge = rtn2 & (~rtn1) ;
always@(posedge clk or posedge rst) begin
if(rst) begin 
dice_1 <= 0; 
dice_2 <= 0 ;
end else begin
if(dice_1 >=6) dice_1 = 4'b0001 ;
else dice_1 = dice_1 + 1;
if(dice_2 >= 6) dice_2 = 4'b0001 ;
else dice_2 = dice_2 + 1;
end
end
reg [2:0] current_state , next_state ;
localparam [2:0] S_IDLE = 3'b000 , S_FIRST = 3'b001, S_NEXT_ROLL = 3'b010, 
S_WIN = 3'b011 , S_LOSE = 3'b100;

always@(posedge clk or posedge rst)begin
if(rst) begin 
current_state <= S_IDLE ;
POINT <= 4'd0 ; 
SUM_0 <= 4'd0 ;
end
else begin 
current_state <= next_state;
case(next_state)
S_IDLE: begin 
POINT <= 4'd0 ; 
SUM_0 <= 4'd0 ; 
end
S_FIRST: begin 
if(rtn_fall_edge) begin 
SUM_0 = dice_1 + dice_2 ;
if(!(SUM_0 == 4 || SUM_0 == 6 || SUM_0 == 7 || SUM_0 == 8 || SUM_0 == 15))
begin POINT <= SUM_0 ;
$display("Value of register POINT: %d", POINT);
end
end
end
S_NEXT_ROLL: begin 
if(rtn_fall_edge) begin
SUM_0 <= dice_1 + dice_2  ;

end
end
S_WIN: begin 
$display("WIN") ;
$finish ;
end
S_LOSE: begin 
$display("LOSE") ; 
$finish ;
end
endcase
end
end
always@(*) begin 
next_state = current_state ; 
case(current_state)
S_IDLE: begin 
if(rtn_fall_edge) next_state <= S_FIRST;
end
S_FIRST: begin 
if(rtn_fall_edge)begin 
if( SUM_0 == 6 || SUM_0 == 8) next_state <= S_WIN ; 
else if( SUM_0 == 4 || SUM_0 == 7 || SUM_0 == 15) next_state <= S_LOSE ; 
else next_state <= S_NEXT_ROLL;
end
end
S_NEXT_ROLL: begin 
if(rtn_fall_edge) begin 
if( SUM_0 == POINT) next_state <= S_WIN ; 
else if( SUM_0 == 9) next_state <= S_LOSE ; 
else next_state <= S_NEXT_ROLL;
end
end
S_WIN, S_LOSE : begin
next_state = (rst)? S_IDLE: current_state;
end
default: next_state <= S_IDLE; 
endcase
end

always@(*) begin 
point_out <= POINT; 
end
endmodule
