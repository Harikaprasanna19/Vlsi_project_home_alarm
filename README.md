# Home Alarm System — Verilog (Combinational Logic)

A simple digital home security alarm system implemented in Verilog HDL using
**pure combinational logic** — no clock, no state, just a Boolean equation
driven by three sensors and an arm/disarm switch.

## Logic Description

The alarm siren turns **ON** only when the system is **armed**(switch ON) *and* at least
one of the three sensors (door, window, or motion) is triggered.

```
alarm = armed AND (door_sensor OR window_sensor OR motion_sensor)
```

## Truth Table

| armed | door | window | motion | alarm |
|:-----:|:----:|:------:|:------:|:-----:|
| 0 | X | X | X | 0 |
| 1 | 0 | 0 | 0 | 0 |
| 1 | 1 | 0 | 0 | 1 |
| 1 | 0 | 1 | 0 | 1 |
| 1 | 0 | 0 | 1 | 1 |
| 1 | 1 | 1 | 1 | 1 |

(`X` = don't care — if the system isn't armed, no sensor can trigger the alarm.)

## Project Structure

```
home_alarm_verilog/
├── rtl/
│   └── home_alarm.v        # RTL design (combinational logic module)
├── tb/
│   └── home_alarm_tb.v     # Testbench — exhaustively tests all 16 input cases
└── README.md
```

## Module I/O

**`home_alarm`**

| Signal          | Direction | Width | Description |
|-----------------|-----------|-------|--------------------------------|
| `armed`         | input     | 1 bit | 1 = system armed, 0 = disarmed |
| `door_sensor`   | input     | 1 bit | 1 = door triggered             |         
| `window_sensor` | input     | 1 bit | 1 = window triggered           |
| `motion_sensor` | input     | 1 bit | 1 = motion detected            |
| `alarm`         | output    | 1 bit | 1 = siren ON                   |

## How to Simulate (Synopsys VCS + DVE)

This project is set up for the **Synopsys VCS** simulator with waveform
viewing in **DVE**.

**1. Compile the design + testbench**

```bash
vcs -full64 -debug_access+all -f filelist.f  
```

This produces a `simv` executable in the current directory. 
filelist.f include
home_alarm.v
tb_home_alarm.v

**2. Run the simulation**

```bash
./simv
```

**Expected output:** all 16 test cases print `PASS`, and the summary line reads
`RESULT: ALL 16 TEST CASES PASSED.` A `home_alarm.vpd` waveform file is also
generated in this step.

**3. View waveforms in DVE**

```bash
dve -vpd home_alarm.vpd &
```

### Alternative: Icarus Verilog (free/open-source)

If you don't have VCS available, the same files also run on
[Icarus Verilog](http://iverilog.icarus.com/):

```bash
iverilog -o sim_out rtl/home_alarm.v tb/home_alarm_tb.v
vvp sim_out
```

(Note: Icarus does not support `$vcdplusfile`/`$vcdpluson` — swap those two
lines in the testbench for `$dumpfile("home_alarm.vcd"); $dumpvars(0, home_alarm_tb);`
and view the result in GTKWave instead of DVE.)

## Circuit Diagram

![Home alarm gate-level circuit diagram](docs/home_alarm_circuit_diagram.png)

`door_sensor`, `window_sensor`, and `motion_sensor` feed a 3-input **OR** gate
producing `w1`. `w1` and `armed` feed a 2-input **AND** gate producing
`alarm` — matching the `home_alarm.v` RTL and the signal names seen in the
waveform and console output above.

**Gate count:** 1 OR gate (3-input) + 1 AND gate (2-input) = 2 gates total.
**Flip-flops / registers: 0.** This is purely combinational logic — every
`assign` statement resolves immediately (subject only to gate propagation
delay), with no clock and no stored state.

## Simulation Waveform

![Home alarm waveform](docs/home_alarm_waveform.png)

Captured in Synopsys DVE after running the exhaustive testbench (`i = 0..15`
driving `{armed, door_sensor, window_sensor, motion_sensor}`). The `errors`
signal stays at `0` across the full run, confirming the RTL matches the
expected logic for all 16 input combinations.

**Note on the trace timing:** `alarm` (the DUT's actual output) and
`expected` (the testbench's reference value) appear to step at slightly
different points within each 10ns window — `alarm` updates as soon as the
inputs change, while `expected` is computed just before the comparison, at
the end of the window. This is a testbench sequencing detail, not a logic
error: both signals are compared only after `expected` is computed, by which
point `alarm` has already settled, so the comparison is always valid (hence
zero errors).

## Design Notes

- This is intentionally kept as **combinational logic** (a single `assign`
  statement) — there's no clock or memory element, so the output responds
  immediately to any input change.
- A natural next step/extension would be to add a **sequential** version with
  a clocked entry-delay timer and a latched alarm state (using flip-flops) —
  useful if you want to later demonstrate FSM design on top of this.

## License

HP License — free to use, modify, and share.
