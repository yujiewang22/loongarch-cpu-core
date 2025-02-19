`include "constants.vh"

module dec (
    input  logic                        clk,              
    input  logic                        rst_n,

    output logic [`LA64_DATA_WIDTH-1:0] i1_rj_rdata_final,
    output logic [`LA64_DATA_WIDTH-1:0] i1_rk_rdata_final,
    output logic                        i1_rd_we,
    output logic [`LA64_DATA_WIDTH-1:0] i1_rd_waddr,
    output logic [`ALU_OP_WIDTH-1:0]    i1_alu_op,

    output logic [`LA64_DATA_WIDTH-1:0] i2_rj_rdata_final,
    output logic [`LA64_DATA_WIDTH-1:0] i2_rk_rdata_final,
    output logic                        i2_rd_we,
    output logic [`LA64_DATA_WIDTH-1:0] i2_rd_waddr,
    output logic [`ALU_OP_WIDTH-1:0]    i2_alu_op,

    input  logic                        i1_rd_we_ex1,
    input  logic                        i1_rd_we_ex2,
    input  logic                        i1_rd_we_ex3,
    input  logic                        i1_rd_we_ex4,
    input  logic                        i1_rd_we_wb,

    input  logic [`LA64_ARF_SEL-1:0]    i1_rd_waddr_ex1,
    input  logic [`LA64_ARF_SEL-1:0]    i1_rd_waddr_ex2,
    input  logic [`LA64_ARF_SEL-1:0]    i1_rd_waddr_ex3,
    input  logic [`LA64_ARF_SEL-1:0]    i1_rd_waddr_ex4,
    input  logic [`LA64_ARF_SEL-1:0]    i1_rd_waddr_wb,

    input  logic [`LA64_DATA_WIDTH-1:0] i1_result_ex1,
    input  logic [`LA64_DATA_WIDTH-1:0] i1_result_ex2,
    input  logic [`LA64_DATA_WIDTH-1:0] i1_result_ex3_final,
    input  logic [`LA64_DATA_WIDTH-1:0] i1_result_ex4_final,
    input  logic [`LA64_DATA_WIDTH-1:0] i1_result_wb,

    input  logic                        i2_rd_we_ex1,
    input  logic                        i2_rd_we_ex2,
    input  logic                        i2_rd_we_ex3,
    input  logic                        i2_rd_we_ex4,
    input  logic                        i2_rd_we_wb,

    input  logic [`LA64_ARF_SEL-1:0]    i2_rd_waddr_ex1,
    input  logic [`LA64_ARF_SEL-1:0]    i2_rd_waddr_ex2,
    input  logic [`LA64_ARF_SEL-1:0]    i2_rd_waddr_ex3,
    input  logic [`LA64_ARF_SEL-1:0]    i2_rd_waddr_ex4,
    input  logic [`LA64_ARF_SEL-1:0]    i2_rd_waddr_wb,

    input  logic [`LA64_DATA_WIDTH-1:0] i2_result_ex1,
    input  logic [`LA64_DATA_WIDTH-1:0] i2_result_ex2,
    input  logic [`LA64_DATA_WIDTH-1:0] i2_result_ex3_final,
    input  logic [`LA64_DATA_WIDTH-1:0] i2_result_ex4_final,
    input  logic [`LA64_DATA_WIDTH-1:0] i2_result_wb,

    output logic                        i1_rj_bypass_en_ex3,
    output logic                        i1_rk_bypass_en_ex3,
    output logic                        i2_rj_bypass_en_ex3,
    output logic                        i2_rk_bypass_en_ex3,

    output logic [`LA64_DATA_WIDTH-1:0] i1_rj_bypass_data_ex3,
    output logic [`LA64_DATA_WIDTH-1:0] i1_rk_bypass_data_ex3,
    output logic [`LA64_DATA_WIDTH-1:0] i2_rj_bypass_data_ex3,
    output logic [`LA64_DATA_WIDTH-1:0] i2_rk_bypass_data_ex3
);   

    logic [`LA64_ARF_SEL-1:0]    i1_rj_raddr;
    logic [`LA64_ARF_SEL-1:0]    i1_rk_raddr; 
    logic [`LA64_DATA_WIDTH-1:0] i1_rj_rdata;
    logic [`LA64_DATA_WIDTH-1:0] i1_rk_rdata;

    logic [`LA64_ARF_SEL-1:0]    i2_rj_raddr;
    logic [`LA64_ARF_SEL-1:0]    i2_rk_raddr;
    logic [`LA64_DATA_WIDTH-1:0] i2_rj_rdata;
    logic [`LA64_DATA_WIDTH-1:0] i2_rk_rdata;

    dec_decode_ctl u_dec_decode_ctl_1 (
        .inst       (),
        .inst_valid (),
        .rj_re      (),
        .rk_re      (),
        .rd_we      (),
        .rj_raddr   (i1_rj_raddr),
        .rk_raddr   (i1_rk_raddr),
        .rd_waddr   (),
        .alu_op     (i1_alu_op)
    );

    dec_decode_ctl u_dec_decode_ctl_2 (
        .inst       (),
        .inst_valid (),
        .rj_re      (),
        .rk_re      (),
        .rd_we      (),
        .rj_raddr   (i2_rj_raddr),
        .rk_raddr   (i2_rk_raddr),
        .rd_waddr   (),
        .alu_op     (i2_alu_op)
    );

    dec_gpr_ctl u_dec_gpr_ctl (
        .*,
        .re0    (i1_rj_raddr),
        .re1    (i1_rk_raddr),
        .re2    (i2_rj_raddr),
        .re3    (i2_rk_raddr),
        .raddr0 (i1_rj_raddr),
        .raddr1 (i1_rk_raddr),
        .raddr2 (i2_rj_raddr),
        .raddr3 (i2_rk_raddr),
        .rd0    (i1_rj_rdata),
        .rd1    (i1_rk_rdata),
        .rd2    (i2_rj_rdata),
        .rd3    (i2_rk_rdata),
        .we0    (),
        .we1    (),
        .we2    (),
        .waddr0 (),
        .waddr1 (),
        .waddr2 (),
        .wd0    (),
        .wd1    (),
        .wd2    ()
    );

    logic [9:0] i1_rj_bypass_v_dec;
    logic [9:0] i1_rk_bypass_v_dec;
    logic [9:0] i2_rj_bypass_v_dec;
    logic [9:0] i2_rk_bypass_v_dec;

    logic [9:0] i1_rj_bypass_vp_dec;
    logic [9:0] i1_rk_bypass_vp_dec;
    logic [9:0] i2_rj_bypass_vp_dec;
    logic [9:0] i2_rk_bypass_vp_dec;
    
    logic i1_rj_bypass_en_dec;
    logic i1_rk_bypass_en_dec;
    logic i2_rj_bypass_en_dec;
    logic i2_rk_bypass_en_dec;

    logic [`LA64_DATA_WIDTH-1:0] i1_rj_bypass_data_dec;
    logic [`LA64_DATA_WIDTH-1:0] i1_rk_bypass_data_dec;
    logic [`LA64_DATA_WIDTH-1:0] i2_rj_bypass_data_dec;
    logic [`LA64_DATA_WIDTH-1:0] i2_rk_bypass_data_dec;

    assign i1_rj_bypass_v_dec[0] = i2_rd_we_ex1 & (i1_rj_raddr == i2_rd_waddr_ex1);
    assign i1_rj_bypass_v_dec[1] = i1_rd_we_ex1 & (i1_rj_raddr == i1_rd_waddr_ex1);
    assign i1_rj_bypass_v_dec[2] = i2_rd_we_ex2 & (i1_rj_raddr == i2_rd_waddr_ex2);
    assign i1_rj_bypass_v_dec[3] = i1_rd_we_ex2 & (i1_rj_raddr == i1_rd_waddr_ex2);
    assign i1_rj_bypass_v_dec[4] = i2_rd_we_ex3 & (i1_rj_raddr == i2_rd_waddr_ex3);
    assign i1_rj_bypass_v_dec[5] = i1_rd_we_ex3 & (i1_rj_raddr == i1_rd_waddr_ex3);
    assign i1_rj_bypass_v_dec[6] = i2_rd_we_ex4 & (i1_rj_raddr == i2_rd_waddr_ex4);
    assign i1_rj_bypass_v_dec[7] = i1_rd_we_ex4 & (i1_rj_raddr == i1_rd_waddr_ex4);
    assign i1_rj_bypass_v_dec[8] = i2_rd_we_wb  & (i1_rj_raddr == i2_rd_waddr_wb);
    assign i1_rj_bypass_v_dec[9] = i1_rd_we_wb  & (i1_rj_raddr == i1_rd_waddr_wb);

    assign i1_rk_bypass_v_dec[0] = i2_rd_we_ex1 & (i1_rk_raddr == i2_rd_waddr_ex1);
    assign i1_rk_bypass_v_dec[1] = i1_rd_we_ex1 & (i1_rk_raddr == i1_rd_waddr_ex1);
    assign i1_rk_bypass_v_dec[2] = i2_rd_we_ex2 & (i1_rk_raddr == i2_rd_waddr_ex2);
    assign i1_rk_bypass_v_dec[3] = i1_rd_we_ex2 & (i1_rk_raddr == i1_rd_waddr_ex2);
    assign i1_rk_bypass_v_dec[4] = i2_rd_we_ex3 & (i1_rk_raddr == i2_rd_waddr_ex3);
    assign i1_rk_bypass_v_dec[5] = i1_rd_we_ex3 & (i1_rk_raddr == i1_rd_waddr_ex3);
    assign i1_rk_bypass_v_dec[6] = i2_rd_we_ex4 & (i1_rk_raddr == i2_rd_waddr_ex4);
    assign i1_rk_bypass_v_dec[7] = i1_rd_we_ex4 & (i1_rk_raddr == i1_rd_waddr_ex4);
    assign i1_rk_bypass_v_dec[8] = i2_rd_we_wb  & (i1_rk_raddr == i2_rd_waddr_wb);
    assign i1_rk_bypass_v_dec[9] = i1_rd_we_wb  & (i1_rk_raddr == i1_rd_waddr_wb);

    assign i2_rj_bypass_v_dec[0] = i1_rd_we_ex1 & (i2_rj_raddr == i1_rd_waddr_ex1);
    assign i2_rj_bypass_v_dec[1] = i2_rd_we_ex1 & (i2_rj_raddr == i2_rd_waddr_ex1);
    assign i2_rj_bypass_v_dec[2] = i1_rd_we_ex2 & (i2_rj_raddr == i1_rd_waddr_ex2);     
    assign i2_rj_bypass_v_dec[3] = i2_rd_we_ex2 & (i2_rj_raddr == i2_rd_waddr_ex2);
    assign i2_rj_bypass_v_dec[4] = i1_rd_we_ex3 & (i2_rj_raddr == i1_rd_waddr_ex3);
    assign i2_rj_bypass_v_dec[5] = i2_rd_we_ex3 & (i2_rj_raddr == i2_rd_waddr_ex3);
    assign i2_rj_bypass_v_dec[6] = i1_rd_we_ex4 & (i2_rj_raddr == i1_rd_waddr_ex4);
    assign i2_rj_bypass_v_dec[7] = i2_rd_we_ex4 & (i2_rj_raddr == i2_rd_waddr_ex4);
    assign i2_rj_bypass_v_dec[8] = i1_rd_we_wb  & (i2_rj_raddr == i1_rd_waddr_wb);
    assign i2_rj_bypass_v_dec[9] = i2_rd_we_wb  & (i2_rj_raddr == i2_rd_waddr_wb);

    assign i2_rk_bypass_v_dec[0] = i1_rd_we_ex1 & (i2_rk_raddr == i1_rd_waddr_ex1);
    assign i2_rk_bypass_v_dec[1] = i2_rd_we_ex1 & (i2_rk_raddr == i2_rd_waddr_ex1);
    assign i2_rk_bypass_v_dec[2] = i1_rd_we_ex2 & (i2_rk_raddr == i1_rd_waddr_ex2);
    assign i2_rk_bypass_v_dec[3] = i2_rd_we_ex2 & (i2_rk_raddr == i2_rd_waddr_ex2);
    assign i2_rk_bypass_v_dec[4] = i1_rd_we_ex3 & (i2_rk_raddr == i1_rd_waddr_ex3);
    assign i2_rk_bypass_v_dec[5] = i2_rd_we_ex3 & (i2_rk_raddr == i2_rd_waddr_ex3);
    assign i2_rk_bypass_v_dec[6] = i1_rd_we_ex4 & (i2_rk_raddr == i1_rd_waddr_ex4);
    assign i2_rk_bypass_v_dec[7] = i2_rd_we_ex4 & (i2_rk_raddr == i2_rd_waddr_ex4);
    assign i2_rk_bypass_v_dec[8] = i1_rd_we_wb  & (i2_rk_raddr == i1_rd_waddr_wb);
    assign i2_rk_bypass_v_dec[9] = i2_rd_we_wb  & (i2_rk_raddr == i2_rd_waddr_wb);

    assign i1_rj_bypass_en_dec = |i1_rj_bypass_v_dec;
    assign i1_rk_bypass_en_dec = |i1_rk_bypass_v_dec;  
    assign i2_rj_bypass_en_dec = |i2_rj_bypass_v_dec;
    assign i2_rk_bypass_en_dec = |i2_rk_bypass_v_dec;

    assign i1_rj_bypass_vp_dec = i1_rj_bypass_v_dec[0] ? 10'b0000000001 :
                                 i1_rj_bypass_v_dec[1] ? 10'b0000000010 :
                                 i1_rj_bypass_v_dec[2] ? 10'b0000000100 :
                                 i1_rj_bypass_v_dec[3] ? 10'b0000001000 :
                                 i1_rj_bypass_v_dec[4] ? 10'b0000010000 :
                                 i1_rj_bypass_v_dec[5] ? 10'b0000100000 :
                                 i1_rj_bypass_v_dec[6] ? 10'b0001000000 :
                                 i1_rj_bypass_v_dec[7] ? 10'b0010000000 :
                                 i1_rj_bypass_v_dec[8] ? 10'b0100000000 :
                                 i1_rj_bypass_v_dec[9] ? 10'b1000000000 :
                                 10'b0000000000;

    assign i1_rk_bypass_vp_dec = i1_rk_bypass_v_dec[0] ? 10'b0000000001 :
                                 i1_rk_bypass_v_dec[1] ? 10'b0000000010 :
                                 i1_rk_bypass_v_dec[2] ? 10'b0000000100 :
                                 i1_rk_bypass_v_dec[3] ? 10'b0000001000 :
                                 i1_rk_bypass_v_dec[4] ? 10'b0000010000 :
                                 i1_rk_bypass_v_dec[5] ? 10'b0000100000 :
                                 i1_rk_bypass_v_dec[6] ? 10'b0001000000 :
                                 i1_rk_bypass_v_dec[7] ? 10'b0010000000 :
                                 i1_rk_bypass_v_dec[8] ? 10'b0100000000 :
                                 i1_rk_bypass_v_dec[9] ? 10'b1000000000 :
                                 10'b0000000000;

    assign i2_rj_bypass_vp_dec = i2_rj_bypass_v_dec[0] ? 10'b0000000001 :
                                 i2_rj_bypass_v_dec[1] ? 10'b0000000010 :
                                 i2_rj_bypass_v_dec[2] ? 10'b0000000100 :
                                 i2_rj_bypass_v_dec[3] ? 10'b0000001000 :
                                 i2_rj_bypass_v_dec[4] ? 10'b0000010000 :
                                 i2_rj_bypass_v_dec[5] ? 10'b0000100000 :
                                 i2_rj_bypass_v_dec[6] ? 10'b0001000000 :
                                 i2_rj_bypass_v_dec[7] ? 10'b0010000000 :
                                 i2_rj_bypass_v_dec[8] ? 10'b0100000000 :
                                 i2_rj_bypass_v_dec[9] ? 10'b1000000000 :
                                 10'b0000000000;

    assign i2_rk_bypass_vp_dec = i2_rk_bypass_v_dec[0] ? 10'b0000000001 :
                                 i2_rk_bypass_v_dec[1] ? 10'b0000000010 :
                                 i2_rk_bypass_v_dec[2] ? 10'b0000000100 :
                                 i2_rk_bypass_v_dec[3] ? 10'b0000001000 :
                                 i2_rk_bypass_v_dec[4] ? 10'b0000010000 :
                                 i2_rk_bypass_v_dec[5] ? 10'b0000100000 :
                                 i2_rk_bypass_v_dec[6] ? 10'b0001000000 :
                                 i2_rk_bypass_v_dec[7] ? 10'b0010000000 :
                                 i2_rk_bypass_v_dec[8] ? 10'b0100000000 :
                                 i2_rk_bypass_v_dec[9] ? 10'b1000000000 :
                                 10'b0000000000;

    assign i1_rj_bypass_data_dec = ({`LA64_DATA_WIDTH{i1_rj_bypass_vp_dec[0]}} & i2_result_ex1      ) |
                                   ({`LA64_DATA_WIDTH{i1_rj_bypass_vp_dec[1]}} & i1_result_ex1      ) |
                                   ({`LA64_DATA_WIDTH{i1_rj_bypass_vp_dec[2]}} & i2_result_ex2      ) |
                                   ({`LA64_DATA_WIDTH{i1_rj_bypass_vp_dec[3]}} & i1_result_ex2      ) |
                                   ({`LA64_DATA_WIDTH{i1_rj_bypass_vp_dec[4]}} & i2_result_ex3_final) |
                                   ({`LA64_DATA_WIDTH{i1_rj_bypass_vp_dec[5]}} & i1_result_ex3_final) |
                                   ({`LA64_DATA_WIDTH{i1_rj_bypass_vp_dec[6]}} & i2_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i1_rj_bypass_vp_dec[7]}} & i1_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i1_rj_bypass_vp_dec[8]}} & i2_result_wb       ) |
                                   ({`LA64_DATA_WIDTH{i1_rj_bypass_vp_dec[9]}} & i1_result_wb       );

    assign i1_rk_bypass_data_dec = ({`LA64_DATA_WIDTH{i1_rk_bypass_vp_dec[0]}} & i2_result_ex1      ) |
                                   ({`LA64_DATA_WIDTH{i1_rk_bypass_vp_dec[1]}} & i1_result_ex1      ) |
                                   ({`LA64_DATA_WIDTH{i1_rk_bypass_vp_dec[2]}} & i2_result_ex2      ) |
                                   ({`LA64_DATA_WIDTH{i1_rk_bypass_vp_dec[3]}} & i1_result_ex2      ) |
                                   ({`LA64_DATA_WIDTH{i1_rk_bypass_vp_dec[4]}} & i2_result_ex3_final) |
                                   ({`LA64_DATA_WIDTH{i1_rk_bypass_vp_dec[5]}} & i1_result_ex3_final) |
                                   ({`LA64_DATA_WIDTH{i1_rk_bypass_vp_dec[6]}} & i2_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i1_rk_bypass_vp_dec[7]}} & i1_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i1_rk_bypass_vp_dec[8]}} & i2_result_wb       ) |
                                   ({`LA64_DATA_WIDTH{i1_rk_bypass_vp_dec[9]}} & i1_result_wb       );
    
    assign i2_rj_bypass_data_dec = ({`LA64_DATA_WIDTH{i2_rj_bypass_vp_dec[0]}} & i1_result_ex1      ) |
                                   ({`LA64_DATA_WIDTH{i2_rj_bypass_vp_dec[1]}} & i2_result_ex1      ) |
                                   ({`LA64_DATA_WIDTH{i2_rj_bypass_vp_dec[2]}} & i1_result_ex2      ) |
                                   ({`LA64_DATA_WIDTH{i2_rj_bypass_vp_dec[3]}} & i2_result_ex2      ) |
                                   ({`LA64_DATA_WIDTH{i2_rj_bypass_vp_dec[4]}} & i1_result_ex3_final) |
                                   ({`LA64_DATA_WIDTH{i2_rj_bypass_vp_dec[5]}} & i2_result_ex3_final) |
                                   ({`LA64_DATA_WIDTH{i2_rj_bypass_vp_dec[6]}} & i1_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i2_rj_bypass_vp_dec[7]}} & i2_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i2_rj_bypass_vp_dec[8]}} & i1_result_wb       ) |
                                   ({`LA64_DATA_WIDTH{i2_rj_bypass_vp_dec[9]}} & i2_result_wb       );

    assign i2_rk_bypass_data_dec = ({`LA64_DATA_WIDTH{i2_rk_bypass_vp_dec[0]}} & i1_result_ex1      ) |
                                   ({`LA64_DATA_WIDTH{i2_rk_bypass_vp_dec[1]}} & i2_result_ex1      ) |
                                   ({`LA64_DATA_WIDTH{i2_rk_bypass_vp_dec[2]}} & i1_result_ex2      ) |
                                   ({`LA64_DATA_WIDTH{i2_rk_bypass_vp_dec[3]}} & i2_result_ex2      ) |
                                   ({`LA64_DATA_WIDTH{i2_rk_bypass_vp_dec[4]}} & i1_result_ex3_final) |
                                   ({`LA64_DATA_WIDTH{i2_rk_bypass_vp_dec[5]}} & i2_result_ex3_final) |
                                   ({`LA64_DATA_WIDTH{i2_rk_bypass_vp_dec[6]}} & i1_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i2_rk_bypass_vp_dec[7]}} & i2_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i2_rk_bypass_vp_dec[8]}} & i1_result_wb       ) |
                                   ({`LA64_DATA_WIDTH{i2_rk_bypass_vp_dec[9]}} & i2_result_wb       );

    assign i1_rj_rdata_final = i1_rj_bypass_en_dec ? i1_rj_bypass_data_dec : i1_rj_rdata;
    assign i1_rk_rdata_final = i1_rk_bypass_en_dec ? i1_rk_bypass_data_dec : i1_rk_rdata;
    assign i2_rj_rdata_final = i2_rj_bypass_en_dec ? i2_rj_bypass_data_dec : i2_rj_rdata;
    assign i2_rk_rdata_final = i2_rk_bypass_en_dec ? i2_rk_bypass_data_dec : i2_rk_rdata;

    logic [3:0] i1_rj_bypass_v_ex3;
    logic [3:0] i1_rk_bypass_v_ex3;
    logic [3:0] i2_rj_bypass_v_ex3;
    logic [3:0] i2_rk_bypass_v_ex3;

    logic [3:0] i1_rj_bypass_vp_ex3;
    logic [3:0] i1_rk_bypass_vp_ex3; 
    logic [3:0] i2_rj_bypass_vp_ex3;
    logic [3:0] i2_rk_bypass_vp_ex3;

    assign i1_rj_bypass_v_ex3[0] = i2_rd_we_ex4 & (i1_rj_raddr == i2_rd_waddr_ex4);
    assign i1_rj_bypass_v_ex3[1] = i1_rd_we_ex4 & (i1_rj_raddr == i1_rd_waddr_ex4);
    assign i1_rj_bypass_v_ex3[2] = i2_rd_we_wb  & (i1_rj_raddr == i2_rd_waddr_wb);  
    assign i1_rj_bypass_v_ex3[3] = i1_rd_we_wb  & (i1_rj_raddr == i1_rd_waddr_wb);

    assign i1_rk_bypass_v_ex3[0] = i2_rd_we_ex4 & (i1_rk_raddr == i2_rd_waddr_ex4);
    assign i1_rk_bypass_v_ex3[1] = i1_rd_we_ex4 & (i1_rk_raddr == i1_rd_waddr_ex4);
    assign i1_rk_bypass_v_ex3[2] = i2_rd_we_wb  & (i1_rk_raddr == i2_rd_waddr_wb);
    assign i1_rk_bypass_v_ex3[3] = i1_rd_we_wb  & (i1_rk_raddr == i1_rd_waddr_wb);

    assign i2_rj_bypass_v_ex3[0] = i1_rd_we_ex4 & (i2_rj_raddr == i1_rd_waddr_ex4);
    assign i2_rj_bypass_v_ex3[1] = i2_rd_we_ex4 & (i2_rj_raddr == i2_rd_waddr_ex4);
    assign i2_rj_bypass_v_ex3[2] = i1_rd_we_wb  & (i2_rj_raddr == i1_rd_waddr_wb);
    assign i2_rj_bypass_v_ex3[3] = i2_rd_we_wb  & (i2_rj_raddr == i2_rd_waddr_wb);

    assign i2_rk_bypass_v_ex3[0] = i1_rd_we_ex4 & (i2_rk_raddr == i1_rd_waddr_ex4);
    assign i2_rk_bypass_v_ex3[1] = i2_rd_we_ex4 & (i2_rk_raddr == i2_rd_waddr_ex4);
    assign i2_rk_bypass_v_ex3[2] = i1_rd_we_wb  & (i2_rk_raddr == i1_rd_waddr_wb);
    assign i2_rk_bypass_v_ex3[3] = i2_rd_we_wb  & (i2_rk_raddr == i2_rd_waddr_wb);

    assign i1_rj_bypass_en_ex3 = |i1_rj_bypass_v_ex3;
    assign i1_rk_bypass_en_ex3 = |i1_rk_bypass_v_ex3;
    assign i2_rj_bypass_en_ex3 = |i2_rj_bypass_v_ex3;
    assign i2_rk_bypass_en_ex3 = |i2_rk_bypass_v_ex3;

    assign i1_rj_bypass_vp_ex3 = i1_rj_bypass_v_ex3[0] ? 4'b0001 :
                                 i1_rj_bypass_v_ex3[1] ? 4'b0010 :
                                 i1_rj_bypass_v_ex3[2] ? 4'b0100 :
                                 i1_rj_bypass_v_ex3[3] ? 4'b1000 :
                                 4'b0000;
    
    assign i1_rk_bypass_vp_ex3 = i1_rj_bypass_v_ex3[0] ? 4'b0001 :
                                 i1_rk_bypass_v_ex3[1] ? 4'b0010 :
                                 i1_rk_bypass_v_ex3[2] ? 4'b0100 :
                                 i1_rk_bypass_v_ex3[3] ? 4'b1000 :
                                 4'b0000;
    
    assign i2_rj_bypass_vp_ex3 = i2_rj_bypass_v_ex3[0] ? 4'b0001 :
                                 i2_rj_bypass_v_ex3[1] ? 4'b0010 :
                                 i2_rj_bypass_v_ex3[2] ? 4'b0100 :
                                 i2_rj_bypass_v_ex3[3] ? 4'b1000 :
                                 4'b0000;

    assign i2_rk_bypass_vp_ex3 = i2_rk_bypass_v_ex3[0] ? 4'b0001 :
                                 i2_rk_bypass_v_ex3[1] ? 4'b0010 :
                                 i2_rk_bypass_v_ex3[2] ? 4'b0100 :
                                 i2_rk_bypass_v_ex3[3] ? 4'b1000 :
                                 4'b0000;

    assign i1_rj_bypass_data_ex3 = ({`LA64_DATA_WIDTH{i1_rj_bypass_vp_ex3[0]}} & i2_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i1_rj_bypass_vp_ex3[1]}} & i1_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i1_rj_bypass_vp_ex3[2]}} & i2_result_wb       ) |
                                   ({`LA64_DATA_WIDTH{i1_rj_bypass_vp_ex3[3]}} & i1_result_wb       );
    
    assign i1_rk_bypass_data_ex3 = ({`LA64_DATA_WIDTH{i1_rk_bypass_vp_ex3[0]}} & i2_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i1_rk_bypass_vp_ex3[1]}} & i1_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i1_rk_bypass_vp_ex3[2]}} & i2_result_wb       ) |
                                   ({`LA64_DATA_WIDTH{i1_rk_bypass_vp_ex3[3]}} & i1_result_wb       );

    assign i2_rj_bypass_data_ex3 = ({`LA64_DATA_WIDTH{i2_rj_bypass_vp_ex3[0]}} & i1_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i2_rj_bypass_vp_ex3[1]}} & i2_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i2_rj_bypass_vp_ex3[2]}} & i1_result_wb       ) |
                                   ({`LA64_DATA_WIDTH{i2_rj_bypass_vp_ex3[3]}} & i2_result_wb       );

    assign i2_rk_bypass_data_ex3 = ({`LA64_DATA_WIDTH{i2_rk_bypass_vp_ex3[0]}} & i1_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i2_rk_bypass_vp_ex3[1]}} & i2_result_ex4_final) |
                                   ({`LA64_DATA_WIDTH{i2_rk_bypass_vp_ex3[2]}} & i1_result_wb       ) |
                                   ({`LA64_DATA_WIDTH{i2_rk_bypass_vp_ex3[3]}} & i2_result_wb       );

endmodule