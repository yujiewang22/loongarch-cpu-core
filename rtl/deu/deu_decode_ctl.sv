`include "../include/constants.vh"

module deu_decode_ctl (
    input  logic [`LA64_INST_WIDTH-1:0] inst,
    output logic                        inst_valid,
    output logic [`LA64_DATA_WIDTH-1:0] imm,
    output logic                        rf_re0,
    output logic                        rf_re1, 
    output logic                        rf_we,
    output logic [`LA64_ARF_SEL-1:0]    rf_raddr0,
    output logic [`LA64_ARF_SEL-1:0]    rf_raddr1,
    output logic [`LA64_ARF_SEL-1:0]    rf_waddr,
    output logic                        src0_is_pc,
    output logic                        src1_is_imm,
    output logic                        src1_is_4,
    output logic [`ALU_OP_WIDTH-1:0]    alu_op,
    output logic                        mul_signed,
    output logic                        mul_low  
);

    // Rd, rj, rk
    logic [`LA64_ARF_SEL-1:0] rd;
    logic [`LA64_ARF_SEL-1:0] rj;
    logic [`LA64_ARF_SEL-1:0] rk;

    assign rd = inst[ 4: 0];
    assign rj = inst[ 9: 5];
    assign rk = inst[14:10];
    
    // Inst 
    logic [5:0] op_31_26;
    logic [3:0] op_25_22;
    logic [1:0] op_21_20;
    logic [4:0] op_19_15;

    logic [63:0] op_31_26_d;
    logic [15:0] op_25_22_d;
    logic [3:0]  op_21_20_d;
    logic [31:0] op_19_15_d;

    logic inst_zero;
    logic inst_add_w; 
    logic inst_sub_w; 
    logic inst_slt;    
    logic inst_sltu; 
    logic inst_nor;    
    logic inst_and;    
    logic inst_or;     
    logic inst_xor;    
    logic inst_orn;
    logic inst_andn;
    logic inst_sll_w;
    logic inst_srl_w;
    logic inst_sra_w;
    logic inst_mul_w;
    logic inst_mulh_w;
    logic inst_mulh_wu;
    logic inst_break;
    logic inst_syscall;
    logic inst_slli_w;
    logic inst_srli_w;
    logic inst_srai_w;
    logic inst_slti;
    logic inst_sltui;
    logic inst_addi_w;
    logic inst_andi;
    logic inst_ori;
    logic inst_xori;
    logic inst_lu12i_w;
    logic inst_ld_b;
    logic inst_ld_h;
    logic inst_ld_w;
    logic inst_st_b;
    logic inst_st_h;
    logic inst_st_w;
    logic inst_ld_bu;
    logic inst_ld_hu;
    logic inst_b;
    logic inst_bl;
    logic inst_beq;
    logic inst_bne;
    logic inst_blt;
    logic inst_bge;
    logic inst_bltu;
    logic inst_bgeu;

    assign op_31_26 = inst[31:26];
    assign op_25_22 = inst[25:22];
    assign op_21_20 = inst[21:20];
    assign op_19_15 = inst[19:15];

    decoder_6_64 u_decoder_6_64 (.in(op_31_26), .out(op_31_26_d));
    decoder_4_16 u_decoder_4_16 (.in(op_25_22), .out(op_25_22_d));
    decoder_2_4  u_decoder_2_4  (.in(op_21_20), .out(op_21_20_d));
    decoder_5_32 u_decoder_5_32 (.in(op_19_15), .out(op_19_15_d));

    assign inst_zero    = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h0] & op_19_15_d[5'h00];
    assign inst_add_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h00];
    assign inst_sub_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h02];
    assign inst_slt     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h04];
    assign inst_sltu    = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h05];
    assign inst_nor     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h08];
    assign inst_and     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h09];
    assign inst_or      = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0a];
    assign inst_xor     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0b];
    assign inst_orn     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0c];
    assign inst_andn    = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0d];
    assign inst_sll_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0e];
    assign inst_srl_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0f];
    assign inst_sra_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h10];
    assign inst_mul_w   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h18];
    assign inst_mulh_w  = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h19];
    assign inst_mulh_wu = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h1a];
    assign inst_break   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h14];
    assign inst_syscall = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h16];
    assign inst_slli_w  = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h01];
    assign inst_srli_w  = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h09];
    assign inst_srai_w  = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h11];
    assign inst_slti    = op_31_26_d[6'h00] & op_25_22_d[4'h8];
    assign inst_sltui   = op_31_26_d[6'h00] & op_25_22_d[4'h9];
    assign inst_addi_w  = op_31_26_d[6'h00] & op_25_22_d[4'ha];
    assign inst_andi    = op_31_26_d[6'h00] & op_25_22_d[4'hd];
    assign inst_ori     = op_31_26_d[6'h00] & op_25_22_d[4'he];
    assign inst_xori    = op_31_26_d[6'h00] & op_25_22_d[4'hf];
    assign inst_lu12i_w = op_31_26_d[6'h05] & ~inst[25];
    assign inst_ld_b    = op_31_26_d[6'h0a] & op_25_22_d[4'h0];
    assign inst_ld_h    = op_31_26_d[6'h0a] & op_25_22_d[4'h1];
    assign inst_ld_w    = op_31_26_d[6'h0a] & op_25_22_d[4'h2];
    assign inst_st_b    = op_31_26_d[6'h0a] & op_25_22_d[4'h4];
    assign inst_st_h    = op_31_26_d[6'h0a] & op_25_22_d[4'h5];
    assign inst_st_w    = op_31_26_d[6'h0a] & op_25_22_d[4'h6];
    assign inst_ld_bu   = op_31_26_d[6'h0a] & op_25_22_d[4'h8];
    assign inst_ld_hu   = op_31_26_d[6'h0a] & op_25_22_d[4'h9];
    assign inst_b       = op_31_26_d[6'h14];
    assign inst_bl      = op_31_26_d[6'h15];
    assign inst_beq     = op_31_26_d[6'h16];
    assign inst_bne     = op_31_26_d[6'h17];
    assign inst_blt     = op_31_26_d[6'h18];
    assign inst_bge     = op_31_26_d[6'h19];
    assign inst_bltu    = op_31_26_d[6'h1a];
    assign inst_bgeu    = op_31_26_d[6'h1b];

    // Imm
    logic [11:0] i12;
    logic [19:0] i20;
    logic [15:0] i16;
    logic [25:0] i26;

    logic need_ui5;
    logic need_ui12;
    logic need_si12;
    logic need_si16_pc;
    logic need_si20;
    logic need_si26_pc;
    
    assign i12 = inst[21:10];
    assign i16 = inst[25:10];
    assign i20 = inst[24:5];
    assign i26 = {inst[9:0], inst[25:10]};

    assign need_ui5     = inst_slli_w | inst_srli_w | inst_srai_w;
    assign need_ui12    = inst_andi   | inst_ori    | inst_xori;
    assign need_si12    = inst_slti   | 
                          inst_sltui  |
                          inst_addi_w |
                          inst_ld_b   |
                          inst_ld_h   |
                          inst_ld_w   |
                          inst_st_b   |
                          inst_st_h   | 
                          inst_st_w   |
                          inst_ld_bu  |
                          inst_ld_hu;
    assign need_si16_pc = inst_beq    | 
                          inst_bne    | 
                          inst_blt    | 
                          inst_bge    | 
                          inst_bltu   | 
                          inst_bgeu;
    assign need_si20    = inst_lu12i_w;
    assign need_si26_pc = inst_b      | inst_bl;

    assign imm = ({`LA64_DATA_WIDTH{need_ui5    }} & {27'b0, rk}               ) |
                 ({`LA64_DATA_WIDTH{need_ui12   }} & {20'b0, i12}              ) |
                 ({`LA64_DATA_WIDTH{need_si12   }} & {{20{i12[11]}}, i12}      ) |
                 ({`LA64_DATA_WIDTH{need_si16_pc}} & {{14{i16[15]}}, i16, 2'b0}) |
                 ({`LA64_DATA_WIDTH{need_si20   }} & {i20, 12'b0}              ) |
                 ({`LA64_DATA_WIDTH{need_si26_pc}} & {{ 4{i26[25]}}, i26, 2'b0}) ;

    // Imformation
    assign src0_is_pc = inst_bl;

    assign src1_is_imm = inst_slli_w  |
                         inst_srli_w  |
                         inst_srai_w  |
                         inst_slti    |
                         inst_sltui   |
                         inst_addi_w  |
                         inst_andi    |
                         inst_ori     |
                         inst_xori    |
                         inst_lu12i_w |
                         inst_ld_b    |
                         inst_ld_h    |
                         inst_ld_w    |
                         inst_st_b    |
                         inst_st_h    |
                         inst_st_w    |
                         inst_ld_bu   |
                         inst_ld_hu;

    assign src1_is_4 = inst_bl;

    // Regfile

    assign rf_re0 = inst_add_w   |
                    inst_sub_w   |
                    inst_slt     |
                    inst_sltu    |
                    inst_nor     |
                    inst_and     |
                    inst_or      |
                    inst_xor     |
                    inst_sll_w   |
                    inst_srl_w   |
                    inst_sra_w   |
                    inst_mul_w   |
                    inst_mulh_w  |
                    inst_mulh_wu |
                    inst_slli_w  |
                    inst_srli_w  |
                    inst_srai_w  |
                    inst_slti    |
                    inst_sltui   |
                    inst_addi_w  |
                    inst_andi    |
                    inst_ori     |
                    inst_xori    |
                    inst_ld_b    |
                    inst_ld_h    |
                    inst_ld_w    |
                    inst_st_b    |
                    inst_st_h    |
                    inst_st_w    |
                    inst_ld_bu   |
                    inst_ld_hu   |
                    inst_beq     |
                    inst_bne     |
                    inst_blt     |
                    inst_bge     |
                    inst_bltu    |
                    inst_bgeu;

    assign rf_re1 = inst_add_w   |
                    inst_sub_w   |
                    inst_slt     |
                    inst_sltu    |
                    inst_nor     |
                    inst_and     |
                    inst_or      |
                    inst_xor     |
                    inst_sll_w   |
                    inst_srl_w   |
                    inst_sra_w   |
                    inst_mul_w   |
                    inst_mulh_w  |
                    inst_mulh_wu |
                    inst_st_b    |
                    inst_st_h    |
                    inst_st_w    |
                    inst_beq     |
                    inst_bne     |
                    inst_blt     |
                    inst_bge     |
                    inst_bltu    |
                    inst_bgeu;

    // 之后修改
    assign rf_we = ~inst_zero    &
                   ~inst_syscall &
                   ~inst_st_b    & 
                   ~inst_st_h    & 
                   ~inst_st_w    &
                   ~inst_b       & 
                   ~inst_beq     & 
                   ~inst_bne     & 
                   ~inst_blt     & 
                   ~inst_bge     &
                   ~inst_bltu    &
                   ~inst_bgeu;

    logic src2_is_rd;
    logic dst_is_r1;

    assign src2_is_rd = inst_st_b |
                        inst_st_h |
                        inst_st_w |
                        inst_beq  | 
                        inst_bne  | 
                        inst_blt  | 
                        inst_bge  | 
                        inst_bltu | 
                        inst_bgeu;

    assign dst_is_r1 = inst_bl;

    assign rf_raddr0 = rj;
    assign rf_raddr1 = src2_is_rd ? rd : rk;
    assign rf_waddr  = dst_is_r1 ? 5'd1 : rd;

    // Alu_op
    assign alu_op[ 0] = inst_add_w;
    assign alu_op[ 1] = inst_sub_w;
    assign alu_op[ 2] = inst_slt   | inst_slti;
    assign alu_op[ 3] = inst_sltu  | inst_sltui;
    assign alu_op[ 4] = inst_nor;
    assign alu_op[ 5] = inst_and   | inst_andi;
    assign alu_op[ 6] = inst_or    | inst_ori;
    assign alu_op[ 7] = inst_xor   | inst_xori;
    assign alu_op[ 8] = inst_orn;
    assign alu_op[ 9] = inst_andn;
    assign alu_op[10] = inst_sll_w | inst_slli_w;
    assign alu_op[11] = inst_srl_w | inst_srli_w;
    assign alu_op[12] = inst_sra_w | inst_srai_w;
    assign alu_op[13] = inst_lu12i_w;

    // Mul
    assign mul_signed = inst_mul_w | inst_mulh_w;
    assign mul_low    = inst_mul_w;       

endmodule
