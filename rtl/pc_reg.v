`default_nettype none
`include "constants.vh"

module pc_reg (
    input  wire                      clk,
    input  wire                      rst_n,
    output reg  [`LA64_PC_WIDTH-1:0] o_pc
);

    wire [`LA64_PC_WIDTH-1:0] pc_inc;

    assign pc_inc = o_pc + 'd8;

    always @(posedge clk) begin
        if (!rst_n) begin
            o_pc <= `DEFAULT_PC;
        end else begin
            o_pc <= pc_inc;
        end
    end

endmodule

`default_nettype wire
