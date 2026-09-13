`timescale 1ns/1ps

`ifndef CLOCK_PACKAGE_SV
`define CLOCK_PACKAGE_SV

package clock_pkg;

localparam int WIDTH = 4;

`include "clock_item.sv"
`include "clock_generator.sv"
`include "clock_driver.sv"
`include "clock_monitor.sv"
`include "clock_coverage.sv"
`include "clock_scoreboard.sv"
`include "clock_environment.sv"

endpackage : clock_pkg

`endif