`include "constants.vh"

module dff #(
    parameter WIDTH = 1 
)( 
    input  logic    	     clk,
    input  logic	         rst_n,
    input  logic [WIDTH-1:0] din,
    output logic [WIDTH-1:0] dout
);

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            dout <= 'd0;
        end else begin
            dout <= din;
        end
    end

endmodule

module dffe #(
    parameter WIDTH = 1 
)( 
    input  logic    	     clk,
    input  logic	         rst_n,
    input  logic             en,
    input  logic [WIDTH-1:0] din,
    output logic [WIDTH-1:0] dout
);

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            dout <= 'd0;
        end else if (en) begin
            dout <= din;
        end
    end

endmodule

module decoder_2_4 (
    input  logic [ 1:0] in,
    output logic [ 3:0] out
);

    for (genvar i=0; i<4; i++) begin : gen_for_dec_2_4
        assign out[i] = (in == i);
    end : gen_for_dec_2_4

endmodule

module decoder_5_32 (
    input  logic [ 4:0] in,
    output logic [31:0] out
);

    for (genvar i=0; i<32; i++) begin : gen_for_dec_5_32
        assign out[i] = (in == i);
    end : gen_for_dec_5_32
    
endmodule

module decoder_6_64 (
    input  logic [ 5:0] in,
    output logic [63:0] out
);

    for (genvar i=0; i<64; i++) begin : gen_for_dec_6_64 
        assign out[i] = (in == i);
    end : gen_for_dec_6_64

endmodule
