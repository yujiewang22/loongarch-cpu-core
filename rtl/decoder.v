`default_nettype none
`include "constants.vh"

module decoder (
    input  wire [`LA64_INST_WIDTH-1:0] i_inst,
    output wire                        o_inst_vld,
    output wire                        o_rj_re,
    output wire                        o_rk_re,
    output wire                        o_rd_we,
    output wire [`LA64_ARF_SEL-1:0]    o_rj_raddr,
    output wire [`LA64_ARF_SEL-1:0]    o_rk_raddr,
    output wire [`LA64_ARF_SEL-1:0]    o_rd_waddr,
    output wire [`ALU_OP_WIDTH-1:0]    o_alu_op
);
    assign o_rd_waddr = i_inst[ 4: 0];
    assign o_rj_raddr = i_inst[ 9: 5];
    assign o_rk_raddr = i_inst[14:10];

    wire [5:0] op_31_26;
    wire [3:0] op_25_22;
    wire [1:0] op_21_20;
    wire [4:0] op_19_15;

    wire [63:0] op_31_26_d;
    wire [15:0] op_25_22_d;
    wire [3:0]  op_21_20_d;
    wire [31:0] op_19_15_d;

    wire inst_add_w; 
    wire inst_sub_w; 
    wire inst_slt;    
    wire inst_sltu; 
    wire inst_nor;    
    wire inst_and;    
    wire inst_or;     
    wire inst_xor;    
    wire inst_orn;
    wire inst_andn;
    wire inst_sll_w;
    wire inst_srl_w;
    wire inst_sra_w;
    wire inst_mul_w;
    wire inst_mulh_w;
    wire inst_mulh_wu;
    wire inst_break;
    wire inst_syscall;
    wire inst_slli_w;
    wire inst_srli_w;
    wire inst_srai_w;
    wire inst_slti;
    wire inst_sltui;
    wire inst_addi_w;
    wire inst_andi;
    wire inst_ori;
    wire inst_xori;
    wire inst_lu12i_w;
    wire inst_ld_b;
    wire inst_ld_h;
    wire inst_ld_w;
    wire inst_st_b;
    wire inst_st_h;
    wire inst_st_w;
    wire inst_ld_bu;
    wire inst_ld_hu;
    wire inst_b;
    wire inst_bl;
    wire inst_beq;
    wire inst_bne;
    wire inst_blt;
    wire inst_bge;
    wire inst_bltu;
    wire inst_bgeu;

    assign op_31_26 = i_inst[31:26];
    assign op_25_22 = i_inst[25:22];
    assign op_21_20 = i_inst[21:20];
    assign op_19_15 = i_inst[19:15];

    decoder_6_64 u_decoder_6_64 (.i_in(op_31_26), .o_out(op_31_26_d));
    decoder_4_16 u_decoder_4_16 (.i_in(op_25_22), .o_out(op_25_22_d));
    decoder_2_4  u_decoder_2_4  (.i_in(op_21_20), .o_out(op_21_20_d));
    decoder_5_32 u_decoder_5_32 (.i_in(op_19_15), .o_out(op_19_15_d));

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
    assign inst_lu12i_w = op_31_26_d[6'h05] & ~i_inst[25];
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

    assign o_alu_op[ 0] = inst_add_w;
    assign o_alu_op[ 1] = inst_sub_w;
    assign o_alu_op[ 2] = inst_slt   | inst_slti;
    assign o_alu_op[ 3] = inst_sltu  | inst_sltui;
    assign o_alu_op[ 4] = inst_nor;
    assign o_alu_op[ 5] = inst_and   | inst_andi;
    assign o_alu_op[ 6] = inst_or    | inst_ori;
    assign o_alu_op[ 7] = inst_xor   | inst_xori;
    assign o_alu_op[ 8] = inst_orn;
    assign o_alu_op[ 9] = inst_andn;
    assign o_alu_op[10] = inst_sll_w | inst_slli_w;
    assign o_alu_op[11] = inst_srl_w | inst_srli_w;
    assign o_alu_op[12] = inst_sra_w | inst_srai_w;
    assign o_alu_op[13] = inst_lu12i_w;

endmodule

`default_nettype wire
