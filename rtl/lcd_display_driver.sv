module lcd_display_driver (
input logic show_a, 
input logic show_new_time,
input logic [3:0] alarm_time, 
input logic [3:0] current_time,
input logic [3:0] key_time,
output logic sound_alarm,
output logic [7:0] display_time
);

logic [3:0] sel_time;

always_comb begin

if(show_a && !show_new_time) begin 
sel_time = alarm_time;
end

else if(!show_a && !show_new_time) begin 
sel_time = current_time;
end

else if(!show_a && show_new_time) begin 
sel_time = key_time;
end

else begin
sel_time = 4'b0000;
end

end

assign display_time = {4'b0011, sel_time};
assign sound_alarm = (alarm_time == current_time);

endmodule