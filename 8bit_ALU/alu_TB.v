`timescale 1ns/1ps

module ALU_TB();
    // Inputs
    reg [7:0] A, B;
    reg [3:0] ALU_Sel;

    // Outputs
    wire [7:0] ALU_Out;
    wire CarryFlag, OverflowFlag, ZeroFlag, SignFlag;

    ALU uut(
        .A(A), 
        .B(B),
        .Sel(ALU_Sel),
        .S(ALU_Out),
        .Carry(CarryFlag),
        .Overflow(OverflowFlag),
        .Zero(ZeroFlag),
        .Sign(SignFlag)
    );

    reg [7:0] ref_Out;
    reg ref_Carry, ref_Overflow, ref_Zero, ref_Sign;
    integer i, errors;
    integer file_h; // File handle for the log file

    task ref_ALU;
        reg [8:0] sum;

        begin
            ref_Out = 8'd0;
            ref_Carry = 1'b0;
            ref_Overflow = 1'b0;
            ref_Zero = 1'b0;
            ref_Sign = 1'b0;
            ref_Carry = 1'b0;
            ref_Overflow = 1'b0;

            case (ALU_Sel)
                4'b000: begin
                    sum = A + B; // ADD to 9-bit temp result
                    ref_Out = sum[7:0]; // first 9 LSBs
                    ref_Carry = sum[8]; // MSB as ref_Carry value
                    // If A+ == B+ && result == -
                    // If A- == B- && result == +
                    ref_Overflow = (A[7] == B[7]) && (ref_Out[7] != A[7]);
                end
                4'b0001: begin
                    sum = A - B; // SUB to 9-bit temp result
                    ref_Out = sum[7:0]; // first 9 LSBs
                    ref_Carry = sum[8]; // MSB as ref_Carry value
                    // If A+ == B+ && result == -
                    // If A- == B- && result == +
                    ref_Overflow = (A[7] == B[7]) && (ref_Out[7] != A[7]);
                end
                4'b0010: begin
                    ref_Out = A & B; // Bitwise A AND B
                end
                4'b0011: begin
                    ref_Out = A | B; // Bitwise A OR B
                end
                4'b0100: begin
                    ref_Out = A ^ B; // Bitwise A XOR B
                end
                4'b0101: begin
                    ref_Out = ~A; // Bitwise INVERT A
                end
                4'b0110: begin
                    ref_Out = A << 1; // Logical Shift Left 1
                end
                4'b0111: begin
                    ref_Out = A >> 1; // Logical Shift Right 1
                end
                default: begin
                    ref_Out = 8'hxx;
                end
            endcase

            ref_Sign = ref_Out[7]; // Check LSB for sign bit
            ref_Zero = (ref_Out == 8'd0); // Check if all 8 bits are zero
        end
    endtask

    // --- Comparison Task ---
    task check_results;
        begin
            if ((ALU_Out !== ref_Out) || (CarryFlag !== ref_Carry) || (OverflowFlag !== ref_Overflow) || (ZeroFlag !== ref_Zero) || (SignFlag !== ref_Sign)) begin
                errors = errors + 1;
                
                // This line writes to your text file
                $fdisplay(file_h, "[MISMATCH] Time:%0t | Sel:%b | A:%h B:%h", $time, ALU_Sel, A, B);
                $fdisplay(file_h, "  DUT: S=%h C=%b V=%b Z=%b Sign=%b", ALU_Out, CarryFlag, OverflowFlag, ZeroFlag, SignFlag);
                $fdisplay(file_h, "  REF: S=%h C=%b V=%b Z=%b Sign=%b", ref_Out, ref_Carry, ref_Overflow, ref_Zero, ref_Sign);
                
                // Keep this to see a notification in the console
                $display("Mismatch found at %0t - logged to file.", $time);
            end
        end
    endtask

    initial begin
        file_h = $fopen("C:/Users/spenc/Documents/Vivado_Sim_Uutput/8bit_alu_test_log.txt", "w");
        
        if (file_h == 0) begin
            $display("ERROR: Could not open file. Check path permissions.");
            $finish;
        end

        errors = 0;
        $fdisplay(file_h, "--- Starting ALU Comprehensive Test ---");
        $fdisplay(file_h, "Time      | Oper | A  | B  | Result | Flags (C V Z S)");
        $fdisplay(file_h, "------------------------------------------------------");

        for (i = 0; i < 8; i = i + 1) begin
            ALU_Sel = i[3:0];
            repeat (10) begin
                A = $random;
                B = $random;
                ref_ALU(); // Calculate ref values at same time A/B change
                #5;        // Added semicolon
                check_results();
            end
        end

        // Write Final Report to File
        $fdisplay(file_h, "------------------------------------------------------");
        if (errors == 0)
            $fdisplay(file_h, "FINAL STATUS: PASS (0 Errors)");
        else
            $fdisplay(file_h, "FINAL STATUS: FAIL (%0d Errors Found)", errors);
            
        $fclose(file_h);
        $display("Testbench complete. Log saved to disk.");
        $finish;
    end
endmodule;