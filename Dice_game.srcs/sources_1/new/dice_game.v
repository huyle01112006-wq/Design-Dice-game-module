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
//   game_status: 2'b00 = dang choi, 2'b01 = WIN, 2'b10 = LOSE
// 
//////////////////////////////////////////////////////////////////////////////////


module dice_game(
input clk,
input  rst,
input RTN, // roll button
output reg [3:0] SUM_0,
output reg [3:0] point_out,
output reg [1:0] game_status   // 00: playing, 01: WIN, 10: LOSE
);
reg [3:0] dice_1  ; 
reg [3:0]dice_2 ;
reg [3:0] POINT = 4'b0; 

reg rtn1, rtn2 ;
wire rtn_fall_edge ;
always@(posedge clk or posedge rst) begin 
if(rst) begin 
rtn1 <= 1 ; 
rtn2 <= 1 ;
end
else begin 
rtn1 <= RTN; 
rtn2 <= rtn1 ;
end
end
assign rtn_fall_edge = rtn2 & (~rtn1) ;

always@(posedge clk or posedge rst) begin
if(rst) begin 
dice_1 <= 4'd1; 
dice_2 <= 4'd1 ;
end else begin
if(dice_1 >=6) begin
dice_1 <= 4'b0001 ;
if(dice_2 >= 6) dice_2 <= 4'b0001 ;
else dice_2 <= dice_2 + 1;
end
else dice_1 <= dice_1 + 1;
end
end
reg [2:0] current_state , next_state ;
localparam [2:0] S_IDLE = 3'b000 , S_FIRST = 3'b001, S_NEXT_ROLL = 3'b010, 
S_WIN = 3'b011 , S_LOSE = 3'b100;
localparam [1:0] G_PLAYING = 2'b00 , G_WIN = 2'b01 , G_LOSE = 2'b10;
wire [3:0] sum_i = dice_1 + dice_2 ;
always@(posedge clk or posedge rst)begin
if(rst) begin 
current_state <= S_IDLE ;
POINT <= 4'd0 ; 
SUM_0 <= 4'd0 ;
game_status <= G_PLAYING ;
end
else begin 
current_state <= next_state;
case(current_state)
S_IDLE: begin 
POINT <= 4'd0 ; 
SUM_0 <= 4'd0 ; 
game_status <= G_PLAYING ;
end
S_FIRST: begin 
if(rtn_fall_edge) begin 
SUM_0<= sum_i ;
if(!(sum_i == 4 || sum_i == 6 || sum_i == 7 || sum_i == 8 || sum_i == 15))
POINT <= sum_i ;
end
end
S_NEXT_ROLL: begin 
if(rtn_fall_edge) begin
SUM_0 <= sum_i  ;
end
end
S_WIN: begin 
game_status <= G_WIN ;
end
S_LOSE: begin 
game_status <= G_LOSE ;
end
endcase
end end

always@(*) begin 
next_state = current_state ;
case(current_state)
S_IDLE: begin 
if(rtn_fall_edge) next_state = S_FIRST;
end
S_FIRST: begin 
if(rtn_fall_edge)begin 
if( sum_i  == 6 || sum_i == 8) next_state = S_WIN ; 
else if( sum_i == 4 ||sum_i == 7 || sum_i== 15) next_state = S_LOSE ; 
else next_state = S_NEXT_ROLL;
end
end
S_NEXT_ROLL: begin 
if(rtn_fall_edge) begin 
if( sum_i == POINT) next_state = S_WIN ; 
else if( sum_i == 9) next_state = S_LOSE ; 
else next_state = S_NEXT_ROLL;
end
end
S_WIN, S_LOSE : begin
next_state = (rst)? S_IDLE: current_state;
end
default: next_state = S_IDLE; 
endcase
end

always@(*) begin 
point_out = POINT; 
end
endmodule
