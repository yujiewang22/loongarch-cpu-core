`default_nettype none
`include "constants.vh"

module pipeline (
    input  wire clk,
    input  wire rst_n
);

    // ******************************************************************* //
    //                              Signals                                //
    // ******************************************************************* //

    // ---------------------------------------------------- //
    // --------------------- Control ---------------------- //
    // ---------------------------------------------------- // 

    // ---------------------------------------------------- //
    // ---------------------- Fetch1 ---------------------- //
    // ---------------------------------------------------- // 

    // ---------------------------------------------------- //
    // ---------------------- Fetch2 ---------------------- //
    // ---------------------------------------------------- // 

    // ---------------------------------------------------- //
    // ---------------------- Align ----------------------- //
    // ---------------------------------------------------- // 

    wire [`LA64_INST_WIDTH-1:0] i1_inst_ali;
    wire [`LA64_INST_WIDTH-1:0] i2_inst_ali;

    // ---------------------------------------------------- //
    // ---------------------- Decode ---------------------- //
    // ---------------------------------------------------- // 

    // i1
    wire [`LA64_INST_WIDTH-1:0] i1_inst_id;
    wire                        i1_rj_re_id;
    wire                        i1_rk_re_id;
    wire                        i1_rd_we_id;
    wire [`LA64_ARF_SEL-1:0]    i1_rj_raddr_id;
    wire [`LA64_ARF_SEL-1:0]    i1_rk_raddr_id;
    wire [`LA64_ARF_SEL-1:0]    i1_rd_waddr_id;
    wire [`ALU_OP_WIDTH-1:0]    i1_alu_op_id;

    wire [`LA64_DATA_WIDTH-1:0] i1_rj_rdata_id;
    wire [`LA64_DATA_WIDTH-1:0] i1_rk_rdata_id;
    wire                        i1_rj_rdata_bypass_vld_id;
    wire                        i1_rk_rdata_bypass_vld_id;
    wire [`LA64_DATA_WIDTH-1:0] i1_rj_rdata_bypass_id;
    wire [`LA64_DATA_WIDTH-1:0] i1_rk_rdata_bypass_id;

    // i2
    wire [`LA64_INST_WIDTH-1:0] i2_inst_id;
    wire                        i2_rj_re_id;
    wire                        i2_rk_re_id;
    wire                        i2_rd_we_id;
    wire [`LA64_ARF_SEL-1:0]    i2_rj_raddr_id;
    wire [`LA64_ARF_SEL-1:0]    i2_rk_raddr_id;
    wire [`LA64_ARF_SEL-1:0]    i2_rd_waddr_id;
    wire [`ALU_OP_WIDTH-1:0]    i2_alu_op_id;

    wire [`LA64_DATA_WIDTH-1:0] i2_rj_rdata_id;
    wire [`LA64_DATA_WIDTH-1:0] i2_rk_rdata_id; 
    wire                        i2_rj_rdata_bypass_vld_id;
    wire                        i2_rk_rdata_bypass_vld_id;
    wire [`LA64_DATA_WIDTH-1:0] i2_rj_rdata_bypass_id;
    wire [`LA64_DATA_WIDTH-1:0] i2_rk_rdata_bypass_id;

    // ---------------------------------------------------- //
    // ----------------------- EX1 ------------------------ //
    // ---------------------------------------------------- // 

    // i1
    wire                        i1_rd_we_ex1;
    wire [`LA64_ARF_SEL-1:0]    i1_rd_waddr_ex1;

    wire [`ALU_OP_WIDTH-1:0]    i1_alu_op_ex1;
    wire [`LA64_DATA_WIDTH-1:0] i1_result_ex1;

    // i2
    wire                        i2_rd_we_ex1;
    wire [`LA64_ARF_SEL-1:0]    i2_rd_waddr_ex1;

    wire [`ALU_OP_WIDTH-1:0]    i2_alu_op_ex1;
    wire [`LA64_DATA_WIDTH-1:0] i2_result_ex1;

    // ---------------------------------------------------- //
    // ----------------------- EX2 ------------------------ //
    // ---------------------------------------------------- // 

    // i1
    wire                        i1_rd_we_ex2;
    wire [`LA64_ARF_SEL-1:0]    i1_rd_waddr_ex2;
    wire [`LA64_DATA_WIDTH-1:0] i1_result_ex2;

    // i2
    wire                        i2_rd_we_ex2;
    wire [`LA64_ARF_SEL-1:0]    i2_rd_waddr_ex2;
    wire [`LA64_DATA_WIDTH-1:0] i2_result_ex2;

    // ---------------------------------------------------- //
    // ----------------------- EX3 ------------------------ //
    // ---------------------------------------------------- // 

    // i1
    wire                        i1_rd_we_ex3;
    wire [`LA64_ARF_SEL-1:0]    i1_rd_waddr_ex3;
    wire [`LA64_DATA_WIDTH-1:0] i1_result_ex3_final;
    // i2
    wire                        i2_rd_we_ex3;
    wire [`LA64_ARF_SEL-1:0]    i2_rd_waddr_ex3;
    wire [`LA64_DATA_WIDTH-1:0] i2_result_ex3_final;

    // ---------------------------------------------------- //
    // ---------------------- Commit ---------------------- //
    // ---------------------------------------------------- // 

    // i1
    wire                        i1_rd_we_ex4;
    wire [`LA64_ARF_SEL-1:0]    i1_rd_waddr_ex4;
    wire [`LA64_DATA_WIDTH-1:0] i1_result_ex4_final;

    // i2
    wire                        i2_rd_we_ex4;
    wire [`LA64_ARF_SEL-1:0]    i2_rd_waddr_ex4;
    wire [`LA64_DATA_WIDTH-1:0] i2_result_ex4_final;

    // ---------------------------------------------------- //
    // --------------------- Writeback -------------------- //
    // ---------------------------------------------------- // 

    // i1
    wire                        i1_rd_we_wb;
    wire [`LA64_ARF_SEL-1:0]    i1_rd_waddr_wb;
    wire [`LA64_DATA_WIDTH-1:0] i1_result_wb;

    // i2
    wire                        i2_rd_we_wb;
    wire [`LA64_ARF_SEL-1:0]    i2_rd_waddr_wb;
    wire [`LA64_DATA_WIDTH-1:0] i2_result_wb; 

    // ******************************************************************* //
    //                           Instantiations                            //
    // ******************************************************************* //

    // ---------------------------------------------------- //
    // --------------------- Control ---------------------- //
    // ---------------------------------------------------- // 

    // ---------------------------------------------------- //
    // ---------------------- Fetch1 ---------------------- //
    // ---------------------------------------------------- // 

    pc_reg u_pc_reg (
        .clk   (clk),
        .rst_n (rst_n),
        .o_pc  ()
    );

    // ---------------------------------------------------- //
    // ---------------------- Fetch2 ---------------------- //
    // ---------------------------------------------------- // 



    // ---------------------------------------------------- //
    // ---------------------- Align ----------------------- //
    // ---------------------------------------------------- // 



    // ---------------------------------------------------- //
    // ---------------------- Decode ---------------------- //
    // ---------------------------------------------------- // 

    dff #(DATA_WIDTH(`LA64_INST_WIDTH)) u_dff_i1_inst_id (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i1_inst_ali), .o_dout(i1_inst_id));
    dff #(DATA_WIDTH(`LA64_INST_WIDTH)) u_dff_i2_inst_id (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i2_inst_ali), .o_dout(i2_inst_id));

    decoder u_decoder_1 (
        .i_inst     (i1_inst_id),
        .o_inst_vld (),
        .o_rj_re    (i1_rj_re_id),
        .o_rk_re    (i1_rk_re_id),
        .o_rd_we    (i1_rd_we_id),
        .o_rj_raddr (i1_rj_raddr_id),
        .o_rk_raddr (i1_rk_raddr_id),
        .o_rd_waddr (i1_rd_waddr_id),
        .o_alu_op   (i1_alu_op_id)
    );

    decoder u_decoder_2 (
        .i_inst     (i2_inst_id),
        .o_inst_vld (),
        .o_rj_re    (i2_rj_re_id),
        .o_rk_re    (i2_rk_re_id),
        .o_rd_we    (i2_rd_we_id),
        .o_rj_raddr (i2_rj_raddr_id),
        .o_rk_raddr (i2_rk_raddr_id),
        .o_rd_waddr (i2_rd_waddr_id),
        .o_alu_op   (i2_alu_op_id)
    );

    regfile u_regfile (
        .clk       (clk),
        .i_raddr_1 (i1_rj_raddr_id),
        .i_raddr_2 (i1_rk_raddr_id),
        .i_raddr_3 (i2_rj_raddr_id),
        .i_raddr_4 (i2_rk_raddr_id),
        .o_rdata_1 (i1_rj_rdata_id),
        .o_rdata_2 (i1_rk_rdata_id),
        .o_rdata_3 (i2_rj_rdata_id),
        .o_rdata_4 (i2_rk_rdata_id),
        .i_we_1    (i1_rd_we_wb),
        .i_we_2    (i2_rd_we_wb),
        .i_waddr_1 (i1_rd_waddr_wb),
        .i_waddr_2 (i2_rd_waddr_wb),
        .i_wdata_1 (i1_result_wb),
        .i_wdata_2 (i2_result_wb)
    );

    forwarding_logic u_forwarding_logic_1 (
        .i_rs_raddr_id            (i1_rj_raddr_id),
        .i_i1_rd_we_ex1           (i1_rd_we_ex1),
        .i_i1_rd_we_ex2           (i1_rd_we_ex2),
        .i_i1_rd_we_ex3           (i1_rd_we_ex3),
        .i_i1_rd_we_ex4           (i1_rd_we_ex4),
        .i_i1_rd_we_wb            (i1_rd_we_wb),
        .i_i1_rd_waddr_ex1        (i1_rd_waddr_ex1),
        .i_i1_rd_waddr_ex2        (i1_rd_waddr_ex2),
        .i_i1_rd_waddr_ex3        (i1_rd_waddr_ex3),
        .i_i1_rd_waddr_ex4        (i1_rd_waddr_ex4),
        .i_i1_rd_waddr_wb         (i1_rd_waddr_wb),
        .i_i1_result_ex1          (i1_result_ex1),
        .i_i1_result_ex2          (i1_result_ex2),
        .i_i1_result_ex3_final    (i1_result_ex3_final),
        .i_i1_result_ex4_final    (i1_result_ex4_final),
        .i_i1_result_wb           (i1_result_wb),
        .i_i2_rd_we_ex1           (i2_rd_we_ex1),
        .i_i2_rd_we_ex2           (i2_rd_we_ex2),
        .i_i2_rd_we_ex3           (i2_rd_we_ex3),
        .i_i2_rd_we_ex4           (i2_rd_we_ex4),
        .i_i2_rd_we_wb            (i2_rd_we_wb),
        .i_i2_rd_waddr_ex1        (i2_rd_waddr_ex1),
        .i_i2_rd_waddr_ex2        (i2_rd_waddr_ex2),
        .i_i2_rd_waddr_ex3        (i2_rd_waddr_ex3),
        .i_i2_rd_waddr_ex4        (i2_rd_waddr_ex4),
        .i_i2_rd_waddr_wb         (i2_rd_waddr_wb),
        .i_i2_result_ex1          (i2_result_ex1),
        .i_i2_result_ex2          (i2_result_ex2),
        .i_i2_result_ex3_final    (i2_result_ex3_final),
        .i_i2_result_ex4_final    (i2_result_ex4_final),
        .i_i2_result_wb           (i2_result_wb),
        .o_rs_rdata_bypass_vld_id (i1_rj_rdata_bypass_vld_id),
        .o_rs_rdata_bypass_id     (i1_rj_rdata_bypass_id)
    );

    forwarding_logic u_forwarding_logic_2 (
        .i_rs_raddr_id            (i1_rk_raddr_id),
        .i_i1_rd_we_ex1           (i1_rd_we_ex1),
        .i_i1_rd_we_ex2           (i1_rd_we_ex2),
        .i_i1_rd_we_ex3           (i1_rd_we_ex3),
        .i_i1_rd_we_ex4           (i1_rd_we_ex4),
        .i_i1_rd_we_wb            (i1_rd_we_wb),
        .i_i1_rd_waddr_ex1        (i1_rd_waddr_ex1),
        .i_i1_rd_waddr_ex2        (i1_rd_waddr_ex2),
        .i_i1_rd_waddr_ex3        (i1_rd_waddr_ex3),
        .i_i1_rd_waddr_ex4        (i1_rd_waddr_ex4),
        .i_i1_rd_waddr_wb         (i1_rd_waddr_wb),
        .i_i1_result_ex1          (i1_result_ex1),
        .i_i1_result_ex2          (i1_result_ex2),
        .i_i1_result_ex3_final    (i1_result_ex3_final),
        .i_i1_result_ex4_final    (i1_result_ex4_final),
        .i_i1_result_wb           (i1_result_wb),
        .i_i2_rd_we_ex1           (i2_rd_we_ex1),
        .i_i2_rd_we_ex2           (i2_rd_we_ex2),
        .i_i2_rd_we_ex3           (i2_rd_we_ex3),
        .i_i2_rd_we_ex4           (i2_rd_we_ex4),
        .i_i2_rd_we_wb            (i2_rd_we_wb),
        .i_i2_rd_waddr_ex1        (i2_rd_waddr_ex1),
        .i_i2_rd_waddr_ex2        (i2_rd_waddr_ex2),
        .i_i2_rd_waddr_ex3        (i2_rd_waddr_ex3),
        .i_i2_rd_waddr_ex4        (i2_rd_waddr_ex4),
        .i_i2_rd_waddr_wb         (i2_rd_waddr_wb),
        .i_i2_result_ex1          (i2_result_ex1),
        .i_i2_result_ex2          (i2_result_ex2),
        .i_i2_result_ex3_final    (i2_result_ex3_final),
        .i_i2_result_ex4_final    (i2_result_ex4_final),
        .i_i2_result_wb           (i2_result_wb),
        .o_rs_rdata_bypass_vld_id (i1_rk_rdata_bypass_vld_id),
        .o_rs_rdata_bypass_id     (i1_rk_rdata_bypass_id)
    );

    forwarding_logic u_forwarding_logic_3 (
        .i_rs_raddr_id            (i2_rj_raddr_id),
        .i_i1_rd_we_ex1           (i1_rd_we_ex1),
        .i_i1_rd_we_ex2           (i1_rd_we_ex2),
        .i_i1_rd_we_ex3           (i1_rd_we_ex3),
        .i_i1_rd_we_ex4           (i1_rd_we_ex4),
        .i_i1_rd_we_wb            (i1_rd_we_wb),
        .i_i1_rd_waddr_ex1        (i1_rd_waddr_ex1),
        .i_i1_rd_waddr_ex2        (i1_rd_waddr_ex2),
        .i_i1_rd_waddr_ex3        (i1_rd_waddr_ex3),
        .i_i1_rd_waddr_ex4        (i1_rd_waddr_ex4),
        .i_i1_rd_waddr_wb         (i1_rd_waddr_wb),
        .i_i1_result_ex1          (i1_result_ex1),
        .i_i1_result_ex2          (i1_result_ex2),
        .i_i1_result_ex3_final    (i1_result_ex3_final),
        .i_i1_result_ex4_final    (i1_result_ex4_final),
        .i_i1_result_wb           (i1_result_wb),
        .i_i2_rd_we_ex1           (i2_rd_we_ex1),
        .i_i2_rd_we_ex2           (i2_rd_we_ex2),
        .i_i2_rd_we_ex3           (i2_rd_we_ex3),
        .i_i2_rd_we_ex4           (i2_rd_we_ex4),
        .i_i2_rd_we_wb            (i2_rd_we_wb),
        .i_i2_rd_waddr_ex1        (i2_rd_waddr_ex1),
        .i_i2_rd_waddr_ex2        (i2_rd_waddr_ex2),
        .i_i2_rd_waddr_ex3        (i2_rd_waddr_ex3),
        .i_i2_rd_waddr_ex4        (i2_rd_waddr_ex4),
        .i_i2_rd_waddr_wb         (i2_rd_waddr_wb),
        .i_i2_result_ex1          (i2_result_ex1),
        .i_i2_result_ex2          (i2_result_ex2),
        .i_i2_result_ex3_final    (i2_result_ex3_final),
        .i_i2_result_ex4_final    (i2_result_ex4_final),
        .i_i2_result_wb           (i2_result_wb),
        .o_rs_rdata_bypass_vld_id (i2_rj_rdata_bypass_vld_id),
        .o_rs_rdata_bypass_id     (i2_rj_rdata_bypass_id)
    );

        forwarding_logic u_forwarding_logic_4 (
        .i_rs_raddr_id            (i2_rk_raddr_id),
        .i_i1_rd_we_ex1           (i1_rd_we_ex1),
        .i_i1_rd_we_ex2           (i1_rd_we_ex2),
        .i_i1_rd_we_ex3           (i1_rd_we_ex3),
        .i_i1_rd_we_ex4           (i1_rd_we_ex4),
        .i_i1_rd_we_wb            (i1_rd_we_wb),
        .i_i1_rd_waddr_ex1        (i1_rd_waddr_ex1),
        .i_i1_rd_waddr_ex2        (i1_rd_waddr_ex2),
        .i_i1_rd_waddr_ex3        (i1_rd_waddr_ex3),
        .i_i1_rd_waddr_ex4        (i1_rd_waddr_ex4),
        .i_i1_rd_waddr_wb         (i1_rd_waddr_wb),
        .i_i1_result_ex1          (i1_result_ex1),
        .i_i1_result_ex2          (i1_result_ex2),
        .i_i1_result_ex3_final    (i1_result_ex3_final),
        .i_i1_result_ex4_final    (i1_result_ex4_final),
        .i_i1_result_wb           (i1_result_wb),
        .i_i2_rd_we_ex1           (i2_rd_we_ex1),
        .i_i2_rd_we_ex2           (i2_rd_we_ex2),
        .i_i2_rd_we_ex3           (i2_rd_we_ex3),
        .i_i2_rd_we_ex4           (i2_rd_we_ex4),
        .i_i2_rd_we_wb            (i2_rd_we_wb),
        .i_i2_rd_waddr_ex1        (i2_rd_waddr_ex1),
        .i_i2_rd_waddr_ex2        (i2_rd_waddr_ex2),
        .i_i2_rd_waddr_ex3        (i2_rd_waddr_ex3),
        .i_i2_rd_waddr_ex4        (i2_rd_waddr_ex4),
        .i_i2_rd_waddr_wb         (i2_rd_waddr_wb),
        .i_i2_result_ex1          (i2_result_ex1),
        .i_i2_result_ex2          (i2_result_ex2),
        .i_i2_result_ex3_final    (i2_result_ex3_final),
        .i_i2_result_ex4_final    (i2_result_ex4_final),
        .i_i2_result_wb           (i2_result_wb),
        .o_rs_rdata_bypass_vld_id (i2_rk_rdata_bypass_vld_id),
        .o_rs_rdata_bypass_id     (i2_rk_rdata_bypass_id)
    );

    // ---------------------------------------------------- //
    // ----------------------- EX1 ------------------------ //
    // ---------------------------------------------------- // 

    dff #(DATA_WIDTH(1'b1))          u_dff_i1_rd_we_ex1    (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i1_rd_we_id), .o_dout(i1_rd_we_ex1));
    dff #(DATA_WIDTH(`LA64_ARF_SEL)) u_dff_i1_rd_waddr_ex1 (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i1_rd_waddr_id), .o_dout(i1_rd_waddr_ex1));

    dff #(DATA_WIDTH(`ALU_OP_WIDTH)) u_dff_i1_alu_op_ex1   (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i1_alu_op_id), .o_dout(i1_alu_op_ex1));

    dff #(DATA_WIDTH(1'b1))          u_dff_i2_rd_we_ex1    (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i2_rd_we_id), .o_dout(i2_rd_we_ex1));
    dff #(DATA_WIDTH(`LA64_ARF_SEL)) u_dff_i2_rd_waddr_ex1 (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i2_rd_waddr_id), .o_dout(i2_rd_waddr_ex1));

    alu u_alu_1 (
        .i_alu_op     (i1_alu_op_ex1),
        .i_alu_src1   (),
        .i_alu_src2   (),
        .o_alu_result (i1_result_ex1)
    );

    alu u_alu_2 (
        .i_alu_op     (i2_alu_op_ex1),
        .i_alu_src1   (),
        .i_alu_src2   (),
        .o_alu_result (i2_result_ex1)
    );

    // ---------------------------------------------------- //
    // ----------------------- EX2 ------------------------ //
    // ---------------------------------------------------- // 
    
    dff #(DATA_WIDTH(1'b1))          u_dff_i1_rd_we_ex2    (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i1_rd_we_ex1), .o_dout(i1_rd_we_ex2));
    dff #(DATA_WIDTH(`LA64_ARF_SEL)) u_dff_i1_rd_waddr_ex2 (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i1_rd_waddr_ex1), .o_dout(i1_rd_waddr_ex2));

    dff #(DATA_WIDTH(1'b1))          u_dff_i2_rd_we_ex2    (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i2_rd_we_ex1), .o_dout(i2_rd_we_ex2));
    dff #(DATA_WIDTH(`LA64_ARF_SEL)) u_dff_i2_rd_waddr_ex2 (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i2_rd_waddr_ex1), .o_dout(i2_rd_waddr_ex2));
    

    // ---------------------------------------------------- //
    // ----------------------- EX3 ------------------------ //
    // ---------------------------------------------------- // 

    dff #(DATA_WIDTH(1'b1))          u_dff_i1_rd_we_ex3    (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i1_rd_we_ex2), .o_dout(i1_rd_we_ex3));
    dff #(DATA_WIDTH(`LA64_ARF_SEL)) u_dff_i1_rd_waddr_ex3 (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i1_rd_waddr_ex2), .o_dout(i1_rd_waddr_ex3));

    dff #(DATA_WIDTH(1'b1))          u_dff_i2_rd_we_ex3    (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i2_rd_we_ex2), .o_dout(i2_rd_we_ex3));
    dff #(DATA_WIDTH(`LA64_ARF_SEL)) u_dff_i2_rd_waddr_ex3 (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i2_rd_waddr_ex2), .o_dout(i2_rd_waddr_ex3));

    // ---------------------------------------------------- //
    // ---------------------- Commit ---------------------- //
    // ---------------------------------------------------- // 

    dff #(DATA_WIDTH(1'b1))          u_dff_i1_rd_we_ex4    (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i1_rd_we_ex3), .o_dout(i1_rd_we_ex4));
    dff #(DATA_WIDTH(`LA64_ARF_SEL)) u_dff_i1_rd_waddr_ex4 (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i1_rd_waddr_ex3), .o_dout(i1_rd_waddr_ex4));

    dff #(DATA_WIDTH(1'b1))          u_dff_i2_rd_we_ex4    (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i2_rd_we_ex3), .o_dout(i2_rd_we_ex4));
    dff #(DATA_WIDTH(`LA64_ARF_SEL)) u_dff_i2_rd_waddr_ex4 (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i2_rd_waddr_ex3), .o_dout(i2_rd_waddr_ex4));

    // ---------------------------------------------------- //
    // --------------------- Writeback -------------------- //
    // ---------------------------------------------------- // 

    dff #(DATA_WIDTH(1'b1))          u_dff_i1_rd_we_wb    (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i1_rd_we_ex4), .o_dout(i1_rd_we_wb));
    dff #(DATA_WIDTH(`LA64_ARF_SEL)) u_dff_i1_rd_waddr_wb (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i1_rd_waddr_ex4), .o_dout(i1_rd_waddr_wb));

    dff #(DATA_WIDTH(1'b1))          u_dff_i2_rd_we_wb    (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i2_rd_we_ex4), .o_dout(i2_rd_we_wb));
    dff #(DATA_WIDTH(`LA64_ARF_SEL)) u_dff_i2_rd_waddr_wb (.clk(clk), .rst_n(rst_n), .i_en(), .i_din(i2_rd_waddr_ex4), .o_dout(i2_rd_waddr_wb));

endmodule

`default_nettype wire
