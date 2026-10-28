`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 12:14:01 PM
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
input wire clk ,
input wire rst ,
input wire RTN ,
output reg [3:0] sum_0,
output reg [3:0] point
    );
reg rtn1 , rtn2 ;
reg [3:0] dice_1 , dice_2 ;
wire [3:0] sum_d ;
wire rtn_fall_e; 
reg [3:0] point_out;
reg [2:0] current_state, next_state ; 
localparam [2:0] S_IDLE = 3'b000 , S_FIRST = 3'b001,S_NEXT_ROLL = 3'b010, S_WIN = 3'b011 , S_LOSE = 3'b100 ;
always@(posedge clk  or posedge rst) begin 
if(rst) begin 
rtn1 <= 0; 
rtn2 <= 0 ; 
end
else begin 
rtn1 <= RTN; 
rtn2 <= rtn1;
end
end    
assign rtn_fall_e = rtn2 & (~rtn1) ;

always@(posedge clk or posedge rst) begin 
if(rst) begin 
dice_1 <= 4'd1 ; dice_2 <= 4'd1 ;
end
else begin 
if(dice_1 >= 6) dice_1 <= 4'd1 ;
else dice_1 <= dice_1 + 1 ;
if(dice_2 >= 6 ) dice_2 <= 4'd1 ;
else dice_2 <= dice_2 + 1; 
end
end
assign sum_d = dice_1 + dice_2 ;
always@(posedge clk or posedge rst) begin 
if(rst) begin 
current_state <= S_IDLE; 
point_out <= 4'd0;
sum_0 <= 4'd0 ;
end else begin 
current_state <= next_state;
case(next_state) 
S_IDLE: begin 
sum_0 <= 4'd0 ; 
point_out <= 4'd0 ;
end
S_FIRST: begin
if(rtn_fall_e) begin  sum_0 <= sum_d ; 
if(!(sum_d == 4 || sum_d == 6 || sum_d ==7 || sum_d ==8 || sum_d == 15)) begin 
point_out  <= sum_d ;
$display("VALUE OF POINT REG=%d" , point);
end
end
end
S_NEXT_ROLL: begin
if(rtn_fall_e) begin sum_0 <= sum_d ; end
end
S_WIN: begin 
$display("WIN");
$finish ;
end
S_LOSE: begin 
$display("LOSE");
$finish;
end
endcase
end
end
always@(*) begin 
next_state <= current_state; 
case(current_state)
S_IDLE: begin 
if(rtn_fall_e) next_state <= S_FIRST;
end
S_FIRST: begin 
if(rtn_fall_e) begin
if(sum_d == 6 || sum_d == 8) begin 
next_state <= S_WIN ;
end else if(sum_d == 4 || sum_d ==7 || sum_d == 15) begin 
next_state <= S_LOSE;
end else  begin next_state <= S_NEXT_ROLL; 
end
end
end
S_NEXT_ROLL: begin 
if(rtn_fall_e) begin
if(sum_d == point_out ) next_state <= S_WIN;
else if(sum_d == 9) next_state <= S_LOSE;
else next_state <= S_NEXT_ROLL ;
end
end 
S_WIN, S_LOSE: begin 
next_state=(rst)? S_IDLE : current_state ;
end
endcase
end
always@(*) begin 
point <= point_out ;
end
endmodule
