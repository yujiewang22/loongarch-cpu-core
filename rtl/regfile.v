`default_nettype none
`include "constants.vh"

module regfile (
    input  wire                        clk,
    input  wire [`LA64_ARF_SEL-1:0]    i_raddr_1,
    input  wire [`LA64_ARF_SEL-1:0]    i_raddr_2,
    input  wire [`LA64_ARF_SEL-1:0]    i_raddr_3,
    input  wire [`LA64_ARF_SEL-1:0]    i_raddr_4,
    output wire [`LA64_DATA_WIDTH-1:0] o_rdata_1,
    output wire [`LA64_DATA_WIDTH-1:0] o_rdata_2,
    output wire [`LA64_DATA_WIDTH-1:0] o_rdata_3,
    output wire [`LA64_DATA_WIDTH-1:0] o_rdata_4,
    input  wire                        i_we_1,
    input  wire                        i_we_2,
    input  wire [`LA64_ARF_SEL-1:0]    i_waddr_1,
    input  wire [`LA64_ARF_SEL-1:0]    i_waddr_2,
    input  wire [`LA64_DATA_WIDTH-1:0] i_wdata_1,
    input  wire [`LA64_DATA_WIDTH-1:0] i_wdata_2
);

    reg [`LA64_DATA_WIDTH-1:0] mem [0:`LA64_ARF_NUM-1];

    assign o_rdata_1 = (i_raddr_1 == 'd0) ? 'd0 : mem[i_raddr_1];
    assign o_rdata_2 = (i_raddr_2 == 'd0) ? 'd0 : mem[i_raddr_2];
    assign o_rdata_3 = (i_raddr_3 == 'd0) ? 'd0 : mem[i_raddr_3];
    assign o_rdata_4 = (i_raddr_4 == 'd0) ? 'd0 : mem[i_raddr_4];

    always @(posedge clk) begin
        if (i_we_1 && (i_waddr_1 != 'd0)) begin
            mem[i_waddr_1] <= i_wdata_1;
        end
        if (i_we_2 && (i_waddr_2 != 'd0)) begin
            mem[i_waddr_2] <= i_wdata_2;
        end
    end

endmodule

`default_nettype wire
