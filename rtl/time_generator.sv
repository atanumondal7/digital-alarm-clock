module time_generator #(
localparam CLK_FREQ = 256
) (
input logic clk,
input logic rst,
input logic rst_count,
input logic fast_watch,
output logic one_minute,
output logic one_second
);

logic [7:0] c_cycle;
logic [5:0] sec_counter;
logic sec_pulse_reg;

always_ff @(posedge clk) begin

if(rst || rst_count) begin
c_cycle <= '0;
sec_pulse_reg <= 0;
end
else begin
if(c_cycle == (CLK_FREQ-1)) begin
c_cycle <= '0;
sec_pulse_reg <= 1'b1;
end
else begin
c_cycle <= c_cycle + 1'b1;
sec_pulse_reg <= 0;
end
end
end

assign one_second = sec_pulse_reg;

always_ff @(posedge clk) begin
if(rst || rst_count) begin
sec_counter <= '0;
one_minute <= 0;
end 
else begin
if(fast_watch) begin
one_minute <= sec_pulse_reg;
sec_counter <= '0;
end
else begin
if(sec_pulse_reg) begin
if(sec_counter == 6'd59) begin
one_minute <= 1'b1;
sec_counter <= '0;
end
else begin
sec_counter <= sec_counter + 1'b1;
one_minute <= 1'b0;
end
end
else begin
one_minute <= 1'b0;
end
end
end
end

endmodule