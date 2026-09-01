// =============================================================
// Testbench   : home_alarm_tb
// Description : Exhaustively tests all 16 input combinations
//               of the home_alarm module and checks the output
//               against the expected combinational logic.
// =============================================================

`timescale 1ns / 1ps

module home_alarm_tb;

    // Testbench signals
    reg  armed, door_sensor, window_sensor, motion_sensor;
    wire alarm;

    integer i;
    reg     expected;
    integer errors = 0;

    // Instantiate the Device Under Test (DUT)
    home_alarm uut (
        .armed         (armed),
        .door_sensor   (door_sensor),
        .window_sensor (window_sensor),
        .motion_sensor (motion_sensor),
        .alarm         (alarm)
    );

    // Waveform dump for Synopsys DVE (VCS)
    initial begin
        $vcdplusfile("home_alarm.vpd");
        $vcdpluson(0, home_alarm_tb);
    end

    initial begin
        $display("=========================================================");
        $display(" armed door window motion | alarm (actual) expected  pass?");
        $display("=========================================================");

        // Sweep through every combination of the 4 inputs (2^4 = 16)
        for (i = 0; i < 16; i = i + 1) begin
            {armed, door_sensor, window_sensor, motion_sensor} = i[3:0];
            #10; // allow combinational logic to settle

            expected = armed & (door_sensor | window_sensor | motion_sensor);

            $display("   %b     %b     %b      %b   |    %b           %b        %s",
                      armed, door_sensor, window_sensor, motion_sensor,
                      alarm, expected,
                      (alarm === expected) ? "PASS" : "FAIL");

            if (alarm !== expected) begin
                errors = errors + 1;
            end
        end

        $display("=========================================================");
        if (errors == 0)
            $display(" RESULT: ALL 16 TEST CASES PASSED.");
        else
            $display(" RESULT: %0d TEST CASE(S) FAILED.", errors);
        $display("=========================================================");

        $finish;
    end

endmodule
