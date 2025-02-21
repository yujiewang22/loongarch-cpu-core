`include "../include/constants.vh"

module deu (
    input  logic                        clk,              
    input  logic                        rst_n,

    // Shakehand with ifu
    output logic                        deu_ib2_val,
    output logic                        deu_ib3_val,
    input  logic                        ifu_i0_valid,                
    input  logic [`LA64_PC_WIDTH-1:0]   ifu_i0_pc,
    input  logic [`LA64_INST_WIDTH-1:0] ifu_i0_inst, 
    input  logic                        ifu_i1_valid,
    input  logic [`LA64_PC_WIDTH-1:0]   ifu_i1_pc,          
    input  logic [`LA64_INST_WIDTH-1:0] ifu_i1_inst,
    
    // Output src
    output logic [`LA64_DATA_WIDTH-1:0] i0_src0_final,
    output logic [`LA64_DATA_WIDTH-1:0] i0_src1_final,
    output logic [`LA64_DATA_WIDTH-1:0] i1_src0_final,
    output logic [`LA64_DATA_WIDTH-1:0] i1_src1_final,

    // Bypassing to deu
    input  logic                        i0_rf_we_ex1,
    input  logic                        i0_rf_we_ex2,
    input  logic                        i0_rf_we_ex3,
    input  logic                        i0_rf_we_ex4,
    input  logic                        i0_rf_we_wb,

    input  logic [`LA64_ARF_SEL-1:0]    i0_rf_waddr_ex1,
    input  logic [`LA64_ARF_SEL-1:0]    i0_rf_waddr_ex2,
    input  logic [`LA64_ARF_SEL-1:0]    i0_rf_waddr_ex3,
    input  logic [`LA64_ARF_SEL-1:0]    i0_rf_waddr_ex4,
    input  logic [`LA64_ARF_SEL-1:0]    i0_rf_waddr_wb,

    input  logic [`LA64_DATA_WIDTH-1:0] i0_result_ex1,
    input  logic [`LA64_DATA_WIDTH-1:0] i0_result_ex2,
    input  logic [`LA64_DATA_WIDTH-1:0] i0_result_ex3_final,
    input  logic [`LA64_DATA_WIDTH-1:0] i0_result_ex4_final,
    input  logic [`LA64_DATA_WIDTH-1:0] i0_result_wb,

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

    // Bypassing to ex3
    output logic                        i0_rs0_bypass_en_ex3,
    output logic                        i0_rs1_bypass_en_ex3,
    output logic                        i1_rs0_bypass_en_ex3,
    output logic                        i1_rs1_bypass_en_ex3,

    output logic [`LA64_DATA_WIDTH-1:0] i0_rs0_bypass_data_ex3,
    output logic [`LA64_DATA_WIDTH-1:0] i0_rs1_bypass_data_ex3,
    output logic [`LA64_DATA_WIDTH-1:0] i1_rs0_bypass_data_ex3,
    output logic [`LA64_DATA_WIDTH-1:0] i1_rs1_bypass_data_ex3
);   

    logic                        deu_ib0_val;
    logic                        deu_ib1_val;
    logic                        deu_i0_decode; 
    logic [`LA64_PC_WIDTH-1:0]   i0_pc;
    logic [`LA64_INST_WIDTH-1:0] i0_inst;
    logic                        deu_i1_decode;
    logic [`LA64_PC_WIDTH-1:0]   i1_pc;
    logic [`LA64_INST_WIDTH-1:0] i1_inst; 

    assign deu_i0_decode = deu_ib0_val;
    assign deu_i1_decode = deu_ib1_val;

    deu_ib_ctl u_deu_ib_ctl (
        .*,
        .ifu_i0_valid  (ifu_i0_valid),
        .ifu_i0_pc     (ifu_i0_pc),
        .ifu_i0_inst   (ifu_i0_inst),
        .ifu_i1_valid  (ifu_i1_valid),
        .ifu_i1_pc     (ifu_i1_pc),
        .ifu_i1_inst   (ifu_i1_inst),
        .deu_ib0_val   (deu_ib0_val),
        .deu_ib1_val   (deu_ib1_val),
        .deu_ib2_val   (deu_ib2_val),
        .deu_ib3_val   (deu_ib3_val),
        .deu_i0_decode (deu_i0_decode),
        .deu_i0_pc     (i0_pc),
        .deu_i0_inst   (i0_inst),
        .deu_i1_decode (deu_i1_decode),
        .deu_i1_pc     (i1_pc),
        .deu_i1_inst   (i1_inst)
    );     

    logic [`LA64_DATA_WIDTH-1:0] i0_imm;

    logic                        i0_rf_re0;
    logic                        i0_rf_re1;
    logic [`LA64_DATA_WIDTH-1:0] i0_rf_raddr0;
    logic [`LA64_DATA_WIDTH-1:0] i0_rf_raddr1;

    logic                        i0_src0_is_pc;
    logic                        i0_src1_is_imm;
    logic                        i0_src1_is_4;

    logic [`LA64_DATA_WIDTH-1:0] i1_imm;

    logic                        i1_rf_re0;
    logic                        i1_rf_re1;
    logic [`LA64_DATA_WIDTH-1:0] i1_rf_raddr0;
    logic [`LA64_DATA_WIDTH-1:0] i1_rf_raddr1;

    logic                        i1_src0_is_pc;
    logic                        i1_src1_is_imm;
    logic                        i1_src1_is_4;

    logic [`LA64_DATA_WIDTH-1:0] i0_rf_rdata0;
    logic [`LA64_DATA_WIDTH-1:0] i0_rf_rdata1;
    logic [`LA64_DATA_WIDTH-1:0] i1_rf_rdata0;
    logic [`LA64_DATA_WIDTH-1:0] i1_rf_rdata1;

    // Bypassing to deu
    logic [9:0] i0_rs0_bypass_v_dec;
    logic [9:0] i0_rs1_bypass_v_dec;
    logic [9:0] i1_rs0_bypass_v_dec;
    logic [9:0] i1_rs1_bypass_v_dec;

    logic [9:0] i0_rs0_bypass_vp_dec;
    logic [9:0] i0_rs1_bypass_vp_dec;
    logic [9:0] i1_rs0_bypass_vp_dec;
    logic [9:0] i1_rs1_bypass_vp_dec;
    
    logic i0_rs0_bypass_en_dec;
    logic i0_rs1_bypass_en_dec;
    logic i1_rs0_bypass_en_dec;
    logic i1_rs1_bypass_en_dec;

    logic [`LA64_DATA_WIDTH-1:0] i0_rs0_bypass_data_dec;
    logic [`LA64_DATA_WIDTH-1:0] i0_rs1_bypass_data_dec;
    logic [`LA64_DATA_WIDTH-1:0] i1_rs0_bypass_data_dec;
    logic [`LA64_DATA_WIDTH-1:0] i1_rs1_bypass_data_dec;

    assign i0_rs0_bypass_v_dec[0] = i1_rf_we_ex1 & (i0_rf_raddr0 == i1_rf_waddr_ex1);
    assign i0_rs0_bypass_v_dec[1] = i0_rf_we_ex1 & (i0_rf_raddr0 == i0_rf_waddr_ex1);
    assign i0_rs0_bypass_v_dec[2] = i1_rf_we_ex2 & (i0_rf_raddr0 == i1_rf_waddr_ex2);
    assign i0_rs0_bypass_v_dec[3] = i0_rf_we_ex2 & (i0_rf_raddr0 == i0_rf_waddr_ex2);
    assign i0_rs0_bypass_v_dec[4] = i1_rf_we_ex3 & (i0_rf_raddr0 == i1_rf_waddr_ex3);
    assign i0_rs0_bypass_v_dec[5] = i0_rf_we_ex3 & (i0_rf_raddr0 == i0_rf_waddr_ex3);
    assign i0_rs0_bypass_v_dec[6] = i1_rf_we_ex4 & (i0_rf_raddr0 == i1_rf_waddr_ex4);
    assign i0_rs0_bypass_v_dec[7] = i0_rf_we_ex4 & (i0_rf_raddr0 == i0_rf_waddr_ex4);
    assign i0_rs0_bypass_v_dec[8] = i1_rf_we_wb  & (i0_rf_raddr0 == i1_rf_waddr_wb);
    assign i0_rs0_bypass_v_dec[9] = i0_rf_we_wb  & (i0_rf_raddr0 == i0_rf_waddr_wb);

    assign i0_rs1_bypass_v_dec[0] = i1_rf_we_ex1 & (i0_rf_raddr1 == i1_rf_waddr_ex1);
    assign i0_rs1_bypass_v_dec[1] = i0_rf_we_ex1 & (i0_rf_raddr1 == i0_rf_waddr_ex1);
    assign i0_rs1_bypass_v_dec[2] = i1_rf_we_ex2 & (i0_rf_raddr1 == i1_rf_waddr_ex2);
    assign i0_rs1_bypass_v_dec[3] = i0_rf_we_ex2 & (i0_rf_raddr1 == i0_rf_waddr_ex2);
    assign i0_rs1_bypass_v_dec[4] = i1_rf_we_ex3 & (i0_rf_raddr1 == i1_rf_waddr_ex3);
    assign i0_rs1_bypass_v_dec[5] = i0_rf_we_ex3 & (i0_rf_raddr1 == i0_rf_waddr_ex3);
    assign i0_rs1_bypass_v_dec[6] = i1_rf_we_ex4 & (i0_rf_raddr1 == i1_rf_waddr_ex4);
    assign i0_rs1_bypass_v_dec[7] = i0_rf_we_ex4 & (i0_rf_raddr1 == i0_rf_waddr_ex4);
    assign i0_rs1_bypass_v_dec[8] = i1_rf_we_wb  & (i0_rf_raddr1 == i1_rf_waddr_wb);
    assign i0_rs1_bypass_v_dec[9] = i0_rf_we_wb  & (i0_rf_raddr1 == i0_rf_waddr_wb);

    assign i1_rs0_bypass_v_dec[0] = i0_rf_we_ex1 & (i1_rf_raddr0 == i0_rf_waddr_ex1);
    assign i1_rs0_bypass_v_dec[1] = i1_rf_we_ex1 & (i1_rf_raddr0 == i1_rf_waddr_ex1);
    assign i1_rs0_bypass_v_dec[2] = i0_rf_we_ex2 & (i1_rf_raddr0 == i0_rf_waddr_ex2);     
    assign i1_rs0_bypass_v_dec[3] = i1_rf_we_ex2 & (i1_rf_raddr0 == i1_rf_waddr_ex2);
    assign i1_rs0_bypass_v_dec[4] = i0_rf_we_ex3 & (i1_rf_raddr0 == i0_rf_waddr_ex3);
    assign i1_rs0_bypass_v_dec[5] = i1_rf_we_ex3 & (i1_rf_raddr0 == i1_rf_waddr_ex3);
    assign i1_rs0_bypass_v_dec[6] = i0_rf_we_ex4 & (i1_rf_raddr0 == i0_rf_waddr_ex4);
    assign i1_rs0_bypass_v_dec[7] = i1_rf_we_ex4 & (i1_rf_raddr0 == i1_rf_waddr_ex4);
    assign i1_rs0_bypass_v_dec[8] = i0_rf_we_wb  & (i1_rf_raddr0 == i0_rf_waddr_wb);
    assign i1_rs0_bypass_v_dec[9] = i1_rf_we_wb  & (i1_rf_raddr0 == i1_rf_waddr_wb);

    assign i1_rs1_bypass_v_dec[0] = i0_rf_we_ex1 & (i1_rf_raddr1 == i0_rf_waddr_ex1);
    assign i1_rs1_bypass_v_dec[1] = i1_rf_we_ex1 & (i1_rf_raddr1 == i1_rf_waddr_ex1);
    assign i1_rs1_bypass_v_dec[2] = i0_rf_we_ex2 & (i1_rf_raddr1 == i0_rf_waddr_ex2);
    assign i1_rs1_bypass_v_dec[3] = i1_rf_we_ex2 & (i1_rf_raddr1 == i1_rf_waddr_ex2);
    assign i1_rs1_bypass_v_dec[4] = i0_rf_we_ex3 & (i1_rf_raddr1 == i0_rf_waddr_ex3);
    assign i1_rs1_bypass_v_dec[5] = i1_rf_we_ex3 & (i1_rf_raddr1 == i1_rf_waddr_ex3);
    assign i1_rs1_bypass_v_dec[6] = i0_rf_we_ex4 & (i1_rf_raddr1 == i0_rf_waddr_ex4);
    assign i1_rs1_bypass_v_dec[7] = i1_rf_we_ex4 & (i1_rf_raddr1 == i1_rf_waddr_ex4);
    assign i1_rs1_bypass_v_dec[8] = i0_rf_we_wb  & (i1_rf_raddr1 == i0_rf_waddr_wb);
    assign i1_rs1_bypass_v_dec[9] = i1_rf_we_wb  & (i1_rf_raddr1 == i1_rf_waddr_wb);

    assign i0_rs0_bypass_en_dec = |i0_rs0_bypass_v_dec;
    assign i0_rs1_bypass_en_dec = |i0_rs1_bypass_v_dec;  
    assign i1_rs0_bypass_en_dec = |i1_rs0_bypass_v_dec;
    assign i1_rs1_bypass_en_dec = |i1_rs1_bypass_v_dec;

    assign i0_rs0_bypass_vp_dec = i0_rs0_bypass_v_dec[0] ? 10'b0000000001 :
                                  i0_rs0_bypass_v_dec[1] ? 10'b0000000010 :
                                  i0_rs0_bypass_v_dec[2] ? 10'b0000000100 :
                                  i0_rs0_bypass_v_dec[3] ? 10'b0000001000 :
                                  i0_rs0_bypass_v_dec[4] ? 10'b0000010000 :
                                  i0_rs0_bypass_v_dec[5] ? 10'b0000100000 :
                                  i0_rs0_bypass_v_dec[6] ? 10'b0001000000 :
                                  i0_rs0_bypass_v_dec[7] ? 10'b0010000000 :
                                  i0_rs0_bypass_v_dec[8] ? 10'b0100000000 :
                                  i0_rs0_bypass_v_dec[9] ? 10'b1000000000 :
                                  10'b0000000000;

    assign i0_rs1_bypass_vp_dec = i0_rs1_bypass_v_dec[0] ? 10'b0000000001 :
                                  i0_rs1_bypass_v_dec[1] ? 10'b0000000010 :
                                  i0_rs1_bypass_v_dec[2] ? 10'b0000000100 :
                                  i0_rs1_bypass_v_dec[3] ? 10'b0000001000 :
                                  i0_rs1_bypass_v_dec[4] ? 10'b0000010000 :
                                  i0_rs1_bypass_v_dec[5] ? 10'b0000100000 :
                                  i0_rs1_bypass_v_dec[6] ? 10'b0001000000 :
                                  i0_rs1_bypass_v_dec[7] ? 10'b0010000000 :
                                  i0_rs1_bypass_v_dec[8] ? 10'b0100000000 :
                                  i0_rs1_bypass_v_dec[9] ? 10'b1000000000 :
                                  10'b0000000000;

    assign i1_rs0_bypass_vp_dec = i1_rs0_bypass_v_dec[0] ? 10'b0000000001 :
                                  i1_rs0_bypass_v_dec[1] ? 10'b0000000010 :
                                  i1_rs0_bypass_v_dec[2] ? 10'b0000000100 :
                                  i1_rs0_bypass_v_dec[3] ? 10'b0000001000 :
                                  i1_rs0_bypass_v_dec[4] ? 10'b0000010000 :
                                  i1_rs0_bypass_v_dec[5] ? 10'b0000100000 :
                                  i1_rs0_bypass_v_dec[6] ? 10'b0001000000 :
                                  i1_rs0_bypass_v_dec[7] ? 10'b0010000000 :
                                  i1_rs0_bypass_v_dec[8] ? 10'b0100000000 :
                                  i1_rs0_bypass_v_dec[9] ? 10'b1000000000 :
                                  10'b0000000000;

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

    assign i0_rs0_bypass_data_dec = ({`LA64_DATA_WIDTH{i0_rs0_bypass_vp_dec[0]}} & i1_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i0_rs0_bypass_vp_dec[1]}} & i0_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i0_rs0_bypass_vp_dec[2]}} & i1_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i0_rs0_bypass_vp_dec[3]}} & i0_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i0_rs0_bypass_vp_dec[4]}} & i1_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i0_rs0_bypass_vp_dec[5]}} & i0_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i0_rs0_bypass_vp_dec[6]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i0_rs0_bypass_vp_dec[7]}} & i0_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i0_rs0_bypass_vp_dec[8]}} & i1_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i0_rs0_bypass_vp_dec[9]}} & i0_result_wb       );

    assign i0_rs1_bypass_data_dec = ({`LA64_DATA_WIDTH{i0_rs1_bypass_vp_dec[0]}} & i1_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i0_rs1_bypass_vp_dec[1]}} & i0_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i0_rs1_bypass_vp_dec[2]}} & i1_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i0_rs1_bypass_vp_dec[3]}} & i0_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i0_rs1_bypass_vp_dec[4]}} & i1_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i0_rs1_bypass_vp_dec[5]}} & i0_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i0_rs1_bypass_vp_dec[6]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i0_rs1_bypass_vp_dec[7]}} & i0_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i0_rs1_bypass_vp_dec[8]}} & i1_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i0_rs1_bypass_vp_dec[9]}} & i0_result_wb       );
    
    assign i1_rs0_bypass_data_dec = ({`LA64_DATA_WIDTH{i1_rs0_bypass_vp_dec[0]}} & i0_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs0_bypass_vp_dec[1]}} & i1_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs0_bypass_vp_dec[2]}} & i0_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs0_bypass_vp_dec[3]}} & i1_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs0_bypass_vp_dec[4]}} & i0_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs0_bypass_vp_dec[5]}} & i1_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs0_bypass_vp_dec[6]}} & i0_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs0_bypass_vp_dec[7]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs0_bypass_vp_dec[8]}} & i0_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i1_rs0_bypass_vp_dec[9]}} & i1_result_wb       );

    assign i1_rs1_bypass_data_dec = ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[0]}} & i0_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[1]}} & i1_result_ex1      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[2]}} & i0_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[3]}} & i1_result_ex2      ) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[4]}} & i0_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[5]}} & i1_result_ex3_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[6]}} & i0_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[7]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[8]}} & i0_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_dec[9]}} & i1_result_wb       );

    // Bypassing to deu mux
    assign i0_src0_final = ({`LA64_DATA_WIDTH{i0_src0_is_pc                    }} & i0_pc                 ) |
                           ({`LA64_DATA_WIDTH{i0_rf_re0 &  i0_rs0_bypass_en_dec}} & i0_rs0_bypass_data_dec) |
                           ({`LA64_DATA_WIDTH{i0_rf_re0 & ~i0_rs0_bypass_en_dec}} & i0_rf_rdata0          );

    assign i0_src1_final = ({`LA64_DATA_WIDTH{i0_src1_is_imm                   }} & i0_imm                ) |
                           ({`LA64_DATA_WIDTH{i0_src1_is_4                     }} & ('d4)                 ) |
                           ({`LA64_DATA_WIDTH{i0_rf_re1 &  i0_rs1_bypass_en_dec}} & i0_rs1_bypass_data_dec) |
                           ({`LA64_DATA_WIDTH{i0_rf_re1 & ~i0_rs1_bypass_en_dec}} & i0_rf_rdata1          );

    assign i1_src0_final = ({`LA64_DATA_WIDTH{i1_src0_is_pc                    }} & i1_pc                 ) |
                           ({`LA64_DATA_WIDTH{i1_rf_re0 &  i1_rs0_bypass_en_dec}} & i1_rs0_bypass_data_dec) |
                           ({`LA64_DATA_WIDTH{i1_rf_re0 & ~i1_rs0_bypass_en_dec}} & i1_rf_rdata0          );

    assign i1_src1_final = ({`LA64_DATA_WIDTH{i1_src1_is_imm                   }} & i1_imm                ) |
                           ({`LA64_DATA_WIDTH{i1_src1_is_4                     }} & ('d4)                 ) |
                           ({`LA64_DATA_WIDTH{i1_rf_re1 &  i1_rs1_bypass_en_dec}} & i1_rs1_bypass_data_dec) |
                           ({`LA64_DATA_WIDTH{i1_rf_re1 & ~i1_rs1_bypass_en_dec}} & i1_rf_rdata1          );

    // Bypassing to ex3
    logic [3:0] i0_rs0_bypass_v_ex3;
    logic [3:0] i0_rs1_bypass_v_ex3;
    logic [3:0] i1_rs0_bypass_v_ex3;
    logic [3:0] i1_rs1_bypass_v_ex3;

    logic [3:0] i0_rs0_bypass_vp_ex3;
    logic [3:0] i0_rs1_bypass_vp_ex3; 
    logic [3:0] i1_rs0_bypass_vp_ex3;
    logic [3:0] i1_rs1_bypass_vp_ex3;

    assign i0_rs0_bypass_v_ex3[0] = i1_rf_we_ex4 & (i0_rf_raddr0 == i1_rf_waddr_ex4);
    assign i0_rs0_bypass_v_ex3[1] = i0_rf_we_ex4 & (i0_rf_raddr0 == i0_rf_waddr_ex4);
    assign i0_rs0_bypass_v_ex3[2] = i1_rf_we_wb  & (i0_rf_raddr0 == i1_rf_waddr_wb);  
    assign i0_rs0_bypass_v_ex3[3] = i0_rf_we_wb  & (i0_rf_raddr0 == i0_rf_waddr_wb);

    assign i0_rs1_bypass_v_ex3[0] = i1_rf_we_ex4 & (i0_rf_raddr1 == i1_rf_waddr_ex4);
    assign i0_rs1_bypass_v_ex3[1] = i0_rf_we_ex4 & (i0_rf_raddr1 == i0_rf_waddr_ex4);
    assign i0_rs1_bypass_v_ex3[2] = i1_rf_we_wb  & (i0_rf_raddr1 == i1_rf_waddr_wb);
    assign i0_rs1_bypass_v_ex3[3] = i0_rf_we_wb  & (i0_rf_raddr1 == i0_rf_waddr_wb);

    assign i1_rs0_bypass_v_ex3[0] = i1_rf_we_ex4 & (i1_rf_raddr0 == i1_rf_waddr_ex4);
    assign i1_rs0_bypass_v_ex3[1] = i0_rf_we_ex4 & (i1_rf_raddr0 == i0_rf_waddr_ex4);
    assign i1_rs0_bypass_v_ex3[2] = i1_rf_we_wb  & (i1_rf_raddr0 == i1_rf_waddr_wb);
    assign i1_rs0_bypass_v_ex3[3] = i0_rf_we_wb  & (i1_rf_raddr0 == i0_rf_waddr_wb);

    assign i1_rs1_bypass_v_ex3[0] = i1_rf_we_ex4 & (i1_rf_raddr1 == i1_rf_waddr_ex4);
    assign i1_rs1_bypass_v_ex3[1] = i0_rf_we_ex4 & (i1_rf_raddr1 == i0_rf_waddr_ex4);
    assign i1_rs1_bypass_v_ex3[2] = i1_rf_we_wb  & (i1_rf_raddr1 == i1_rf_waddr_wb);
    assign i1_rs1_bypass_v_ex3[3] = i0_rf_we_wb  & (i1_rf_raddr1 == i0_rf_waddr_wb);

    assign i0_rs0_bypass_en_ex3 = |i0_rs0_bypass_v_ex3;
    assign i0_rs1_bypass_en_ex3 = |i0_rs1_bypass_v_ex3;
    assign i1_rs0_bypass_en_ex3 = |i1_rs0_bypass_v_ex3;
    assign i1_rs1_bypass_en_ex3 = |i1_rs1_bypass_v_ex3;

    assign i0_rs0_bypass_vp_ex3 = i0_rs0_bypass_v_ex3[0] ? 4'b0001 :
                                  i0_rs0_bypass_v_ex3[1] ? 4'b0010 :
                                  i0_rs0_bypass_v_ex3[2] ? 4'b0100 :
                                  i0_rs0_bypass_v_ex3[3] ? 4'b1000 :
                                  4'b0000;
    
    assign i0_rs1_bypass_vp_ex3 = i0_rs0_bypass_v_ex3[0] ? 4'b0001 :
                                  i0_rs1_bypass_v_ex3[1] ? 4'b0010 :
                                  i0_rs1_bypass_v_ex3[2] ? 4'b0100 :
                                  i0_rs1_bypass_v_ex3[3] ? 4'b1000 :
                                  4'b0000;
    
    assign i1_rs0_bypass_vp_ex3 = i1_rs0_bypass_v_ex3[0] ? 4'b0001 :
                                  i1_rs0_bypass_v_ex3[1] ? 4'b0010 :
                                  i1_rs0_bypass_v_ex3[2] ? 4'b0100 :
                                  i1_rs0_bypass_v_ex3[3] ? 4'b1000 :
                                  4'b0000;

    assign i1_rs1_bypass_vp_ex3 = i1_rs1_bypass_v_ex3[0] ? 4'b0001 :
                                  i1_rs1_bypass_v_ex3[1] ? 4'b0010 :
                                  i1_rs1_bypass_v_ex3[2] ? 4'b0100 :
                                  i1_rs1_bypass_v_ex3[3] ? 4'b1000 :
                                  4'b0000;

    assign i0_rs0_bypass_data_ex3 = ({`LA64_DATA_WIDTH{i0_rs0_bypass_vp_ex3[0]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i0_rs0_bypass_vp_ex3[1]}} & i0_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i0_rs0_bypass_vp_ex3[2]}} & i1_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i0_rs0_bypass_vp_ex3[3]}} & i0_result_wb       );
    
    assign i0_rs1_bypass_data_ex3 = ({`LA64_DATA_WIDTH{i0_rs1_bypass_vp_ex3[0]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i0_rs1_bypass_vp_ex3[1]}} & i0_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i0_rs1_bypass_vp_ex3[2]}} & i1_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i0_rs1_bypass_vp_ex3[3]}} & i0_result_wb       );

    assign i1_rs0_bypass_data_ex3 = ({`LA64_DATA_WIDTH{i1_rs0_bypass_vp_ex3[0]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs0_bypass_vp_ex3[1]}} & i0_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs0_bypass_vp_ex3[2]}} & i1_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i1_rs0_bypass_vp_ex3[3]}} & i0_result_wb       );

    assign i1_rs1_bypass_data_ex3 = ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_ex3[0]}} & i1_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_ex3[1]}} & i0_result_ex4_final) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_ex3[2]}} & i1_result_wb       ) |
                                    ({`LA64_DATA_WIDTH{i1_rs1_bypass_vp_ex3[3]}} & i0_result_wb       );

endmodule