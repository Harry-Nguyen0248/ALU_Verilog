 module quadratic_fsm(
    input logic Clock,
    input logic Reset,
    input logic Go,
    input logic [7:0] DataIn,
    output logic [7:0] DataResult,
    output logic ResultValid
);

    // lots of wires to connect our datapath and control
    logic ld_a, ld_b, ld_r;
    // TODO: Add other ld_* signals you need here.
    logic ld_c, ld_x;
    logic ld_alu_out;
    logic alu_select_a, alu_select_b;
    logic alu_op;

    control C0(
        .clk(Clock),
        .reset(Reset),

        .go(Go),

        .ld_alu_out(ld_alu_out),
        
        .ld_a(ld_a),
        .ld_b(ld_b),
        .ld_r(ld_r),
        // TODO: Add other connections here.
        .ld_c(ld_c),
        .ld_x(ld_x),
        
        .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),
        .alu_op(alu_op),
        .result_valid(ResultValid)
    );

    datapath D0(
        .clk(Clock),
        .reset(Reset),

        .ld_alu_out(ld_alu_out),
        
        .ld_a(ld_a),
        .ld_b(ld_b),
        .ld_r(ld_r),
        // TODO: Add other connections here. 
        .ld_c(ld_c),
        .ld_x(ld_x),

        .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),
        .alu_op(alu_op),

        .data_in(DataIn),
        .data_result(DataResult)
    );

 endmodule


module control(
    input logic clk,
    input logic reset,
    input logic go,

    output logic ld_a, ld_b, ld_r,
    output logic ld_c, ld_x,

    output logic ld_alu_out,
    output logic alu_select_a, alu_select_b,
    output logic alu_op,
    output logic result_valid
    );

    typedef enum logic [3:0]  { S_LOAD_A_RST    = 'd0,
                                S_LOAD_A        = 'd1,
                                S_LOAD_A_WAIT   = 'd2,
                                S_LOAD_B        = 'd3,
                                S_LOAD_B_WAIT   = 'd4,
                                // TODO: Add states to load other inputs here. 
                                S_LOAD_x        = 'd5,
                                S_LOAD_x_WAIT   = 'd6,
                                S_LOAD_C        = 'd7,
                                S_LOAD_C_WAIT   = 'd8,
    
                                S_CYCLE_0       = 'd9,
                                S_CYCLE_1       = 'd10,
                                S_CYCLE_2       = 'd11,
                                S_CYCLE_3       = 'd12,
                                S_CYCLE_4       = 'd13} statetype;
                                
    statetype current_state, next_state;                            

    // Next state logic aka our state table
    always_comb begin
        case (current_state)
            S_LOAD_A_RST: next_state =  go ? S_LOAD_A_WAIT : S_LOAD_A_RST; // Loop in current state until value is input
            S_LOAD_A: next_state =      go ? S_LOAD_A_WAIT : S_LOAD_A; // Loop in current state until value is input
            S_LOAD_A_WAIT: next_state = go ? S_LOAD_A_WAIT : S_LOAD_B; 
            S_LOAD_B: next_state =      go ? S_LOAD_B_WAIT : S_LOAD_B; 
            // TODO: Add states for other inputs here.
            S_LOAD_B_WAIT: next_state = go ? S_LOAD_B_WAIT : S_LOAD_C; 
            S_LOAD_C: next_state =      go ? S_LOAD_C_WAIT : S_LOAD_C;
            S_LOAD_C_WAIT: next_state = go ? S_LOAD_C_WAIT : S_LOAD_x;
            S_LOAD_x: next_state      = go ? S_LOAD_x_WAIT : S_LOAD_x;
            S_LOAD_x_WAIT: next_state = go ? S_LOAD_x_WAIT : S_CYCLE_0;

            S_CYCLE_0: next_state = S_CYCLE_1;
            // TODO: Add new states for the required operation. 
            S_CYCLE_1: next_state = S_CYCLE_2;
            S_CYCLE_2: next_state = S_CYCLE_3;
            S_CYCLE_3: next_state = S_CYCLE_4;
            S_CYCLE_4: next_state = S_LOAD_A; // we will be done our five operations, start over after
            default:   next_state = S_LOAD_A_RST;
        endcase
    end // state_table

    // output logic logic aka all of our datapath control signals
    always_comb begin
        // By default make all our signals 0
        ld_alu_out = 1'b0;
        ld_a = 1'b0;
        ld_b = 1'b0;
        ld_c = 1'b0;
        ld_x = 1'b0;
        ld_r = 1'b0;
        alu_select_a = 1'b0;
        alu_select_b = 1'b0;
        alu_op       = 1'b0;
        result_valid = 1'b0;

        case (current_state)
            S_LOAD_A_RST: begin
                ld_a = 1'b1;
                end
            S_LOAD_A: begin
                ld_a = 1'b1;
                result_valid = 1'b1;
                end
            S_LOAD_B: begin
                ld_b = 1'b1;
                end
            S_LOAD_C: begin
                ld_c = 1'b1;
                end
            S_LOAD_x: begin
                ld_x = 1'b1;
                end
            S_CYCLE_0: begin // Do A <- A * x
                ld_alu_out = 1'b1; 
                ld_a = 1'b1; // store result back into A
                alu_select_a = 2'd0; // Select register A
                alu_select_b = 2'd3; // Also select register x
                alu_op = 1'b1; // Do multiply operation
            end
            S_CYCLE_1: begin // Do A <- Cycle 0 * x
                ld_alu_out = 1'b1; 
                ld_a = 1'b1; // store result back into A
                alu_select_a = 2'd0; // Select register A
                alu_select_b = 2'd3; // Also select register x
                alu_op = 1'b1; // Do multiply operation
            end
            S_CYCLE_2: begin // Do B <- B * x
                ld_alu_out = 1'b1; 
                ld_b = 1'b1; // store result back into B
                alu_select_a = 2'd1; // Select register B
                alu_select_b = 2'd3; // Also select register x
                alu_op = 1'b1; // Do multiply operation
            end
            S_CYCLE_3: begin // Do Ax^2 + Bx
                ld_alu_out = 1'b1;
                ld_a = 1'b1; //store result back into A
                alu_select_a = 2'd0; // Select Register A
                alu_select_b = 2'd1; // Select Register B
                alu_op = 1'b0;       // Do addition
            end
            S_CYCLE_4: begin // Do Ax^2 + Bx + C
                ld_r = 1'b1; // store result in result register
                alu_select_a = 2'd0; // Select register A
                alu_select_b = 2'd2; // Select register C
                alu_op = 1'b0; // Do Add operation
            end
            // We don't need a default case since we already made sure all of our outputs were assigned a value at the start of the always block.
        endcase
    end // enable_signals

    // current_state logicisters
    always_ff@(posedge clk) begin
        if(reset)
            current_state <= S_LOAD_A_RST;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

