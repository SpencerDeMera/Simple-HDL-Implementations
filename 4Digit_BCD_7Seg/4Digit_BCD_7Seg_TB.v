`timescale 1ns/1ps

module FourDigit_BCD_7Seg_TB;
    // --------------------------------------------------
    // Parameters (FAST SIMULATION)
    // --------------------------------------------------
    // In real hardware, this is 100,000,000. 
    // Setting it to 100 makes the "1Hz" pulse happen every 100 clock cycles.
    localparam integer TB_CLK_FREQ = 10;  

    // --------------------------------------------------
    // Signals
    // --------------------------------------------------
    reg        clk;
    reg        reset_n;
    wire [6:0] seg;
    wire [7:0] an;

    // --------------------------------------------------
    // DUT (Device Under Test)
    // --------------------------------------------------
    FourDigit_BCD_7Seg #(
        .CLK_FREQ(TB_CLK_FREQ)
    ) dut (
        .clk     (clk),
        .reset_n (reset_n),
        .seg     (seg),
        .an      (an)
    );

    // --------------------------------------------------
    // Clock generation (100MHz = 10ns period)
    // --------------------------------------------------
    initial clk = 1'b0;
    always #5 clk = ~clk; 

    // --------------------------------------------------
    // Reset behavior
    // --------------------------------------------------
    initial begin
        reset_n = 1'b0;
        #22;                // Hold reset for ~2 cycles
        reset_n = 1'b1;
    end

    // --------------------------------------------------
    // Monitoring Multiplexing and Counting
    // --------------------------------------------------
    
    // Task to decode the segment bits back to integers for easy console reading
    function [3:0] decode_seg(input [6:0] s);
        case (s)
            7'b1000000: decode_seg = 4'd0;
            7'b1111001: decode_seg = 4'd1;
            7'b0100100: decode_seg = 4'd2;
            7'b0110000: decode_seg = 4'd3;
            7'b0011001: decode_seg = 4'd4;
            7'b0010010: decode_seg = 4'd5;
            7'b0000010: decode_seg = 4'd6;
            7'b1111000: decode_seg = 4'd7;
            7'b0000000: decode_seg = 4'd8;
            7'b0010000: decode_seg = 4'd9;
            default:    decode_seg = 4'hF; // Error
        endcase
    endfunction

    // Monitor Anode switching (Multiplexing)
    always @(an) begin
        if (reset_n) begin
            $display("[Time %0t] Anode Active: %b | Digit Value: %0d", $time, an, decode_seg(seg));
        end
    end

    // Monitor Roll-over (Checking if digit 0 triggers digit 1)
    always @(dut.digit1) begin
        if (reset_n && dut.digit1 > 0) begin
            $display(">>> Success: Tens digit incremented to %0d at %0t ns", dut.digit1, $time);
        end
    end

    // --------------------------------------------------
    // End Simulation
    // --------------------------------------------------
    initial begin
        // We need enough time to see:
        // 1. Multiple multiplexing cycles (switching between digits)
        // 2. Enough 1Hz pulses to see Digit0 roll over to Digit1
        
        // Wait for 15 "seconds" (scaled) to see 0015 on the display
        # (TB_CLK_FREQ * 10 * 15);
        
        $display("--------------------------------------------------");
        $display("Simulation Complete.");
        $display("Verify that 'an' cycled through 11111110, 11111101, etc.");
        $display("Verify that 'seg' changed values according to the active anode.");
        $display("--------------------------------------------------");
        $finish;
    end

endmodule