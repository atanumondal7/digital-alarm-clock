`ifndef CLOCK_ENVIRONMENT_SV
`define CLOCK_ENVIRONMENT_SV

class environment;

generator gen;
driver drv;
monitor mon;
scoreboard scb;
coverage cov;

mailbox #(clock_item) gen2drv;
mailbox #(clock_item) mon2scb;
mailbox #(clock_item) mon2cov;

virtual clock_if vif;

function new(virtual clock_if vif);
this.vif = vif;

gen2drv = new();
mon2scb = new();
mon2cov = new();

gen = new(gen2drv);
drv = new(vif, gen2drv);
mon = new(vif, mon2scb, mon2cov);
cov = new(mon2cov);
scb = new(mon2scb);
endfunction

task test();
int c1 = 0;
int tcov = 0;
int icov = 0;

$display("[ENVIRONMENT] Configuring environment variables...");

fork
drv.run();
mon.run();
cov.run();
scb.run();
join_none

gen.run();
wait(scb.pass_count + scb.fail_count == gen.loop_count);
#20;

for(int i=0;i<10;i++) begin
if(cov.ckey[i]) begin ++c1; end
end

icov = c1 + cov.ctimebutton + cov.calarmbutton + cov.cfastwatch;
tcov = c1 + 3;

$display("===================================================");
$display("               COVERAGE SUMMARY                    ");
$display("===================================================");
$display(" Reset Cover: %0s", (cov.crst)? "Covered" : "Not Covered");
$display(" fast Watch Cover: %0s", (cov.cfastwatch)? "Covered" : "Not Covered");
$display(" Time Button Cover: %0s", (cov.ctimebutton)? "Covered" : "Not Covered");
$display(" Alarm Button Cover: %0s", (cov.calarmbutton)? "Covered" : "Not Covered");
$display(" Key Cover: %0d/%0d, %0.2f%%", c1, 10, (real'(c1)*100)/10);
$display("===================================================");
$display(" Total Coverage: %0.2f%%", (real'(icov)*100)/tcov);
$display("===================================================");
$display("            FINAL VERIFICATION SUMMARY             ");
$display("===================================================");
$display(" Total Passed: %0d", scb.pass_count);
$display(" Total Failed: %0d", scb.fail_count);
$display("===================================================");

if(scb.fail_count==0) begin
$display(">>>> SIMULATION PASSED <<<<");
end 
else begin
$display(">>>> SIMULATION FAILED <<<<");
end

$finish;

endtask

endclass

`endif