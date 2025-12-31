`timescale 1ns/1ps

module BCD_7Seg_TB;
    // --------------------------------------------------
    // Parameters (FAST SIMULATION)
    // --------------------------------------------------
    localparam integer TB_CLK_FREQ = 10;   // 10 cycles per BCD increment

    // --------------------------------------------------
    // Signals
    // --------------------------------------------------
    reg        clk;
    reg        reset_n;
    wire [6:0] seg;
    wire [7:0] an;

    // --------------------------------------------------
    // DUT (override parameter)
    // --------------------------------------------------
    BCD_7Seg #(
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
        #20;                // Hold reset for 2 cycles
        reset_n = 1'b1;
    end

    // --------------------------------------------------
    // BCD Measurement and Monitoring
    // --------------------------------------------------
    integer count_val;
    time last_increment;

    initial begin
        count_val = 0;
        last_increment = 0;
    end

    // Monitor the 'seg' bus to detect when the number changes
    always @(seg) begin
        // Skip monitoring during reset
        if (reset_n) begin
            $display("Segment Display Changed to: %b at %0t ns", seg, $time);
            
            // Logic to check if the time between changes matches TB_CLK_FREQ
            if (last_increment != 0) begin
                if ($time - last_increment != TB_CLK_FREQ * 10) begin
                    $error("Timing Error: BCD did not increment at the correct 1Hz (scaled) interval!");
                end
            end
            last_increment = $time;
            count_val = count_val + 1;
        end
    end

    // --------------------------------------------------
    // End simulation after a full 0-9 cycle
    // --------------------------------------------------
    initial begin
        // Wait for reset to finish + 11 increments (to see it roll over from 9 to 0)
        # (20 + (TB_CLK_FREQ * 10 * 11));
        
        $display("Simulation finished. Check waveforms to verify segment patterns.");
        $finish;
    end

endmodule