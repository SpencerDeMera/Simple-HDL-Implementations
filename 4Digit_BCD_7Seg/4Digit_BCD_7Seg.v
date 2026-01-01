module FourDigit_BCD_7Seg #(
    parameter integer CLK_FREQ = 100_000_000 // 100 MHz for Nexys A7
)(
    input  wire clk,
    input  wire reset_n,
    output wire [6:0] seg,  // Segments a through g (Active Low)
    output wire [7:0] an    // 8 Anodes (Active Low)
);

    // --- 1. TIMING GENERATORS ---
    reg [26:0] count_1hz;   // Counter for 1 second
    reg [16:0] count_refresh; // Counter for ~1ms refresh (100kHz)
    wire en_1hz;
    wire en_refresh;

    always @(posedge clk) begin
        if (!reset_n) begin
            count_1hz <= 0;
            count_refresh <= 0;
        end else begin
            // 1Hz Enable for incrementing numbers
            if (count_1hz == CLK_FREQ - 1) count_1hz <= 0;
            else count_1hz <= count_1hz + 1;

            // ~1ms Enable for switching between digits
            if (count_refresh == (CLK_FREQ / 1000) - 1) count_refresh <= 0;
            else count_refresh <= count_refresh + 1;
        end
    end

    assign en_1hz = (count_1hz == CLK_FREQ - 1);
    assign en_refresh = (count_refresh == (CLK_FREQ / 1000) - 1);

    // --- 2. MULTI-DIGIT BCD COUNTER (0000 - 9999) ---
    reg [3:0] digit0, digit1, digit2, digit3;

    always @(posedge clk) begin
        if (!reset_n) begin
            {digit3, digit2, digit1, digit0} <= 16'h0000;
        end else if (en_1hz) begin
            if (digit0 < 9) digit0 <= digit0 + 1;
            else begin
                digit0 <= 0;
                if (digit1 < 9) digit1 <= digit1 + 1;
                else begin
                    digit1 <= 0;
                    if (digit2 < 9) digit2 <= digit2 + 1;
                    else begin
                        digit2 <= 0;
                        if (digit3 < 9) digit3 <= digit3 + 1;
                        else digit3 <= 0;
                    end
                end
            end
        end
    end

    // --- 3. DISPLAY STATE MACHINE (MULTIPLEXING) ---
    reg [1:0] display_state;
    reg [3:0] mux_digit;
    reg [7:0] anode_mask;

    always @(posedge clk) begin
        if (!reset_n) begin
            display_state <= 0;
        end else if (en_refresh) begin
            display_state <= display_state + 1;
        end
    end

    // Select which data and which anode to activate based on state
    always @(*) begin
        case (display_state)
            2'b00: begin mux_digit = digit0; anode_mask = 8'b11111110; end // Digit 0 ON
            2'b01: begin mux_digit = digit1; anode_mask = 8'b11111101; end // Digit 1 ON
            2'b10: begin mux_digit = digit2; anode_mask = 8'b11111011; end // Digit 2 ON
            2'b11: begin mux_digit = digit3; anode_mask = 8'b11110111; end // Digit 3 ON
            default: begin mux_digit = 4'h0; anode_mask = 8'b11111111; end
        endcase
    end

    assign an = anode_mask;

    // --- 4. 7-SEGMENT DECODER ---
    // Segments: {g, f, e, d, c, b, a}
    reg [6:0] seg_data;
    always @(*) begin
        case (mux_digit)
            4'd0: seg_data = 7'b1000000;
            4'd1: seg_data = 7'b1111001;
            4'd2: seg_data = 7'b0100100;
            4'd3: seg_data = 7'b0110000;
            4'd4: seg_data = 7'b0011001;
            4'd5: seg_data = 7'b0010010;
            4'd6: seg_data = 7'b0000010;
            4'd7: seg_data = 7'b1111000;
            4'd8: seg_data = 7'b0000000;
            4'd9: seg_data = 7'b0010000;
            default: seg_data = 7'b1111111;
        endcase
    end

    assign seg = seg_data;

endmodule