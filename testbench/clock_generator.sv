`ifndef CLOCK_GENERATOR_SV
`define CLOCK_GENERATOR_SV

class generator;

mailbox #(clock_item) gen2drv;
int loop_count = 10;
int loop = 0;

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

repeat(loop_count-1) begin
if(loop == 4) begin
item = new();
item.rst = 0;
item.time_button = 1;
item.alarm_button = 0;
item.fast_watch = 0;
item.key = 4'd1;
gen2drv.put(item);
end
else if(loop == 5) begin
item.key = 4'd3;
gen2drv.put(item);
end

else begin 
item = new();
item.rst = 0;
item.time_button = 0;
item.alarm_button = 0;
item.fast_watch = 0;
item.key = '0;
gen2drv.put(item);
end
loop = loop + 1;
end

endtask
endclass

`endif