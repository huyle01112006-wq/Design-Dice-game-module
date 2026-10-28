# FPGA Digital Dice Game (Verilog HDL)
A hardware implementation of a *Digital Dice Game* using Verilog HDL and Finite State Machine (FSM) architecture. The project simulates a standard two-dice rolling game using high-frequency counters latched on a physical button release (`RTN`), with game state outcomes rendered on dynamic outputs.
This project aim to practice the flowthinking about finite state machine in applicating in real products.
# Game Rules & Logic
1. *Initialization (`RESET`)*: Pressing the `RESET` button clears all registers, resets the saved “POINT”, and returns the game state to “S_IDLE”.
2. **First Roll (`S_FIRST`)**:
   - The user presses and holds the *Roll Button (`RTN`)*.
   - Upon releasing `RTN` (falling edge detection), the sum of the two dice (Sum_0 = Dice_1 + Dice_2) is evaluated:
     - *WIN*: If  Sum_0 in {6, 8}, the game transitions to `S_WIN` immediately before fiishing program.
     - *LOSe*: If Sum_0 in {4, 7, 15}, the game transitions to `S_LOSE` following this state from Win state above.
     - *SAVE POINT*: If Sum_0 can not meet {4, 6, 7, 8, 15} values, Sum_0 is saved into the `POINT` register and displayed into Log in Vivado simulation tools. The game proceeds to `S_NEXT_ROLL`.
3. *Subsequent Rolls (`S_NEXT_ROLL`)*:
   - The user continues pressing `RTN` to roll again:
     - *WIN*: If current Sum == POINT, the player wins (`S_WIN`).
     - *LOSE*: If current Sum == 9, the player loses (`S_LOSE`).
     - *CONTINUE*: Any other sum requires another roll.
# Architecture & Key Features
- *Pseudo-Randomization via Human Timing*: Two modulo-6 counters run continuously at high clock frequencies (100 MHz). The exact millisecond the user releases the `RTN` button latches unpredictable dice values.
- *Asynchronous Button Edge Detection*: Uses a two-stage synchronizer (`rtn1`, `rtn2`) to detect clean falling edges (`rtn_fall_edge`) and prevent metastability issues on FPGA hardware.
- *3-Block FSM Architecture*: Separates **State Registering* (sequential),*Next-State Logic* (combinational), and *Output Logic* to eliminate race conditions and avoid inferred latches during synthesis.
-file dice_game.v source newly replace blocking assign in SUM_0 bu utilizing wire sum_i (sum_imediate) to improve accuracy and latency.
