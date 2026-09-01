// =============================================================
// Module      : home_alarm
// Description : Simple combinational home security alarm.
//               The alarm triggers whenever the system is
//               armed AND at least one sensor (door, window,
//               or motion) detects an intrusion.
//
// Logic       : alarm = armed & (door | window | motion)
//
// Type        : Pure combinational logic (no clock, no state)
// =============================================================

module home_alarm (
    input  wire armed,          // 1 = system is armed, 0 = disarmed
    input  wire door_sensor,    // 1 = door open/triggered
    input  wire window_sensor,  // 1 = window open/triggered
    input  wire motion_sensor,  // 1 = motion detected
    output wire alarm           // 1 = alarm siren ON
);

    // Alarm fires only if the system is armed AND
    // any one of the three sensors is triggered.
    assign alarm = armed & (door_sensor | window_sensor | motion_sensor);

endmodule
