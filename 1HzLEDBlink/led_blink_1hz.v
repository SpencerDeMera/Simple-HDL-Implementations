// Toggles the single LED on 1 second intervals
// Only "good" for JUST toggling an LED at 1Hz
// (not reusable for other purposes)

module led_blink_1hz #(
    parameter integer CLK_FREQ = 100_000_000
)(
    input  wire clk,        // 100 MHz clock from Nexys A7 (E3)
    input  wire reset_n,    // ACTIVE-LOW reset (CPU RESET button)
    output reg  led         // connect to LED[0]
);

    localparam integer COUNT_MAX = CLK_FREQ - 1;
    reg [$clog2(CLK_FREQ)-1:0] counter;

    always @(posedge clk) begin
        if (!reset_n) begin
            counter <= 0;
            led     <= 1'b0;
        end
        else if (counter == COUNT_MAX) begin
            counter <= 0;
            led     <= ~led;     // toggle every 1 second
        end
        else begin
            counter <= counter + 1'b1;
        end
    end

endmodule
