`timescale 1ns/1ps

module led_blink_1hz_enGen_TB;
    // --------------------------------------------------
    // Parameters (FAST SIMULATION)
    // --------------------------------------------------
    localparam integer TB_CLK_FREQ = 10;   // 10 cycles per toggle

    // --------------------------------------------------
    // Signals
    // --------------------------------------------------
    reg  clk;
    reg  reset_n;     // ACTIVE-LOW reset (matches Nexys A7)
    wire led;

    // --------------------------------------------------
    // DUT (override parameter)
    // --------------------------------------------------
    led_blink_1hz_enGen #(
        .CLK_FREQ(TB_CLK_FREQ)
    ) dut (
        .clk     (clk),
        .reset_n (reset_n),
        .led     (led)
    );

    // --------------------------------------------------
    // Clock generation
    // --------------------------------------------------
    initial clk = 1'b0;
    always #5 clk = ~clk;   // 10 ns period (arbitrary for sim)

    // --------------------------------------------------
    // Reset behavior (Nexys A7–accurate)
    // --------------------------------------------------
    initial begin
        reset_n = 1'b0;     // button pressed at power-up
        #20;                // hold reset for 2 clock cycles
        reset_n = 1'b1;     // button released
    end

    // --------------------------------------------------
    // LED toggle measurement
    // --------------------------------------------------
    integer toggle_count;
    time last_toggle;

    initial begin
        toggle_count = 0;
        last_toggle  = 0;
    end

    always @(posedge led or negedge led) begin
        toggle_count = toggle_count + 1;
        $display("Toggle %0d at %0t ns", toggle_count, $time);

        // Skip first toggle; need two edges to measure period
        if (last_toggle != 0) begin
            if ($time - last_toggle != TB_CLK_FREQ * 10) begin
                $error("Wrong toggle period!");
            end
        end

        last_toggle = $time;
    end

    // --------------------------------------------------
    // End simulation
    // --------------------------------------------------
    initial begin
        #500;
        $display("Simulation finished OK");
        $finish;
    end

endmodule
