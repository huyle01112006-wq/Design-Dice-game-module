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


module dice_game_tb();
    reg clk;
    reg rst;
    reg RTN;
    wire [3:0] SUM_0;
    wire [3:0] point_out;
    wire [1:0] game_status;
    dice_game uut (
        .clk(clk), 
        .rst(rst), 
        .RTN(RTN), 
        .SUM_0(SUM_0), 
        .point_out(point_out),
        .game_status(game_status)
    );
    always #5 clk = ~clk;
    task roll_dice;
        begin
            #20;
            RTN = 1'b0; 
            #30;       
            RTN = 1'b1; 
            #80;
        end
    endtask
    initial begin
        clk = 0;
        rst = 1;
        RTN = 1;
        #30;
        rst = 0;
        #20;
        roll_dice();
        roll_dice();
        roll_dice();
        roll_dice();
        #100;
        $finish;
    end
    initial begin
        $monitor("Time = %0t ns | State = %0d | RTN = %b | SUM_0 = %0d | Point = %0d | Status = %0b", 
                 $time, uut.current_state, RTN, SUM_0, point_out, game_status);
    end
endmodule
