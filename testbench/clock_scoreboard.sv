`ifndef CLOCK_SCOREBOARD_SV
`define CLOCK_SCOREBOARD_SV

class scoreboard;

mailbox #(clock_item) mon2scb;
int pass_count = 0;
int fail_count = 0;

function new(mailbox #(clock_item) mon2scb);
this.mon2scb = mon2scb;
endfunction

task run();
clock_item item;
logic [3:0] exp_time_show_ms_hr;
logic [3:0] exp_time_show_ls_hr;
logic [3:0] exp_time_show_ms_min;
logic [3:0] exp_time_show_ls_min;
logic [8:0] exp_time_show_sec;
logic sound_alarm;

$display("[SCOREBOARD] Calculating simulation results...");

forever begin
mon2scb.get(item);

if(item.rst) begin
exp_time_show_ms_hr = '0;
exp_time_show_ls_hr = '0;
exp_time_show_ms_min = '0;
exp_time_show_ls_min = '0;
exp_time_show_sec = '0;
sound_alarm = 0;
end

else if(item.time_button || item.alarm_button) begin

exp_time_show_ms_hr = exp_time_show_ls_hr;
exp_time_show_ls_hr = exp_time_show_ms_min;
exp_time_show_ms_min = exp_time_show_ls_min;
exp_time_show_ls_min = item.key;

end

else begin
if(exp_time_show_ms_hr == 4'd2 && exp_time_show_ls_hr == 4'd3 && exp_time_show_ms_min == 4'd5 && exp_time_show_ls_min == 4'd9) begin
exp_time_show_ms_hr = '0;
exp_time_show_ls_hr = '0;
exp_time_show_ms_min = '0;
exp_time_show_ls_min = '0;
end
else if(exp_time_show_ls_hr == 4'd9 && exp_time_show_ms_min == 4'd5 && exp_time_show_ls_min == 4'd9) begin
exp_time_show_ms_hr = exp_time_show_ms_hr + 1'b1;
exp_time_show_ls_hr = '0;
exp_time_show_ms_min = '0;
exp_time_show_ls_min = '0;
end
else if(exp_time_show_ms_min == 4'd5 && exp_time_show_ls_min == 4'd9) begin
exp_time_show_ls_hr = exp_time_show_ls_hr + 1'b1;
exp_time_show_ms_min = '0;
exp_time_show_ls_min = '0;
end
else if(exp_time_show_ls_min == 4'd9 && exp_time_show_sec == 6'd59) begin
exp_time_show_ms_min = exp_time_show_ms_min + 1'b1;
exp_time_show_ls_min = '0;
exp_time_show_sec = '0;
end
else if(exp_time_show_sec == 6'd59) begin
exp_time_show_ls_min = exp_time_show_ls_min + 1'b1;
exp_time_show_sec = '0;
end
else begin
if(!item.fast_watch) begin
exp_time_show_sec = exp_time_show_sec + 1'b1;
end
else begin
exp_time_show_sec = exp_time_show_sec + 1'b1;
if(exp_time_show_ls_min != 4'd9) begin
exp_time_show_ls_min = exp_time_show_ls_min + 1'b1;
end
else begin
exp_time_show_ls_min = '0;
exp_time_show_ms_min = exp_time_show_ms_min + 1'b1;
end

end
end
end

item.display("ITEM");

if(item.time_show_ms_hr[3:0] == exp_time_show_ms_hr && item.time_show_ls_hr[3:0] == exp_time_show_ls_hr && item.time_show_ms_min[3:0] == exp_time_show_ms_min && item.time_show_ls_min[3:0] == exp_time_show_ls_min) begin
$display("[SCOREBOARD SUCCESS] Time: %0d%0d:%0d%0d:%0d%0d", item.time_show_ms_hr[3:0], item.time_show_ls_hr[3:0], item.time_show_ms_min[3:0], item.time_show_ls_min[3:0], (item.time_show_sec / 10), (item.time_show_sec % 10));
pass_count++;
end
else begin
fail_count++;
$display("[SCOREBOARD ERROR] Expected Time: %0d%0d:%0d%0d:%0d%0d | DUT Time: %0d%0d:%0d%0d:%0d%0d", exp_time_show_ms_hr, exp_time_show_ls_hr, exp_time_show_ms_min, exp_time_show_ls_min, (exp_time_show_sec / 10), (exp_time_show_sec % 10), item.time_show_ms_hr[3:0], item.time_show_ls_hr[3:0], item.time_show_ms_min[3:0], item.time_show_ls_min[3:0], (item.time_show_sec / 10), (item.time_show_sec % 10)); end
end
endtask
endclass

`endif