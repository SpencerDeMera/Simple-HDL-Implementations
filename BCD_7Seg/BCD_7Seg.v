module BCD_7Seg #(
    parameter integer CLK_FREQ = 100_000_000
)(
    input  wire clk,
    input  wire reset_n,
    output wire [6:0] seg,  // Segments a through g
    output wire [7:0] an    // Anodes (selects which digit is on)
);

    // 1. Enable Generator (Your verified logic)
    reg [$clog2(CLK_FREQ)-1:0] count_reg;
    wire en_1hz;

    always @(posedge clk) begin
        if (!reset_n) 
            count_reg <= 0;
        else if (count_reg == CLK_FREQ - 1)
            count_reg <= 0;
        else
            count_reg <= count_reg + 1'b1;
    end

    assign en_1hz = (count_reg == CLK_FREQ - 1);

    // 2. BCD Counter (0-9)
    reg [3:0] bcd_digit;

    always @(posedge clk) begin
        if (!reset_n) begin
            bcd_digit <= 4'd0;
        end else if (en_1hz) begin
            if (bcd_digit == 4'd9)
                bcd_digit <= 4'd0;
            else
                bcd_digit <= bcd_digit + 1'b1;
        end
    end

    // 3. 7-Segment Decoder (Combinational)
    // Map: seg[0]=a, seg[1]=b, ..., seg[6]=g
    // Active Low: 0 = ON, 1 = OFF
    reg [6:0] seg_data;
    always @(*) begin
        case (bcd_digit)
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
            default: seg_data = 7'b1111111; // All segments off
        endcase
    end

    assign seg = seg_data;
    
    // 4. Anode Control
    // On the Nexys A7, AN pins are Active Low.
    // To turn on ONLY the right-most digit, set AN[0] to 0 and others to 1.
    assign an = 8'b11111110; 

endmodule