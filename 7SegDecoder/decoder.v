`timescale 1ns/1ps

module decoder (
    input  wire [3:0] bin,
    output reg  [7:0] seg,
    output wire [7:0] pnp
);
    // 7-segment decoder (active-low)
    always @(*) begin
        case (bin)
            4'h0: seg = ~8'h3F;
            4'h1: seg = ~8'h06;
            4'h2: seg = ~8'h5B;
            4'h3: seg = ~8'h4F;
            4'h4: seg = ~8'h66;
            4'h5: seg = ~8'h6D;
            4'h6: seg = ~8'h7D;
            4'h7: seg = ~8'h07;
            4'h8: seg = ~8'h7F;
            4'h9: seg = ~8'h6F;
            4'hA: seg = ~8'h77;
            4'hB: seg = ~8'h7C;
            4'hC: seg = ~8'h39;
            4'hD: seg = ~8'h5E;
            4'hE: seg = ~8'h79;
            default: seg = ~8'h71; // F / others
        endcase
    end

    // Enable only digit 0 (active-low)
    assign pnp = 8'hFE;

endmodule
