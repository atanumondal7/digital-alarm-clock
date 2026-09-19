`ifndef CLOCK_GENERATOR_SV
`define CLOCK_GENERATOR_SV

class generator;

mailbox #(clock_item) gen2drv;
int loop_count = 1500;

function new(mailbox #(clock_item) gen2drv);
this.gen2drv = gen2drv;
endfunction

task run();
clock_item item;

$display("[GENERATOR] Generating stimulus for DUT...");

item = new();
item.rst = 1;
item.time_button = 0;
item.alarm_button = 0;
item.fast_watch = 0;
item.key = '0;
gen2drv.put(item);

repeat(loop_count-500) begin
item = new();
item.rst = 0;
item.time_button = 0;
item.alarm_button = 0;
item.fast_watch = 0;
item.key = '0;
gen2drv.put(item);
end

repeat(500) begin
item = new();
item.rst = 0;
item.time_button = 0;
item.alarm_button = 0;
item.fast_watch = 1;
item.key = '0;
gen2drv.put(item);
end

endtask
endclass

`endif