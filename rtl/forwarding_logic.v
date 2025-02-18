`default_nettype none
`include "constants.vh"

module forwarding_logic (
    input  wire [`LA64_ARF_SEL-1:0]    i_rs_raddr_id,

    input  wire                        i_i1_rd_we_ex1,
    input  wire                        i_i1_rd_we_ex2,
    input  wire                        i_i1_rd_we_ex3,
    input  wire                        i_i1_rd_we_ex4,
    input  wire                        i_i1_rd_we_wb,

    input  wire [`LA64_ARF_SEL-1:0]    i_i1_rd_waddr_ex1,
    input  wire [`LA64_ARF_SEL-1:0]    i_i1_rd_waddr_ex2,
    input  wire [`LA64_ARF_SEL-1:0]    i_i1_rd_waddr_ex3,
    input  wire [`LA64_ARF_SEL-1:0]    i_i1_rd_waddr_ex4,
    input  wire [`LA64_ARF_SEL-1:0]    i_i1_rd_waddr_wb,

    input  wire [`LA64_DATA_WIDTH-1:0] i_i1_result_ex1,
    input  wire [`LA64_DATA_WIDTH-1:0] i_i1_result_ex2,
    input  wire [`LA64_DATA_WIDTH-1:0] i_i1_result_ex3_final,
    input  wire [`LA64_DATA_WIDTH-1:0] i_i1_result_ex4_final,
    input  wire [`LA64_DATA_WIDTH-1:0] i_i1_result_wb,

    input  wire                        i_i2_rd_we_ex1,
    input  wire                        i_i2_rd_we_ex2,
    input  wire                        i_i2_rd_we_ex3,
    input  wire                        i_i2_rd_we_ex4,
    input  wire                        i_i2_rd_we_wb,

    input  wire [`LA64_ARF_SEL-1:0]    i_i2_rd_waddr_ex1,
    input  wire [`LA64_ARF_SEL-1:0]    i_i2_rd_waddr_ex2,
    input  wire [`LA64_ARF_SEL-1:0]    i_i2_rd_waddr_ex3,
    input  wire [`LA64_ARF_SEL-1:0]    i_i2_rd_waddr_ex4,
    input  wire [`LA64_ARF_SEL-1:0]    i_i2_rd_waddr_wb,

    input  wire [`LA64_DATA_WIDTH-1:0] i_i2_result_ex1,
    input  wire [`LA64_DATA_WIDTH-1:0] i_i2_result_ex2,
    input  wire [`LA64_DATA_WIDTH-1:0] i_i2_result_ex3_final,
    input  wire [`LA64_DATA_WIDTH-1:0] i_i2_result_ex4_final,
    input  wire [`LA64_DATA_WIDTH-1:0] i_i2_result_wb,

    output wire                        o_rs_rdata_bypass_vld_id,
    output wire [`LA64_DATA_WIDTH-1:0] o_rs_rdata_bypass_id
);

    wire rs_rdata_bypass_i1_ex1_vld;
    wire rs_rdata_bypass_i1_ex2_vld;
    wire rs_rdata_bypass_i1_ex3_vld;
    wire rs_rdata_bypass_i1_ex4_vld;
    wire rs_rdata_bypass_i1_wb_vld;

    wire rs_rdata_bypass_i2_ex1_vld;
    wire rs_rdata_bypass_i2_ex2_vld;
    wire rs_rdata_bypass_i2_ex3_vld;
    wire rs_rdata_bypass_i2_ex4_vld;
    wire rs_rdata_bypass_i2_wb_vld;

    assign rs_rdata_bypass_i1_ex1_vld = i_i1_rd_we_ex1 & (i_rs_raddr_id == i_i1_rd_waddr_ex1);
    assign rs_rdata_bypass_i1_ex2_vld = i_i1_rd_we_ex2 & (i_rs_raddr_id == i_i1_rd_waddr_ex2);
    assign rs_rdata_bypass_i1_ex3_vld = i_i1_rd_we_ex3 & (i_rs_raddr_id == i_i1_rd_waddr_ex3);
    assign rs_rdata_bypass_i1_ex4_vld = i_i1_rd_we_ex4 & (i_rs_raddr_id == i_i1_rd_waddr_ex4);
    assign rs_rdata_bypass_i1_wb_vld  = i_i1_rd_we_wb  & (i_rs_raddr_id == i_i1_rd_waddr_wb);

    assign rs_rdata_bypass_i2_ex1_vld = i_i2_rd_we_ex1 & (i_rs_raddr_id == i_i2_rd_waddr_ex1);
    assign rs_rdata_bypass_i2_ex2_vld = i_i2_rd_we_ex2 & (i_rs_raddr_id == i_i2_rd_waddr_ex2);
    assign rs_rdata_bypass_i2_ex3_vld = i_i2_rd_we_ex3 & (i_rs_raddr_id == i_i2_rd_waddr_ex3);
    assign rs_rdata_bypass_i2_ex4_vld = i_i2_rd_we_ex4 & (i_rs_raddr_id == i_i2_rd_waddr_ex4);
    assign rs_rdata_bypass_i2_wb_vld  = i_i2_rd_we_wb  & (i_rs_raddr_id == i_i2_rd_waddr_wb);


    assign o_rs_rdata_bypass_vld_id = rs_rdata_bypass_i1_ex1_vld | rs_rdata_bypass_i2_ex1_vld |
                                      rs_rdata_bypass_i1_ex2_vld | rs_rdata_bypass_i2_ex2_vld |
                                      rs_rdata_bypass_i1_ex3_vld | rs_rdata_bypass_i2_ex3_vld |
                                      rs_rdata_bypass_i1_ex4_vld | rs_rdata_bypass_i2_ex4_vld |
                                      rs_rdata_bypass_i1_wb_vld  | rs_rdata_bypass_i2_wb_vld;

    assign o_rs_rdata_bypass_id = rs_rdata_bypass_i2_ex1_vld ? i_i2_result_ex1       :
                                  rs_rdata_bypass_i1_ex1_vld ? i_i1_result_ex1       :
                                  rs_rdata_bypass_i2_ex2_vld ? i_i2_result_ex2       :
                                  rs_rdata_bypass_i1_ex2_vld ? i_i1_result_ex2       :
                                  rs_rdata_bypass_i2_ex3_vld ? i_i2_result_ex3_final :
                                  rs_rdata_bypass_i1_ex3_vld ? i_i1_result_ex3_final :
                                  rs_rdata_bypass_i2_ex4_vld ? i_i2_result_ex4_final :
                                  rs_rdata_bypass_i1_ex4_vld ? i_i1_result_ex4_final :
                                  rs_rdata_bypass_i2_wb_vld  ? i_i2_result_wb        :
                                  i_i1_result_wb;

endmodule

`default_nettype wire
