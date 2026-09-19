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

else if(item.time_button) begin

exp_time_show_ms_hr = exp_time_show_ls_hr;
exp_time_show_ls_hr = exp_time_show_ms_min;
exp_time_show_ms_min = exp_time_show_ls_min;
exp_time_show_ls_min = item.key;

end

else begin
exp_time_show_sec = exp_time_show_sec + 1'b1;
if(exp_time_show_ms_hr == 4'd2 && exp_time_show_ls_hr == 4'd3 && exp_time_show_ms_min == 4'd5 && exp_time_show_ls_min == 4'd9) begin
exp_time_show_ms_hr = '0;
exp_time_show_ls_hr = '0;
exp_time_show_ms_min = '0;
exp_time_show_ls_min = '0;
end
end

item.display("ITEM");

if(item.time_show_ms_hr[3:0] == exp_time_show_ms_hr && item.time_show_ls_hr[3:0] == exp_time_show_ls_hr && item.time_show_ms_min[3:0] == exp_time_show_ms_min && item.time_show_ls_min[3:0] == exp_time_show_ls_min) begin
$display("[SCOREBOARD SUCCESS] Time: %0d%0d:%0d%0d:%02d", item.time_show_ms_hr[3:0], item.time_show_ls_hr[3:0], item.time_show_ms_min[3:0], item.time_show_ls_min[3:0], item.time_show_sec);
pass_count++;
end
else begin
fail_count++;
$display("[SCOREBOARD ERROR] Expected Time: %0d%0d:%0d%0d:%02d | DUT Time: %0d%0d:%0d%0d:%02d", exp_time_show_ms_hr, exp_time_show_ls_hr, exp_time_show_ms_min, exp_time_show_ls_min, exp_time_show_sec, item.time_show_ms_hr[3:0], item.time_show_ls_hr[3:0], item.time_show_ms_min[3:0], item.time_show_ls_min[3:0], item.time_show_sec); end
end
endtask
endclass

`endif