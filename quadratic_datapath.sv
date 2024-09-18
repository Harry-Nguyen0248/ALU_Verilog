module datapath(
    input logic clk,
    input logic reset,
    input logic [7:0] data_in,
    input logic ld_alu_out,
    input logic ld_a, ld_b,
    // TODO: Add additional signals from control path here. 
    input logic ld_c, ld_x,
    input logic ld_r,
    input logic alu_op,
    input logic alu_select_a, alu_select_b,
    output logic [7:0] data_result
    );

    // input logic logicisters
    logic [7:0] a, b;
    logic [7:0] c, x;

    // output logic of the alu
    logic [7:0] alu_out;
    // alu input logic muxes
    logic [7:0] alu_a, alu_b;

    // registers a and b with associated logic
    always_ff @(posedge clk) begin
        if(reset) begin
            a <= 8'b0;
            b <= 8'b0;
        end
        else begin
            if(ld_a) a <= ld_alu_out ? alu_out : data_in; // load alu_out if load_alu_out signal is high, otherwise load from data_in
            if(ld_b) b <= ld_alu_out ? alu_out : data_in; 
            //TODO: Add signals to set additional registers. 
            if(ld_c) c <= data_in;
            if(ld_x) x <= data_in;
            // Note that only registers A and B have a mux to load values from data_in or from alu_out
        end
    end

    // output logic result logicister
    always@(posedge clk) begin
        if(reset) begin
            data_result <= 8'b0;
        end
        else
            if(ld_r)
                data_result <= alu_out;
    end

    // The ALU input logic multiplexers
    always_comb begin
        case (alu_select_a)
            2'd0: alu_a = a;
            2'd1: alu_a = b;
            2'd2: alu_a = c;
            2'd3: alu_a = x;
            default: alu_a = 8'b0;
        endcase

        case (alu_select_b)
            2'd0: alu_b = a;
            2'd1: alu_b = b;
            2'd2: alu_b = c;
            2'd3: alu_b = x;
            default: alu_b = 8'b0;
        endcase
    end

    // The ALU
    always_comb begin : ALU
        case (alu_op)
            0: alu_out = alu_a + alu_b; //performs addition
            1: alu_out = alu_a * alu_b; //performs multiplication
            default: alu_out = 8'b0;
        endcase
    end

endmodule