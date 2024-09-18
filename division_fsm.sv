module division_fsm (
    input logic clk,
    input logic reset,
    input logic go,                 // Start signal
    input logic [3:0] dividend,     // 4-bit dividend
    input logic [3:0] divisor,      // 4-bit divisor
    output logic load,              // Control signal for loading values
    output logic shift,             // Control signal for shifting
    output logic sub,               // Control signal for subtraction
    output logic done,              // Signal when division is complete
    output logic [3:0] quotient,    // 4-bit quotient output
    output logic [3:0] remainder    // 4-bit remainder output
);

    // FSM States
    typedef enum logic [2:0] {
        S_INIT,               // Initialization
        S_SHIFT_DIVIDEND,      // Shift the next bit of the dividend
        S_SUBTRACT,            // Subtract the divisor from the accumulator
        S_CHECK,               // Check if subtraction result is negative
        S_SHIFT_QUOTIENT,      // Shift quotient and prepare for next bit
        S_DONE                 // Division is complete
    } state_t;
    
    state_t current_state, next_state;
    logic [2:0] bit_counter;    // Keeps track of which bit we're processing

    // FSM: Current state logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S_INIT;
            bit_counter <= 3'b0;
        end else begin
            current_state <= next_state;
        end
    end

    // FSM: Next state logic
    always_comb begin
        case (current_state)
            S_INIT: begin
                if (go) begin
                    next_state = S_SHIFT_DIVIDEND;
                end else begin
                    next_state = S_INIT;
                end
            end
            S_SHIFT_DIVIDEND: begin
                next_state = S_SUBTRACT;
            end
            S_SUBTRACT: begin
                next_state = S_CHECK;
            end
            S_CHECK: begin
                if (bit_counter == 3'b100) begin
                    next_state = S_DONE;       // Finished all bits
                end else begin
                    next_state = S_SHIFT_QUOTIENT;
                end
            end
            S_SHIFT_QUOTIENT: begin
                next_state = S_SHIFT_DIVIDEND;
            end
            S_DONE: begin
                next_state = S_DONE;  // Remain in DONE state
            end
            default: next_state = S_INIT;
        endcase
    end

    // Control Signals based on State
    always_comb begin
        // Default values for control signals
        load = 1'b0;
        shift = 1'b0;
        sub = 1'b0;
        done = 1'b0;
        
        case (current_state)
            S_INIT: begin
                load = 1'b1;  // Load divisor and dividend in the initial state
            end
            S_SHIFT_DIVIDEND: begin
                shift = 1'b1; // Shift the next bit of the dividend into accumulator
            end
            S_SUBTRACT: begin
                sub = 1'b1;   // Perform subtraction in the ALU
            end
            S_CHECK: begin
                // No control signals here, just checking the result
            end
            S_SHIFT_QUOTIENT: begin
                shift = 1'b1; // Shift the quotient register for the next bit
            end
            S_DONE: begin
                done = 1'b1;  // Division is complete
            end
        endcase
    end

    // Bit counter to track division progress
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_counter <= 3'b0;
        end else if (current_state == S_CHECK) begin
            bit_counter <= bit_counter + 1; // Increment after each bit is processed
        end
    end

endmodule