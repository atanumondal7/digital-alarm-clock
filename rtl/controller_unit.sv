module controller_unit #(parameter WIDTH = 4) (
input logic clk,
input logic rst,
input logic alarm_button,
input logic time_button,
input logic fast_watch,
input logic [WIDTH-1:0] key,
output logic [7:0] time_show_ms_hr,
output logic [7:0] time_show_ls_hr,
output logic [7:0] time_show_ms_min,
output logic [7:0] time_show_ls_min,
output logic [7:0] time_show_sec,
output logic sound_alarm
);

logic prev_time_button;
logic pulse_time_button;
logic prev_alarm_button;
logic pulse_alarm_button;
logic rst_count;
logic load_new_c;
logic show_new_time;
logic show_a;
logic load_new_a;
logic shift;

always_ff @(posedge clk) begin
if(rst) begin
prev_time_button <= 0; 
end
else begin
prev_time_button <= time_button;
end
end

always_ff @(posedge clk) begin
if(rst) begin
prev_alarm_button <= 0; 
end
else begin
prev_alarm_button <= alarm_button;
end
end

always_ff @(posedge clk) begin
if (rst)
rst_count <= 1'b0;
else
rst_count <= pulse_time_button;
end

assign pulse_time_button = !prev_time_button && time_button;
assign pulse_alarm_button = !prev_alarm_button && alarm_button;

logic [1:0] cycle;
logic [3:0] cyclex;
logic [3:0] cycley;

always_ff @(posedge clk) begin

if(rst) begin 
show_a <= 0;
show_new_time <= 0;
shift <= 0;
load_new_c <= 0; 
load_new_a <= 0;
cycle <= '0;
cyclex <= '0;
cycley <= '0;
end 

else if(pulse_time_button) begin cycle <= 2'b01; end
else if(pulse_alarm_button) begin cycle <= 2'b10; end

case (cycle)

2'b01: begin
if(cyclex < 4'd5) begin
load_new_c <= 1; 
show_new_time <= 1;
shift <= 1;
load_new_a <= 0;
show_a <= 0;
cyclex <= cyclex + 1'b1;
end

else begin
load_new_a <= 0;
show_a <= 0;
load_new_c <= 0; 
show_new_time <= 0;
shift <= 0;
cycle <= '0;
cyclex <= '0;
end

end

2'b10: begin
if(cycley < 4'd5) begin
load_new_c <= 0; 
show_new_time <= 0;
shift <= 1;
load_new_a <= 1;
show_a <= 1;
cycley <= cycley + 1'b1;
end

else begin
load_new_a <= 0;
show_a <= 0;
load_new_c <= 0; 
show_new_time <= 0;
shift <= 0;
cycle <= '0;
cycley <= '0;
end

end

default: cycle <= '0; 

endcase

end

logic [3:0] key_buffer_ms_hr;
logic [3:0] key_buffer_ls_hr;
logic [3:0] key_buffer_ms_min;
logic [3:0] key_buffer_ls_min;

logic [3:0] alarm_show_ms_hr;
logic [3:0] alarm_show_ls_hr;
logic [3:0] alarm_show_ms_min;
logic [3:0] alarm_show_ls_min;

logic [3:0] current_show_ms_hr;
logic [3:0] current_show_ls_hr;
logic [3:0] current_show_ms_min;
logic [3:0] current_show_ls_min;

logic one_minute;
logic one_second;

key_reg u_key_reg_0 (
.clk(clk),
.rst(rst),
.key(key),
.shift(shift),
.key_buffer_ls_hr(key_buffer_ls_hr),
.key_buffer_ls_min(key_buffer_ls_min),
.key_buffer_ms_hr(key_buffer_ms_hr),
.key_buffer_ms_min(key_buffer_ms_min)
);

alarm_register u_alarm_reg_0 (
.clk(clk),
.rst(rst),
.load_new_a(load_new_a),
.new_alarm_ms_hr(key_buffer_ms_hr),
.new_alarm_ls_hr(key_buffer_ls_hr),
.new_alarm_ms_min(key_buffer_ms_min),
.new_alarm_ls_min(key_buffer_ls_min),
.alarm_time_ms_hr(alarm_show_ms_hr),
.alarm_time_ls_hr(alarm_show_ls_hr),
.alarm_time_ms_min(alarm_show_ms_min),
.alarm_time_ls_min(alarm_show_ls_min)
);

counter u_counter_0 (
.clk(clk),
.rst(rst),
.one_minute(one_minute),
.load_new_c(load_new_c),
.new_current_time_ms_hr(key_buffer_ms_hr),
.new_current_time_ls_hr(key_buffer_ls_hr),
.new_current_time_ms_min(key_buffer_ms_min),
.new_current_time_ls_min(key_buffer_ls_min),
.current_time_ms_hr(current_show_ms_hr),
.current_time_ls_hr(current_show_ls_hr),
.current_time_ms_min(current_show_ms_min),
.current_time_ls_min(current_show_ls_min)
);

lcd_display_unit u_disp_unit_0 (
.current_time_ms_hr(current_show_ms_hr),
.current_time_ls_hr(current_show_ls_hr),
.current_time_ms_min(current_show_ms_min),
.current_time_ls_min(current_show_ls_min),
.alarm_time_ms_hr(alarm_show_ms_hr),
.alarm_time_ls_hr(alarm_show_ls_hr),
.alarm_time_ms_min(alarm_show_ms_min),
.alarm_time_ls_min(alarm_show_ls_min),
.key_time_ms_hr(key_buffer_ms_hr),
.key_time_ls_hr(key_buffer_ls_hr),
.key_time_ms_min(key_buffer_ms_min),
.key_time_ls_min(key_buffer_ls_min),
.show_new_time(show_new_time),
.show_a(show_a),
.sound_alarm(sound_alarm),
.display_time_ms_hr(time_show_ms_hr),
.display_time_ls_hr(time_show_ls_hr),
.display_time_ms_min(time_show_ms_min),
.display_time_ls_min(time_show_ls_min)
);

time_generator u_timegen_0 (
.clk(clk),
.rst(rst),
.rst_count(rst_count),
.fast_watch(fast_watch),
.one_minute(one_minute),
.one_second(one_second)
);

always_ff @(posedge clk) begin
if(rst) begin
time_show_sec <= '0;
end
else if(one_second) begin
if(time_show_sec == 6'd59) begin
time_show_sec <= '0;
end
else begin
time_show_sec <= time_show_sec + 1'b1;
end
end
end

endmodule