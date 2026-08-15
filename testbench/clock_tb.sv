`timescale 1ns/1ps

module clock_tb;

logic clk;
logic rst;
logic alarm_button;
logic time_button;
logic fast_watch;
logic [3:0] key;
logic [7:0] time_show_ms_hr;
logic [7:0] time_show_ls_hr;
logic [7:0] time_show_ms_min;
logic [7:0] time_show_ls_min;
logic [7:0] time_show_sec;
logic sound_alarm;

controller_unit dut (
.clk(clk),
.rst(rst),
.alarm_button(alarm_button),
.time_button(time_button),
.fast_watch(fast_watch),
.key(key),
.time_show_ms_hr(time_show_ms_hr),
.time_show_ls_hr(time_show_ls_hr),
.time_show_ms_min(time_show_ms_min),
.time_show_ls_min(time_show_ls_min),
.time_show_sec(time_show_sec),
.sound_alarm(sound_alarm)
);

initial begin
clk = 0;
end

always begin
#10 clk = ~clk;
end

initial begin

$monitor("Alarm is ringing! - %0b", sound_alarm);

rst = 1; #15;
rst = 0; #6;

fast_watch = 0;

time_button = 1; #20;
time_button = 0; #20; key = 4'd1; #20; key = 4'd2; #20; 
key = 4'd3; #20; key = 4'd4; #20;

alarm_button = 1; #20;
alarm_button = 0; #20; key = 4'd1; #20; key = 4'd2; #20; 
key = 4'd3; #20; key = 4'd5; #20;

repeat (130) begin
$display("Time: %0d%0d:%0d%0d:%02d", time_show_ms_hr[3:0], time_show_ls_hr[3:0], time_show_ms_min[3:0], time_show_ls_min[3:0], time_show_sec);

#5130;
end

$finish;

end

endmodule