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


module dice_game_tb_auto;
    reg clk;
    reg rst;
    reg RTN;
    wire [3:0] SUM_0;
    wire [3:0] point_out;
    dice_game uut (
        .clk(clk), 
        .rst(rst), 
        .RTN(RTN), 
        .SUM_0(SUM_0), 
        .point_out(point_out)
);
    always #5 clk = ~clk;
    task roll_dice;
        begin
            #20;     
            RTN = 0;
            #40;    
            RTN = 1; 
            #100;   
        end
    endtask

    initial begin
        
        clk = 0;
        rst = 1;
        RTN = 1;
        #30;
        rst = 0; 
        #20;
    end
always #170 roll_dice() ;
    initial begin
        $monitor("Time = %0t ns | State = %0d | SUM_0 = %0d | Point = %0d", 
                 $time, uut.current_state, SUM_0, point_out);
    end

endmodule
