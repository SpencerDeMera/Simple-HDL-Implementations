`timescale 1ns/1ps

module decoder_tb;
    reg  [3:0] sw_TB;
    wire [7:0] seg_TB;
    wire [7:0] pnp_TB;

    // DUT
    decoder uut (
        .bin(sw_TB),
        .seg(seg_TB),
        .pnp(pnp_TB)
    );

    initial begin
        sw_TB = 4'h0; #10;
        sw_TB = 4'h1; #10;
        sw_TB = 4'h2; #10;
        sw_TB = 4'h3; #10;
        sw_TB = 4'h4; #10;
        sw_TB = 4'h5; #10;
        sw_TB = 4'h6; #10;
        sw_TB = 4'h7; #10;
        sw_TB = 4'h8; #10;
        sw_TB = 4'h9; #10;
        sw_TB = 4'hA; #10;
        sw_TB = 4'hB; #10;
        sw_TB = 4'hC; #10;
        sw_TB = 4'hD; #10;
        sw_TB = 4'hE; #10;
        sw_TB = 4'hF; #10;

        $display("Simulation Completed");
        $finish;
    end

endmodule
