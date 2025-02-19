`include "constants.vh"

module deu (
    input  logic                        clk,              
    input  logic                        rst_n,

    input  logic [`LA64_DATA_WIDTH-1:0] i1_pc,

    output logic [`LA64_DATA_WIDTH-1:0] i1_src1_dec,
    output logic [`LA64_DATA_WIDTH-1:0] i1_src2_dec,

    output logic                        i1_rf_we,
    output logic [`LA64_DATA_WIDTH-1:0] i1_rf_waddr,
    output logic [`ALU_OP_WIDTH-1:0]    i1_alu_op,
    output logic                        i1_mul_signed,
    output logic                        i1_mul_low,

    input  logic [`LA64_DATA_WIDTH-1:0] i2_pc,

    output logic [`LA64_DATA_WIDTH-1:0] i2_src1_dec,
    output logic [`LA64_DATA_WIDTH-1:0] i2_src2_dec,

    output logic                        i2_rf_we,
    output logic [`LA64_DATA_WIDTH-1:0] i2_rf_waddr,
    output logic [`ALU_OP_WIDTH-1:0]    i2_alu_op,
    output logic                        i2_mul_signed,
    output logic                        i2_mul_low,

    input  logic                        i1_rf_we_ex1,
    input  logic                        i1_rf_we_ex2,
    input  logic                        i1_rf_we_ex3,
    input  logic                        i1_rf_we_ex4,
    input  logic                        i1_rf_we_wb,

    input  logic [`LA64_ARF_SEL-1:0]    i1_rf_waddr_ex1,
    input  logic [`LA64_ARF_SEL-1:0]    i1_rf_waddr_ex2,
    input  logic [`LA64_ARF_SEL-1:0]    i1_rf_waddr_ex3,
    input  logic [`LA64_ARF_SEL-1:0]    i1_rf_waddr_ex4,
    input  logic [`LA64_ARF_SEL-1:0]    i1_rf_waddr_wb,

    input  logic [`LA64_DATA_WIDTH-1:0] i1_result_ex1,
    input  logic [`LA64_DATA_WIDTH-1:0] i1_result_ex2,
    input  logic [`LA64_DATA_WIDTH-1:0] i1_result_ex3_final,
    input  logic [`LA64_DATA_WIDTH-1:0] i1_result_ex4_final,
    input  logic [`LA64_DATA_WIDTH-1:0] i1_result_wb,

    input  logic                        i2_rf_we_ex1,
    input  logic                        i2_rf_we_ex2,
    input  logic                        i2_rf_we_ex3,
    input  logic                        i2_rf_we_ex4,
    input  logic                        i2_rf_we_wb,

    input  logic [`LA64_ARF_SEL-1:0]    i2_rf_waddr_ex1,
    input  logic [`LA64_ARF_SEL-1:0]    i2_rf_waddr_ex2,
    input  logic [`LA64_ARF_SEL-1:0]    i2_rf_waddr_ex3,
    input  logic [`LA64_ARF_SEL-1:0]    i2_rf_waddr_ex4,
    input  logic [`LA64_ARF_SEL-1:0]    i2_rf_waddr_wb,

    input  logic [`LA64_DATA_WIDTH-1:0] i2_result_ex1,
    input  logic [`LA64_DATA_WIDTH-1:0] i2_result_ex2,
    input  logic [`LA64_DATA_WIDTH-1:0] i2_result_ex3_final,
    input  logic [`LA64_DATA_WIDTH-1:0] i2_result_ex4_final,
    input  logic [`LA64_DATA_WIDTH-1:0] i2_result_wb,

    output logic                        i1_rs1_bypass_en_ex3,
    output logic                        i1_rs2_bypass_en_ex3,
    output logic                        i2_rs1_bypass_en_ex3,
    output logic                        i2_rs2_bypass_en_ex3,

    output logic [`LA64_DATA_WIDTH-1:0] i1_rs1_bypass_data_ex3,
    output logic [`LA64_DATA_WIDTH-1:0] i1_rs2_bypass_data_ex3,
    output logic [`LA64_DATA_WIDTH-1:0] i2_rs1_bypass_data_ex3,
    output logic [`LA64_DATA_WIDTH-1:0] i2_rs2_bypass_data_ex3
);   

    logic [`LA64_DATA_WIDTH-1:0] i1_imm;
    logic                        i1_rf_re1;
    logic                        i1_rf_re2;
    logic [`LA64_ARF_SEL-1:0]    i1_rf_raddr1;
    logic [`LA64_ARF_SEL-1:0]    i1_rf_raddr2; 
    logic                        i1_src1_is_pc;
    logic                        i1_src2_is_imm;
    logic                        i1_src2_is_4;

    logic [`LA64_DATA_WIDTH-1:0] i2_imm;
    logic                        i2_rf_re1;
    logic                        i2_rf_re2;
    logic [`LA64_ARF_SEL-1:0]    i2_rf_raddr1;
    logic [`LA64_ARF_SEL-1:0]    i2_rf_raddr2;
    logic                        i2_src1_is_pc;
    logic                        i2_src2_is_imm;
    logic                        i2_src2_is_4;

    logic [`LA64_DATA_WIDTH-1:0] i1_rf_rdata1;
    logic [`LA64_DATA_WIDTH-1:0] i1_rf_rdata2;
    logic [`LA64_DATA_WIDTH-1:0] i2_rf_rdata1;
    logic [`LA64_DATA_WIDTH-1:0] i2_rf_rdata2;

    dec_decode_ctl u_dec_decode_ctl_1 (
        .inst        (),
        .inst_valid  (),
        .imm         (i1_imm),
        .rf_re1      (i1_rf_re0),
        .rf_re2      (i1_rf_re1),
        .rf_we       (i1_rf_we),
        .rf_raddr1   (i1_rf_raddr1),
        .rf_raddr2   (i1_rf_raddr2),
        .rf_waddr    (i1_rf_waddr),
        .src1_is_pc  (i1_src1_is_pc),
        .src2_is_imm (i1_src2_is_imm),
        .src2_is_4   (i1_src2_is_4),
        .alu_op      (i1_alu_op),
        .mul_signed  (i1_mul_signed),
        .mul_low     (i1_mul_low)
    );

    dec_decode_ctl u_dec_decode_ctl_2 (
        .inst        (),
        .inst_valid  (),
        .imm         (i2_imm),
        .rf_re1      (i2_rf_re0),
        .rf_re2      (i2_rf_re1),
        .rf_we       (i2_rf_we),
        .rf_raddr1   (i2_rf_raddr1),
        .rf_raddr2   (i2_rf_raddr2),
        .rf_waddr    (i2_rf_waddr),
        .src1_is_pc  (i2_src1_is_pc),
        .src2_is_imm (i2_src2_is_imm),
        .src2_is_4   (i2_src2_is_4),
        .alu_op      (i2_alu_op),
        .mul_signed  (i2_mul_signed),
        .mul_low     (i2_mul_low)
    );

    dec_gpr_ctl u_dec_gpr_ctl (
        .*,
        .re0    (i1_rf_re0),
        .re1    (i1_rf_re1),
        .re2    (i2_rf_re0),
        .re3    (i2_rf_re1),
        .raddr0 (i1_rf_raddr1),
        .raddr1 (i1_rf_raddr2),
        .raddr2 (i2_rf_raddr1),
        .raddr3 (i2_rf_raddr2),
        .rd0    (i1_rf_rdata1),
        .rd1    (i1_rf_rdata2),
        .rd2    (i2_rf_rdata1),
        .rd3    (i2_rf_rdata2),
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

    logic [9:0] i1_rs1_bypass_v_dec;
    logic [9:0] i1_rs2_bypass_v_dec;
    logic [9:0] i2_rs1_bypass_v_dec;
    logic [9:0] i2_rs2_bypass_v_dec;

    logic [9:0] i1_rs1_bypass_vp_dec;
    logic [9:0] i1_rs2_bypass_vp_dec;
    logic [9:0] i2_rs1_bypass_vp_dec;
    logic [9:0] i2_rs2_bypass_vp_dec;
    
    logic i1_rs1_bypass_en_dec;
    logic i1_rs2_bypass_en_dec;
    logic i2_rs1_bypass_en_dec;
    logic i2_rs2_bypass_en_dec;

    logic [`LA64_DATA_WIDTH-1:0] i1_rs1_bypass_data_dec;
    logic [`LA64_DATA_WIDTH-1:0] i1_rs2_bypass_data_dec;
    logic [`LA64_DATA_WIDTH-1:0] i2_rs1_bypass_data_dec;
    logic [`LA64_DATA_WIDTH-1:0] i2_rs2_bypass_data_dec;

    assign i1_rs1_bypass_v_dec[0] = i2_rf_we_ex1 & (i1_rf_raddr1 == i2_rf_waddr_ex1);
    assign i1_rs1_bypass_v_dec[1] = i1_rf_we_ex1 & (i1_rf_raddr1 == i1_rf_waddr_ex1);
    assign i1_rs1_bypass_v_dec[2] = i2_rf_we_ex2 & (i1_rf_raddr1 == i2_rf_waddr_ex2);
    assign i1_rs1_bypass_v_dec[3] = i1_rf_we_ex2 & (i1_rf_raddr1 == i1_rf_waddr_ex2);
    assign i1_rs1_bypass_v_dec[4] = i2_rf_we_ex3 & (i1_rf_raddr1 == i2_rf_waddr_ex3);
    assign i1_rs1_bypass_v_dec[5] = i1_rf_we_ex3 & (i1_rf_raddr1 == i1_rf_waddr_ex3);
    assign i1_rs1_bypass_v_dec[6] = i2_rf_we_ex4 & (i1_rf_raddr1 == i2_rf_waddr_ex4);
    assign i1_rs1_bypass_v_dec[7] = i1_rf_we_ex4 & (i1_rf_raddr1 == i1_rf_waddr_ex4);
    assign i1_rs1_bypass_v_dec[8] = i2_rf_we_wb  & (i1_rf_raddr1 == i2_rf_waddr_wb);
    assign i1_rs1_bypass_v_dec[9] = i1_rf_we_wb  & (i1_rf_raddr1 == i1_rf_waddr_wb);

    assign i1_rs2_bypass_v_dec[0] = i2_rf_we_ex1 & (i1_rf_raddr2 == i2_rf_waddr_ex1);
    assign i1_rs2_bypass_v_dec[1] = i1_rf_we_ex1 & (i1_rf_raddr2 == i1_rf_waddr_ex1);
    assign i1_rs2_bypass_v_dec[2] = i2_rf_we_ex2 & (i1_rf_raddr2 == i2_rf_waddr_ex2);
    assign i1_rs2_bypass_v_dec[3] = i1_rf_we_ex2 & (i1_rf_raddr2 == i1_rf_waddr_ex2);
    assign i1_rs2_bypass_v_dec[4] = i2_rf_we_ex3 & (i1_rf_raddr2 == i2_rf_waddr_ex3);
    assign i1_rs2_bypass_v_dec[5] = i1_rf_we_ex3 & (i1_rf_raddr2 == i1_rf_waddr_ex3);
    assign i1_rs2_bypass_v_dec[6] = i2_rf_we_ex4 & (i1_rf_raddr2 == i2_rf_waddr_ex4);
    assign i1_rs2_bypass_v_dec[7] = i1_rf_we_ex4 & (i1_rf_raddr2 == i1_rf_waddr_ex4);
    assign i1_rs2_bypass_v_dec[8] = i2_rf_we_wb  & (i1_rf_raddr2 == i2_rf_waddr_wb);
    assign i1_rs2_bypass_v_dec[9] = i1_rf_we_wb  & (i1_rf_raddr2 == i1_rf_waddr_wb);

    assign i2_rs1_bypass_v_dec[0] = i1_rf_we_ex1 & (i2_rf_raddr1 == i1_rf_waddr_ex1);
    assign i2_rs1_bypass_v_dec[1] = i2_rf_we_ex1 & (i2_rf_raddr1 == i2_rf_waddr_ex1);
    assign i2_rs1_bypass_v_dec[2] = i1_rf_we_ex2 & (i2_rf_raddr1 == i1_rf_waddr_ex2);     
    assign i2_rs1_bypass_v_dec[3] = i2_rf_we_ex2 & (i2_rf_raddr1 == i2_rf_waddr_ex2);
    assign i2_rs1_bypass_v_dec[4] = i1_rf_we_ex3 & (i2_rf_raddr1 == i1_rf_waddr_ex3);
    assign i2_rs1_bypass_v_dec[5] = i2_rf_we_ex3 & (i2_rf_raddr1 == i2_rf_waddr_ex3);
    assign i2_rs1_bypass_v_dec[6] = i1_rf_we_ex4 & (i2_rf_raddr1 == i1_rf_waddr_ex4);
    assign i2_rs1_bypass_v_dec[7] = i2_rf_we_ex4 & (i2_rf_raddr1 == i2_rf_waddr_ex4);
    assign i2_rs1_bypass_v_dec[8] = i1_rf_we_wb  & (i2_rf_raddr1 == i1_rf_waddr_wb);
    assign i2_rs1_bypass_v_dec[9] = i2_rf_we_wb  & (i2_rf_raddr1 == i2_rf_waddr_wb);

    assign i2_rs2_bypass_v_dec[0] = i1_rf_we_ex1 & (i2_rf_raddr2 == i1_rf_waddr_ex1);
    assign i2_rs2_bypass_v_dec[1] = i2_rf_we_ex1 & (i2_rf_raddr2 == i2_rf_waddr_ex1);
    assign i2_rs2_bypass_v_dec[2] = i1_rf_we_ex2 & (i2_rf_raddr2 == i1_rf_waddr_ex2);
    assign i2_rs2_bypass_v_dec[3] = i2_rf_we_ex2 & (i2_rf_raddr2 == i2_rf_waddr_ex2);
    assign i2_rs2_bypass_v_dec[4] = i1_rf_we_ex3 & (i2_rf_raddr2 == i1_rf_waddr_ex3);
    assign i2_rs2_bypass_v_dec[5] = i2_rf_we_ex3 & (i2_rf_raddr2 == i2_rf_waddr_ex3);
    assign i2_rs2_bypass_v_dec[6] = i1_rf_we_ex4 & (i2_rf_raddr2 == i1_rf_waddr_ex4);
    assign i2_rs2_bypass_v_dec[7] = i2_rf_we_ex4 & (i2_rf_raddr2 == i2_rf_waddr_ex4);
    assign i2_rs2_bypass_v_dec[8] = i1_rf_we_wb  & (i2_rf_raddr2 == i1_rf_waddr_wb);
    assign i2_rs2_bypass_v_dec[9] = i2_rf_we_wb  & (i2_rf_raddr2 == i2_rf_waddr_wb);

    assign i1_rs1_bypass_en_dec = |i1_rs1_bypass_v_dec;
    assign i1_rs2_bypass_en_dec = |i1_rs2_bypass_v_dec;  
    assign i2_rs1_bypass_en_dec = |i2_rs1_bypass_v_dec;
    assign i2_rs2_bypass_en_dec = |i2_rs2_bypass_v_dec;

    assign i1_rs1_bypass_vp_dec = i1_rs1_bypass_v_dec[0] ? 10'b0000000001 :
                                  i1_rs1_bypass_v_dec[1] ? 10'b0000000010 :
                                  i1_rs1_bypass_v_dec[2] ? 10'b0000000100 :
                                  i1_rs1_bypass_v_dec[3] ? 10'b0000001000 :
                                  i1_rs1_bypass_v_dec[4] ? 10'b0000010000 :
                                  i1_rs1_bypass_v_dec[5] ? 10'b0000100000 :
                                  i1_rs1_bypass_v_dec[6] ? 10'b0001000000 :
                                  i1_rs1_bypass_v_dec[7] ? 10'b0010000000 :
                                  i1_rs1_bypass_v_dec[8] ? 10'b0100000000 :
                                  i1_rs1_bypass_v_dec[9] ? 10'b1000000000 :
                                  10'b0000000000;

    assign i1_rs2_bypass_vp_dec = i1_rs2_bypass_v_dec[0] ? 10'b0000000001 :
                                  i1_rs2_bypass_v_dec[1] ? 10'b0000000010 :
                                  i1_rs2_bypass_v_dec[2] ? 10'b0000000100 :
                                  i1_rs2_bypass_v_dec[3] ? 10'b0000001000 :
                                  i1_rs2_bypass_v_dec[4] ? 10'b0000010000 :
                                  i1_rs2_bypass_v_dec[5] ? 10'b0000100000 :
                                  i1_rs2_bypass_v_dec[6] ? 10'b0001000000 :
                                  i1_rs2_bypass_v_dec[7] ? 10'b0010000000 :
                                  i1_rs2_bypass_v_dec[8] ? 10'b0100000000 :
                                  i1_rs2_bypass_v_dec[9] ? 10'b1000000000 :
                                  10'b0000000000;

    assign i2_rs1_bypass_vp_dec = i2_rs1_bypass_v_dec[0] ? 10'b0000000001 :
                                  i2_rs1_bypass_v_dec[1] ? 10'b0000000010 :
                                  i2_rs1_bypass_v_dec[2] ? 10'b0000000100 :
                                  i2_rs1_bypass_v_dec[3] ? 10'b0000001000 :
                                  i2_rs1_bypass_v_dec[4] ? 10'b0000010000 :
                                  i2_rs1_bypass_v_dec[5] ? 10'b0000100000 :
                                  i2_rs1_bypass_v_dec[6] ? 10'b0001000000 :
                                  i2_rs1_bypass_v_dec[7] ? 10'b0010000000 :
                                  i2_rs1_bypass_v_dec[8] ? 10'b0100000000 :
                                  i2_rs1_bypass_v_dec[9] ? 10'b1000000000 :
                                  10'b0000000000;

    assign i2_rs2_bypass_vp_dec = i2_rs2_bypass_v_dec[0] ? 10'b0000000001 :
                                  i2_rs2_bypass_v_dec[1] ? 10'b0000000010 :
                                  i2_rs2_bypass_v_dec[2] ? 10'b0000000100 :
                                  i2_rs2_bypass_v_dec[3] ? 10'b0000001000 :
                                  i2_rs2_bypass_v_dec[4] ? 10'b0000010000 :
                                  i2_rs2_bypass_v_dec[5] ? 10'b0000100000 :
                                  i2_rs2_bypass_v_dec[6] ? 10'b0001000000 :
                                  i2_rs2_bypass_v_dec[7] ? 10'b0010000000 :
                                  i2_rs2_bypass_v_dec[8] ? 10'b0100000000 :
                                  i2_rs2_bypass_v_dec[9] ? 10'b1000000000 :
                                  10'b0000000000;

    assign i1_rs1_bypass_data_dec = ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[0]}} & i2_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[1]}} & i1_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[2]}} & i2_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[3]}} & i1_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[4]}} & i2_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[5]}} & i1_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[6]}} & i2_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[7]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[8]}} & i2_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[9]}} & i1_result_wb       );

    assign i1_rs2_bypass_data_dec = ({`LA64_DATA_WIDTH{i1_rs2_bypass_vp_dec[0]}} & i2_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs2_bypass_vp_dec[1]}} & i1_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs2_bypass_vp_dec[2]}} & i2_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs2_bypass_vp_dec[3]}} & i1_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs2_bypass_vp_dec[4]}} & i2_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs2_bypass_vp_dec[5]}} & i1_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs2_bypass_vp_dec[6]}} & i2_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs2_bypass_vp_dec[7]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs2_bypass_vp_dec[8]}} & i2_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i1_rs2_bypass_vp_dec[9]}} & i1_result_wb       );
    
    assign i2_rs1_bypass_data_dec = ({`LA64_DATA_WIDTH{i2_rs1_bypass_vp_dec[0]}} & i1_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i2_rs1_bypass_vp_dec[1]}} & i2_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i2_rs1_bypass_vp_dec[2]}} & i1_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i2_rs1_bypass_vp_dec[3]}} & i2_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i2_rs1_bypass_vp_dec[4]}} & i1_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i2_rs1_bypass_vp_dec[5]}} & i2_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i2_rs1_bypass_vp_dec[6]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i2_rs1_bypass_vp_dec[7]}} & i2_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i2_rs1_bypass_vp_dec[8]}} & i1_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i2_rs1_bypass_vp_dec[9]}} & i2_result_wb       );

    assign i2_rs2_bypass_data_dec = ({`LA64_DATA_WIDTH{i2_rs2_bypass_vp_dec[0]}} & i1_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i2_rs2_bypass_vp_dec[1]}} & i2_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i2_rs2_bypass_vp_dec[2]}} & i1_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i2_rs2_bypass_vp_dec[3]}} & i2_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i2_rs2_bypass_vp_dec[4]}} & i1_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i2_rs2_bypass_vp_dec[5]}} & i2_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i2_rs2_bypass_vp_dec[6]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i2_rs2_bypass_vp_dec[7]}} & i2_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i2_rs2_bypass_vp_dec[8]}} & i1_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i2_rs2_bypass_vp_dec[9]}} & i2_result_wb       );

    assign i1_src1_dec = ({`LA64_DATA_WIDTH{i1_src1_is_pc                      }} & i1_pc                 ) |
                         ({`LA64_DATA_WIDTH{i1_rf_re1 & i1_rs1_bypass_en_dec   }} & i1_rs1_bypass_data_dec) |
                         ({`LA64_DATA_WIDTH{i1_rf_re1 & (~i1_rs1_bypass_en_dec)}} & i1_rf_rdata1          );

    assign i1_src2_dec = ({`LA64_DATA_WIDTH{i1_src2_is_imm                     }} & i1_imm                ) |
                         ({`LA64_DATA_WIDTH{i1_src2_is_4                       }} & ('d4)                 ) |
                         ({`LA64_DATA_WIDTH{i1_rf_re2 & i1_rs2_bypass_en_dec   }} & i1_rs2_bypass_data_dec) |
                         ({`LA64_DATA_WIDTH{i1_rf_re2 & (~i1_rs2_bypass_en_dec)}} & i1_rf_rdata2          );

    assign i2_src1_dec = ({`LA64_DATA_WIDTH{i2_src1_is_pc                      }} & i2_pc                 ) |
                         ({`LA64_DATA_WIDTH{i2_rf_re1 & i2_rs1_bypass_en_dec   }} & i2_rs1_bypass_data_dec) |
                         ({`LA64_DATA_WIDTH{i2_rf_re1 & (~i2_rs1_bypass_en_dec)}} & i2_rf_rdata1          );

    assign i2_src2_dec = ({`LA64_DATA_WIDTH{i2_src2_is_imm                     }} & i2_imm                ) |
                         ({`LA64_DATA_WIDTH{i2_src2_is_4                       }} & ('d4)                 ) |
                         ({`LA64_DATA_WIDTH{i2_rf_re2 & i2_rs2_bypass_en_dec   }} & i2_rs2_bypass_data_dec) |
                         ({`LA64_DATA_WIDTH{i2_rf_re2 & (~i2_rs2_bypass_en_dec)}} & i2_rf_rdata2          );

    logic [3:0] i1_rs1_bypass_v_ex3;
    logic [3:0] i1_rs2_bypass_v_ex3;
    logic [3:0] i2_rs1_bypass_v_ex3;
    logic [3:0] i2_rs2_bypass_v_ex3;

    logic [3:0] i1_rs1_bypass_vp_ex3;
    logic [3:0] i1_rs2_bypass_vp_ex3; 
    logic [3:0] i2_rs1_bypass_vp_ex3;
    logic [3:0] i2_rs2_bypass_vp_ex3;

    assign i1_rs1_bypass_v_ex3[0] = i2_rf_we_ex4 & (i1_rf_raddr1 == i2_rf_waddr_ex4);
    assign i1_rs1_bypass_v_ex3[1] = i1_rf_we_ex4 & (i1_rf_raddr1 == i1_rf_waddr_ex4);
    assign i1_rs1_bypass_v_ex3[2] = i2_rf_we_wb  & (i1_rf_raddr1 == i2_rf_waddr_wb);  
    assign i1_rs1_bypass_v_ex3[3] = i1_rf_we_wb  & (i1_rf_raddr1 == i1_rf_waddr_wb);

    assign i1_rs2_bypass_v_ex3[0] = i2_rf_we_ex4 & (i1_rf_raddr2 == i2_rf_waddr_ex4);
    assign i1_rs2_bypass_v_ex3[1] = i1_rf_we_ex4 & (i1_rf_raddr2 == i1_rf_waddr_ex4);
    assign i1_rs2_bypass_v_ex3[2] = i2_rf_we_wb  & (i1_rf_raddr2 == i2_rf_waddr_wb);
    assign i1_rs2_bypass_v_ex3[3] = i1_rf_we_wb  & (i1_rf_raddr2 == i1_rf_waddr_wb);

    assign i2_rs1_bypass_v_ex3[0] = i1_rf_we_ex4 & (i2_rf_raddr1 == i1_rf_waddr_ex4);
    assign i2_rs1_bypass_v_ex3[1] = i2_rf_we_ex4 & (i2_rf_raddr1 == i2_rf_waddr_ex4);
    assign i2_rs1_bypass_v_ex3[2] = i1_rf_we_wb  & (i2_rf_raddr1 == i1_rf_waddr_wb);
    assign i2_rs1_bypass_v_ex3[3] = i2_rf_we_wb  & (i2_rf_raddr1 == i2_rf_waddr_wb);

    assign i2_rs2_bypass_v_ex3[0] = i1_rf_we_ex4 & (i2_rf_raddr2 == i1_rf_waddr_ex4);
    assign i2_rs2_bypass_v_ex3[1] = i2_rf_we_ex4 & (i2_rf_raddr2 == i2_rf_waddr_ex4);
    assign i2_rs2_bypass_v_ex3[2] = i1_rf_we_wb  & (i2_rf_raddr2 == i1_rf_waddr_wb);
    assign i2_rs2_bypass_v_ex3[3] = i2_rf_we_wb  & (i2_rf_raddr2 == i2_rf_waddr_wb);

    assign i1_rs1_bypass_en_ex3 = |i1_rs1_bypass_v_ex3;
    assign i1_rs2_bypass_en_ex3 = |i1_rs2_bypass_v_ex3;
    assign i2_rs1_bypass_en_ex3 = |i2_rs1_bypass_v_ex3;
    assign i2_rs2_bypass_en_ex3 = |i2_rs2_bypass_v_ex3;

    assign i1_rs1_bypass_vp_ex3 = i1_rs1_bypass_v_ex3[0] ? 4'b0001 :
                                  i1_rs1_bypass_v_ex3[1] ? 4'b0010 :
                                  i1_rs1_bypass_v_ex3[2] ? 4'b0100 :
                                  i1_rs1_bypass_v_ex3[3] ? 4'b1000 :
                                  4'b0000;
    
    assign i1_rs2_bypass_vp_ex3 = i1_rs1_bypass_v_ex3[0] ? 4'b0001 :
                                  i1_rs2_bypass_v_ex3[1] ? 4'b0010 :
                                  i1_rs2_bypass_v_ex3[2] ? 4'b0100 :
                                  i1_rs2_bypass_v_ex3[3] ? 4'b1000 :
                                  4'b0000;
    
    assign i2_rs1_bypass_vp_ex3 = i2_rs1_bypass_v_ex3[0] ? 4'b0001 :
                                  i2_rs1_bypass_v_ex3[1] ? 4'b0010 :
                                  i2_rs1_bypass_v_ex3[2] ? 4'b0100 :
                                  i2_rs1_bypass_v_ex3[3] ? 4'b1000 :
                                  4'b0000;

    assign i2_rs2_bypass_vp_ex3 = i2_rs2_bypass_v_ex3[0] ? 4'b0001 :
                                  i2_rs2_bypass_v_ex3[1] ? 4'b0010 :
                                  i2_rs2_bypass_v_ex3[2] ? 4'b0100 :
                                  i2_rs2_bypass_v_ex3[3] ? 4'b1000 :
                                  4'b0000;

    assign i1_rs1_bypass_data_ex3 = ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_ex3[0]}} & i2_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_ex3[1]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_ex3[2]}} & i2_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_ex3[3]}} & i1_result_wb       );
    
    assign i1_rs2_bypass_data_ex3 = ({`LA64_DATA_WIDTH{i1_rs2_bypass_vp_ex3[0]}} & i2_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs2_bypass_vp_ex3[1]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs2_bypass_vp_ex3[2]}} & i2_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i1_rs2_bypass_vp_ex3[3]}} & i1_result_wb       );

    assign i2_rs1_bypass_data_ex3 = ({`LA64_DATA_WIDTH{i2_rs1_bypass_vp_ex3[0]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i2_rs1_bypass_vp_ex3[1]}} & i2_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i2_rs1_bypass_vp_ex3[2]}} & i1_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i2_rs1_bypass_vp_ex3[3]}} & i2_result_wb       );

    assign i2_rs2_bypass_data_ex3 = ({`LA64_DATA_WIDTH{i2_rs2_bypass_vp_ex3[0]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i2_rs2_bypass_vp_ex3[1]}} & i2_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i2_rs2_bypass_vp_ex3[2]}} & i1_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i2_rs2_bypass_vp_ex3[3]}} & i2_result_wb       );

endmodule