`ifndef CLOCK_MONITOR_SV
`define CLOCK_MONITOR_SV

class monitor;

virtual clock_if vif;
mailbox #(clock_item) mon2scb;
mailbox #(clock_item) mon2cov;

function new(virtual clock_if vif, mailbox #(clock_item) mon2scb, mailbox #(clock_item) mon2cov);
this.vif = vif;
this.mon2scb = mon2scb;
this.mon2cov = mon2cov;
endfunction

task run();
clock_item item;
logic prev_rst;
logic prev_alarm_button;
logic prev_time_button;
logic prev_fast_watch;
logic [WIDTH-1:0] prev_key;

$display("[MONITOR] Monitoring DUT signals...");

@(vif.cb);
@(vif.cb);
prev_rst = vif.rst;
prev_alarm_button = vif.alarm_button;
prev_time_button = vif.time_button;
prev_fast_watch = vif.fast_watch;
prev_key = vif.key;

forever begin
@(vif.cb);

item = new();
item.rst = prev_rst;
item.alarm_button = prev_alarm_button;
item.time_button = prev_time_button;
item.fast_watch = prev_fast_watch;
item.key = prev_key;
item.time_show_ms_hr = vif.cb.time_show_ms_hr;
item.time_show_ls_hr = vif.cb.time_show_ls_hr;
item.time_show_ms_min = vif.cb.time_show_ms_min;
item.time_show_ls_min = vif.cb.time_show_ls_min;
item.sound_alarm = vif.cb.sound_alarm;

mon2scb.put(item.copy());
mon2cov.put(item.copy());

prev_rst = vif.rst;
prev_alarm_button = vif.alarm_button;
prev_time_button = vif.time_button;
prev_fast_watch = vif.fast_watch;
prev_key = vif.key;

end
endtask
endclass

`endif