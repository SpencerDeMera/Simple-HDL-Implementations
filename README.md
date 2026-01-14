# Simple-Verilog-HDL-Implementations
A collection of hardware design projects for the **Digilent Nexys A7-100T FPGA**. These projects demonstrate fundamental FPGA concepts, focusing on synchronous design patterns and hardware interfacing.

## 🚀 Projects Included

### 1. Basic LED Blink (Toggle Pattern)
* **Description:** A simplified 1Hz LED blinker that uses a counter to directly toggle the output state.
* **Key Concept:**
   * **State Toggling:** Combines timing and output logic into a single block. 
   * **Standalone Design:** Specifically built for driving a single LED. Since the signal is high for 1 second, it is not reusable for driving other synchronous logic components.
* **Source:** `led_blink_1hz.v`

### 2. 1Hz LED Blink (Enable Generator Pattern)
* **Description:** A synchronous blinker that toggles an LED at 1Hz.
* **Key Concept:** Demonstrates the use of an **Enable Generator** rather than a clock divider. This ensures the entire design stays on the 100MHz global clock tree, preventing clock skew and timing violations common in "ripple clock" designs.
* **Source:** `led_blink_1hz_enGen.v`

### 3. Hexadecimal 7-Segment Decoder
* **Description:** A purely combinational decoder that displays 4-bit switch inputs as Hex values (0-F).
* **Key Concept:** Demonstrates switch interfacing, combinational `case` statements, and static anode management without a system clock.
* **Source:** `decoder.v`

### 4. BCD 7-Segment Counter
* **Description:** A decimal counter (0-9) that increments every second and displays the value on the seven-segment display.
* **Key Concept:**
   * **BCD Logic:** Uses a Binary Coded Decimal counter that resets at 9 rather than 15.
   * **Hardware Interfacing:** Features a combinational decoder to drive the active-low segments of the Nexys A7.
   * **Resource Management:** Drives the 8-digit anode bus to enable only the targeted display digit.
* **Source:** `BCD_7Seg.v`

### 5. Four-Digit BCD 7-Segment Counter (Multiplexed)
* **Description:** A four-digit decimal counter (0000–9999) that increments once per second and displays the value on a multiplexed seven-segment display.
* **Key Concept:**
  * **Enable-Based Timing:** Uses clock-enable pulses instead of divided clocks to generate a 1Hz count rate and a high-frequency display refresh.
  * **Display Multiplexing:** Cycles through multiple digits using a shared segment bus and active-low anode control to efficiently drive the display.
* **Source:** `FourDigit_BCD_7Seg.v`

### 6. 8-Bit Arithmetic Logic Unit (ALU)
* **Description:** A versatile 8-bit computational core that performs arithmetic, bitwise logic, and logical shift operations based on a 4-bit selection opcode.
* **Key Concept:**
   * **Status Flag Generation:** Features dedicated hardware logic to update Carry, Overflow, Sign, and Zero flags for every operation, providing the necessary feedback for conditional branching.
   * **Arithmetic Integrity:** Implements 2's complement addition and subtraction using a 9-bit temporary register to accurately capture carry-out and detect signed overflow.
   * **Automated Verification:** Utilizes a self-checking testbench with a golden reference model and File I/O system tasks (`$fopen`, `$fdisplay`) to log comprehensive simulation results to an external text file for hardware validation.
* **Source:** `ALU.v`

## 🛠️ Hardware Specifications
* **FPGA:** Nexys A7-100T (XC7A100T-1CSG324C)
* **Clock:** 100 MHz On-board Oscillator (Pin E3)
* **Reset:** CPU_RESET Pushbutton (Pin C12) — *Active-Low*
* **Display:** Common Anode Seven-Segment Display — *Active-Low Segments*

## 🧪 Simulation & Testbench
Each project includes a testbench designed for high-speed simulation. 

## 📂 Project Structure
* `.v`: Verilog source files (`.v`)
* `_TB.v`: Testbench files for simulation
* `.xdc`: Xilinx Design Constraints for the Nexys A7 (not all projects have this)

## 🔧 How to Build (If project is designed for physical implementation)
1. Create a new project in **Vivado**.
2. Add the source files from the `src` directory.
3. Add the `.xdc` file for pin mapping.
4. Run **Synthesis** and **Implementation**.
5. Generate **Bitstream** and program your Nexys A7 via the Hardware Manager.
