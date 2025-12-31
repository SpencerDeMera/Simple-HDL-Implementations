// Enable Generated-based 1Hz LED Toggle
// Generates syncronous & reusable enable signal for 1Hz toggling 

module led_blink_1hz_enGen #(
    parameter integer CLK_FREQ = 100_000_000
)(
    input  wire clk,        // 100 MHz clock from Nexys A7 (E3)
    input  wire reset_n,    // ACTIVE-LOW reset (CPU RESET button)
    output reg  led         // connect to LED[0]
);

    reg [$clog2(CLK_FREQ)-1:0] count_reg;
    wire en_1hz;

    // 1. Enable Generator
    // Generates a pulse that is '1' for one cycle every 100 million cycles
    always @(posedge clk) begin
        if (!reset_n) 
            count_reg <= 0;
        else if (count_reg == CLK_FREQ - 1)
            count_reg <= 0;
        else
            count_reg <= count_reg + 1'b1;
    end

    assign en_1hz = (count_reg == CLK_FREQ - 1);

    // 2. LED Blink (Toggles only when en_1hz is high)
    always @(posedge clk) begin
        if (!reset_n)
            led <= 0;
        else if (en_1hz)
            led <= ~led;
    end

endmodule