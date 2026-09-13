`ifndef CLOCK_COVERAGE_SV
`define CLOCK_COVERAGE_SV

class coverage;

mailbox #(clock_item) mon2cov;

function new(mailbox #(clock_item) mon2cov);
this.mon2cov = mon2cov;
endfunction

int crst = 0;
int cfastwatch;
int ctimebutton = 0;
int calarmbutton = 0;
int ckey[WIDTH-1:0];
int csoundalarm = 0;

task run();
clock_item item;

for(int i=0;i<WIDTH;i++) begin calarmbutton[i] = '0; end

$display("[COVERAGE] Collecting coverage data...");

forever begin
mon2cov.get(item);

if(item.rst) crst = 1;
if(item.fast_watch) cfastwatch = 1;
if(item.time_button) ctimebutton = 1;
if(item.alarm_button) calarmbutton = 1;
++ckey[item.key];

end
endtask
endclass

`endif