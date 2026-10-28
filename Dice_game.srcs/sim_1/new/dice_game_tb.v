`timescale 1ns / 1ps

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
            #5;
            RTN = 0; 
            #10;   
            RTN = 1;
            #20;   
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
    always #20 roll_dice();
    initial begin
        $monitor("Time = %0t ns | State = %0d | SUM_0 = %0d | Point = %0d", 
                 $time, uut.current_state, SUM_0, point_out);
    end

endmodule