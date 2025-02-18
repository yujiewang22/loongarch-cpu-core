`default_nettype none
`include "constants.vh"

module dff #(
    parameter DATA_WIDTH = 1 
)( 
    input  wire    	             clk,
    input  wire	                 rst_n,
    input  wire                  i_en,
    input  wire [DATA_WIDTH-1:0] i_din,
    output reg  [DATA_WIDTH-1:0] o_dout
);

    always @(posedge clk) begin
        if (!rst_n) begin
            o_dout <= 'd0;
        end else if (i_en) begin
            o_dout <= i_din;
        end
    end

endmodule

module decoder_2_4(
    input  wire [ 1:0] i_in,
    output wire [ 3:0] o_out
);

    genvar i;
    generate 
        for (i = 0; i < 4; i = i + 1) begin : gen_for_dec_2_4
            assign o_out[i] = (i_in == i);
        end 
    endgenerate

endmodule

module decoder_5_32(
    input  wire [ 4:0] i_in,
    output wire [31:0] o_out
);

    genvar i;
    generate 
        for (i = 0; i < 32; i = i + 1) begin : gen_for_dec_5_32
            assign o_out[i] = (i_in == i);
        end 
    endgenerate

endmodule

module decoder_6_64(
    input  wire [ 5:0] i_in,
    output wire [63:0] o_out
);

    genvar i;
    generate 
        for (i = 0; i < 64; i = i + 1) begin : gen_for_dec_6_64 
            assign o_out[i] = (i_in == i);
        end
    endgenerate

endmodule


`default_nettype wire
