`ifndef CLOCK_DRIVER_SV
`define CLOCK_DRIVER_SV

class driver;

virtual clock_if vif;
mailbox #(clock_item) gen2drv;

function new(virtual clock_if vif, mailbox #(clock_item) gen2drv);
this.vif = vif;
this.gen2drv = gen2drv;
endfunction

task run();
clock_item item;

$display("[DRIVER] Driving stimuli to DUT...");

forever begin
int k = 0;
gen2drv.get(item);

vif.cb.rst <= item.rst;
vif.cb.alarm_button <= item.alarm_button;
vif.cb.time_button <= item.time_button;
vif.cb.fast_watch <= item.fast_watch;
vif.cb.key <= item.key;

if(item.time_button || item.alarm_button) begin
k = 4;
@(vif.cb);
end
else if(k <= 4 && k > 0) begin
k = k-1;
@(vif.cb);
end
else begin
repeat(256) begin
@(vif.cb);
end
end

end
endtask
endclass

`endif