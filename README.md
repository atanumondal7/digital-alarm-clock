# Digital Alarm Clock [WORK IN PROGRESS]

I built a fully automated digital alarm clock in SystemVerilog and verified it using a UVM-Style transaction oriented, mailbox connected testbench. As of now it has supports quite few features.

## Features

• Time Button - Allows you to modify the current time
• Alarm Button -  Allows you to set the alarm time
• Fast Watch - Allows you to speed up the watch by ticking the minutes counter every second

## Left to do

1. Configure the time flip over of the testbench properly.
2. Add alarm button functionality to testbench.
3. Make the time button 4-key cycle longer to give enough time to the driver to input the randomized keys.
4. Configure the coverage collector to check for all the edge cases