`ifndef CLOCK_ITEM_SV
`define CLOCK_ITEM_SV

class clock_item;

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

function void display(string tag);
$display("[%s] Time: %0d%0d:%0d%0d:%02d | Reset: %0b | Time Button: %0b | Alarm Button: %0b | Fast Watch: %0b", tag, time_show_ms_hr[3:0], time_show_ls_hr[3:0], time_show_ms_min[3:0], time_show_ls_min[3:0], time_show_sec, rst, time_button, alarm_button, fast_watch);
endfunction

function clock_item copy();
clock_item cp = new();
cp.rst = this.rst;
cp.alarm_button = this.alarm_button;
cp.time_button = this.time_button;
cp.fast_watch = this.fast_watch;
cp.key = this.key;
cp.time_show_ms_hr = this.time_show_ms_hr;
cp.time_show_ls_hr = this.time_show_ls_hr;
cp.time_show_ms_min = this.time_show_ms_min;
cp.time_show_ls_min = this.time_show_ls_min;
cp.time_show_sec = this.time_show_sec;
cp.sound_alarm = this.sound_alarm;
return cp;
endfunction

endclass

`endif