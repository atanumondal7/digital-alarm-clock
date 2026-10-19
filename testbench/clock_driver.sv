`ifndef CLOCK_DRIVER_SV
`define CLOCK_DRIVER_SV

class driver;

virtual clock_if vif;
mailbox #(clock_item) gen2drv;

function new(virtual clock_if vif, mailbox #(clock_item) gen2drv);
this.vif = vif;
this.gen2drv = gen2drv;
endfunction

int check = 0;
int c1 = 0;

task run();
clock_item item;

$display("[DRIVER] Driving stimuli to DUT...");

forever begin

gen2drv.get(item);

vif.cb.rst <= item.rst;
vif.cb.alarm_button <= item.alarm_button;
vif.cb.time_button <= item.time_button;
vif.cb.fast_watch <= item.fast_watch;
vif.cb.key <= item.key;

if(item.time_button || (c1 <= 5 && c1 != 0)) begin
@(vif.cb);
++c1;
end
else begin
c1=0;
repeat(260) begin
@(vif.cb);
end
end


end
endtask
endclass

`endif