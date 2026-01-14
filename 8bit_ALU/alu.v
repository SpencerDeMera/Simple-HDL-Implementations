`timescale 1ns / 1ps

module ALU(
    input [7:0] A, B,
    input [3:0] Sel,
    output [7:0] S,
    output reg Carry, Overflow, Sign, Zero
);

    reg [8:0] temp; // temp register to hold 9-bit rersults of Add & SUB
    reg [7:0] result;

    always @(*) begin
        case (Sel)
            4'b000: begin
                temp = A + B; // ADD to 9-bit temp result
                result = temp[7:0]; // first 9 LSBs
                Carry = temp[8]; // MSB as carry value
                // If A+ == B+ && result == -
                // If A- == B- && result == +
                Overflow = (A[7] == B[7]) && (result[7] != A[7]);
            end
            4'b0001: begin
                temp = A - B; // SUB to 9-bit temp result
                result = temp[7:0]; // first 9 LSBs
                Carry = temp[8]; // MSB as carry value
                // If A+ == B+ && result == -
                // If A- == B- && result == +
                Overflow = (A[7] == B[7]) && (result[7] != A[7]);
            end
            4'b0010: begin
                result = A & B; // Bitwise A AND B
                Carry = 1'b0;
                Overflow = 1'b0;
            end
            4'b0011: begin
                result = A | B; // Bitwise A OR B
                Carry = 1'b0;
                Overflow = 1'b0;
            end
            4'b0100: begin
                result = A ^ B; // Bitwise A XOR B
                Carry = 1'b0;
                Overflow = 1'b0;
            end
            4'b0101: begin
                result = ~A; // Bitwise INVERT A
                Carry = 1'b0;
                Overflow = 1'b0;
            end
            4'b0110: begin
                result = A << 1; // Logical Shift Left 1
                Carry = 1'b0;
                Overflow = 1'b0;
            end
            4'b0111: begin
                result = A >> 1; // Logical Shift Right 1
                Carry = 1'b0;
                Overflow = 1'b0;
            end
            default: $display("error: invalid opcode %b", Sel);
        endcase

        Sign = result[7]; // Check LSB for sign bit
        Zero = (result == 8'd0); // Check if all 8 bits are zero
    end

    assign S = result; // assign temp result value to S

endmodule