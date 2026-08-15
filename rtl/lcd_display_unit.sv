module lcd_display_unit (
input logic [3:0] current_time_ms_hr,
input logic [3:0] current_time_ls_hr,
input logic [3:0] current_time_ms_min,
input logic [3:0] current_time_ls_min,
input logic [3:0] alarm_time_ms_hr,
input logic [3:0] alarm_time_ls_hr,
input logic [3:0] alarm_time_ms_min,
input logic [3:0] alarm_time_ls_min,
input logic [3:0] key_time_ms_hr,
input logic [3:0] key_time_ls_hr,
input logic [3:0] key_time_ms_min,
input logic [3:0] key_time_ls_min,
input logic show_new_time,
input logic show_a,
output logic sound_alarm,
output logic [7:0] display_time_ms_hr,
output logic [7:0] display_time_ls_hr,
output logic [7:0] display_time_ms_min,
output logic [7:0] display_time_ls_min
);

logic sound_alarm1;
logic sound_alarm2;
logic sound_alarm3;
logic sound_alarm4;

lcd_display_driver sub1 (
.show_a(show_a),
.show_new_time(show_new_time),
.alarm_time(alarm_time_ls_hr),
.current_time(current_time_ls_hr),
.key_time(key_time_ls_hr),
.sound_alarm(sound_alarm1),
.display_time(display_time_ls_hr)
);

lcd_display_driver sub2 (
.show_a(show_a),
.show_new_time(show_new_time),
.alarm_time(alarm_time_ms_hr),
.current_time(current_time_ms_hr),
.key_time(key_time_ms_hr),
.sound_alarm(sound_alarm2),
.display_time(display_time_ms_hr)
);

lcd_display_driver sub3 (
.show_a(show_a),
.show_new_time(show_new_time),
.alarm_time(alarm_time_ls_min),
.current_time(current_time_ls_min),
.key_time(key_time_ls_min),
.sound_alarm(sound_alarm3),
.display_time(display_time_ls_min)
);

lcd_display_driver sub4 (
.show_a(show_a),
.show_new_time(show_new_time),
.alarm_time(alarm_time_ms_min),
.current_time(current_time_ms_min),
.key_time(key_time_ms_min),
.sound_alarm(sound_alarm4),
.display_time(display_time_ms_min)
);

assign sound_alarm = (sound_alarm1 && sound_alarm2 && sound_alarm3 && sound_alarm4);

endmodule