`include "constants.vh"

module deu_ib_ctl (
    input  logic                        clk,
    input  logic                        rst_n,

    output logic [`LA64_PC_WIDTH-1:1]   i0_pc,
    output logic [`LA64_DATA_WIDTH-1:0] i0_inst,

    output logic [`LA64_PC_WIDTH-1:1]   i1_pc,        
    output logic [`LA64_DATA_WIDTH-1:0] i1_inst
);

    logic [3:0] ib_we;
    logic [`LA64_DATA_WIDTH-1:0] ib3_in, ib2_in, ib1_in, ib0_in;
    logic [`LA64_DATA_WIDTH-1:0] ib3, ib2, ib1, ib0; 
    logic [3:0] 	 ibval_in, ibval;

    assign ib0_in = ({32{write_i0_ib0 }} ? ifu_i0_instr[31:0]) |
                    ({32{shift_ib1_ib0}} & ib1) |
                    ({32{shift_ib2_ib0}} & ib2);

    assign ib1_in = ({32{write_i0_ib1 }} & ifu_i0_inst) |
                    ({32{write_i1_ib1 }} & ifu_i1_inst) |
                    ({32{shift_ib2_ib1}} & ib2        ) |
                    ({32{shift_ib3_ib1}} & ib3        );

    assign ib2_in = ({32{write_i0_ib2 }} & ifu_i0_inst) |
                    ({32{write_i1_ib2 }} & ifu_i1_inst) |
                    ({32{shift_ib3_ib2}} & u_dff_ib3  );

    assign ib3_in = ({32{write_i0_ib3}} & ifu_i0_inst) |
                    ({32{write_i1_ib3}} & ifu_i1_inst);

   assign shift0 = ~dec_i0_decode_d;
   assign shift2 = dec_i0_decode_d & dec_i1_decode_d;
   assign shift1 = dec_i0_decode_d & ~dec_i1_decode_d;

   assign shift_ib1_ib0 = shift1 & ibval[1];
   assign shift_ib2_ib0 = shift2 & ibval[2];
   assign shift_ib2_ib1 = shift1 & ibval[2];
   assign shift_ib3_ib1 = shift2 & ibval[3];
   assign shift_ib3_ib2 = shift1 & ibval[3];   

    dff #(WIDTH(`LA64_DATA_WIDTH)) u_dff_ib0 (.*, .en(ib_we[0]), .din(ib0_in), .dout(ib0));
    dff #(WIDTH(`LA64_DATA_WIDTH)) u_dff_ib2 (.*, .en(ib_we[2]), .din(ib2_in), .dout(ib2));
    dff #(WIDTH(`LA64_DATA_WIDTH)) u_dff_ib1 (.*, .en(ib_we[1]), .din(ib1_in), .dout(ib1));
    dff #(WIDTH(`LA64_DATA_WIDTH)) u_dff_ib3 (.*, .en(ib_we[3]), .din(ib3_in), .dout(ib3));

endmodule
