`timescale 1ns/1ps

`ifndef CLOCK_INTERFACE_SV
`define CLOCK_INTERFACE_SV

import clock_pkg::*;

interface clock_if (input logic clk);

logic rst;
logic alarm_button;
logic time_button;
logic fast_watch;
logic [WIDTH-1:0] key;
logic [7:0] time_show_ms_hr;
logic [7:0] time_show_ls_hr;
logic [7:0] time_show_ms_min;
logic [7:0] time_show_ls_min;
logic [7:0] time_show_sec;
logic sound_alarm;

clocking cb @(posedge clk);
default input #1 output #1;
output rst;
output alarm_button;
output time_button;
output fast_watch;
output key;
input time_show_ms_hr;
input time_show_ls_hr;
input time_show_ms_min;
input time_show_ls_min;
input time_show_sec;
input sound_alarm;
endclocking

endinterface

`endif