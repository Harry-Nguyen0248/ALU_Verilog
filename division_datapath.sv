module division_datapath (
    input logic clk,
    input logic reset,
    input logic [3:0] divisor,    // 4-bit divisor input
    input logic [3:0] dividend,   // 4-bit dividend input
    input logic load,             // Load signal to start division process
    input logic shift,            // Control signal for shifting
    input logic sub,              // Control signal for subtraction
    output logic [3:0] quotient,  // 4-bit quotient output
    output logic [3:0] remainder, // 4-bit remainder output
    output logic result_valid     // Signal to indicate result is ready
);

    // Internal registers
    logic [3:0] A;               // Accumulator register
    logic [3:0] Q;               // Quotient register
    logic [3:0] M;               // Divisor register
    logic [3:0] R;               // Remainder register
    
    logic [3:0] sub_result;      // Result of the subtraction

    // Accumulator (A) Register: Stores the intermediate result or restores previous value
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 4'b0;
        end else if (load) begin
            A <= 4'b0;
        end else if (sub && A[3] == 1'b0) begin  // If result is positive
            A <= A - M;
        end else if (sub && A[3] == 1'b1) begin  // If result is negative (MSB of A is 1)
            A <= A + M;                         // Restore the value
        end
    end


    // Shift both Q (quotient) and A (accumulator) together
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 4'b0;
        end else if (load) begin
            Q <= dividend;
        end else if (shift) begin
            Q <= {Q[2:0], A[3]}; // Shift quotient and load the MSB of A into LSB of Q
        end
    end


    // Divisor (M) Register: Holds the divisor value
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            M <= 4'b0;           // Reset divisor to 0
        end else if (load) begin
            M <= divisor;        // Load divisor value into M
        end
    end

    // Remainder (R) Register: Stores the remainder
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            R <= 4'b0;           // Reset remainder to 0
        end else if (load) begin
            R <= A;              // Load A into remainder at the end
        end
    end

    // Result Valid Signal: Goes high when the result is ready
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            result_valid <= 1'b0; // Reset result valid signal
        end else if (!shift) begin
            result_valid <= 1'b1; // Set result valid when shifting is complete
        end
    end

    // Assign outputs
    assign quotient = Q;
    assign remainder = R;

endmodule


