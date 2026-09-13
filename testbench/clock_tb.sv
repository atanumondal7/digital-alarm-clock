`timescale 1ns/1ps

import clock_pkg::*;

module clock_tb;

logic clk = 0;
always #10 clk = ~clk;

clock_if vif(clk);

environment env;

controller_unit #(.WIDTH(WIDTH)) dut (
.clk(clk),
.rst(vif.rst),
.fast_watch(vif.fast_watch),
.time_button(vif.time_button),
.alarm_button(vif.alarm_button),
.key(vif.key),
.time_show_ms_hr(vif.time_show_ms_hr),
.time_show_ls_hr(vif.time_show_ls_hr),
.time_show_ms_min(vif.time_show_ms_min),
.time_show_ls_min(vif.time_show_ls_min),
.time_show_sec(vif.time_show_sec),
.sound_alarm(vif.sound_alarm)
);

initial begin

$dumpfile("Waves.vcd");
$dumpvars(0, clock_tb);

vif.rst = '0;
vif.fast_watch = '0;
vif.time_button = '0;
vif.alarm_button = '0;
vif.key = '0;

env = new(vif);

env.test();

end
endmodule