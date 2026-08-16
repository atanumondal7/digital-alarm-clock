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
logic sound_alarm;

$display("[SCOREBOARD] Calculating simulation results...");

forever begin
mon2scb.get(item);

if(item.rst) begin
exp_time_show_ms_hr = '0;
exp_time_show_ls_hr = '0;
exp_time_show_ms_min = '0;
exp_time_show_ls_min = '0;
sound_alarm = 0;
end

else begin

case (item.mode)

2'b00: exp_p_out = exp_p_out;
2'b01: exp_p_out = {item.s_in_l, exp_p_out[WIDTH-1:1]};
2'b10: exp_p_out = {exp_p_out[WIDTH-2:0], item.s_in_r};
2'b11: exp_p_out = item.p_in;

default: exp_p_out = exp_p_out;
endcase
end

item.display("ITEM");

if(exp_p_out === item.p_out) begin
$display("[SCOREBOARD MATCH] rst=%0b, mode=%b, s_in_l=%0b, s_in_r=%0b, p_in=%b -> p_out=%b", item.rst, item.mode, item.s_in_l, item.s_in_r, item.p_in, item.p_out);
pass_count++;
end
else begin
$display("[SCOREBOARD ERROR] rst=%0b, mode=%b, s_in_l=%0b, s_in_r=%0b, p_in=%b -> Exp: p_out=%b | Got: p_out=%b", item.rst, item.mode, item.s_in_l, item.s_in_r, item.p_in, exp_p_out, item.p_out);
fail_count++;
end
end
endtask
endclass

`endif