`include "constants.vh"

module deu_ib_ctl (
    input  logic 	                    clk,
    input  logic 	                    rst_n,   

    input  logic                        ifu_i0_valid,                
    input  logic [`LA64_PC_WIDTH-1:1]   ifu_i0_pc,
    input  logic [`LA64_INST_WIDTH-1:0] ifu_i0_inst, 

    input  logic                        ifu_i1_valid,
    input  logic [`LA64_PC_WIDTH-1:1]   ifu_i1_pc,          
    input  logic [`LA64_INST_WIDTH-1:0] ifu_i1_inst,

    output logic                        deu_ib0_val,
    output logic                        deu_ib1_val,
    output logic                        deu_ib2_val,
    output logic                        deu_ib3_val,

    input  logic                        deu_i0_decode,              
    output logic [`LA64_PC_WIDTH-1:1]   deu_i0_pc,
    output logic [`LA64_INST_WIDTH-1:0] deu_i0_inst,

    input  logic                        deu_i1_decode,
    output logic [`LA64_PC_WIDTH-1:1]   deu_i1_pc,
    output logic [`LA64_INST_WIDTH-1:0] deu_i1_inst  
);

    logic ifu_i0_allowin, ifu_i1_allowin;
    logic shift0, shift1, shift2;
    logic [3:0] ibval;
    logic [3:0] shift_ibval;
    logic write_i0_ib0, write_i0_ib1, write_i0_ib2, write_i0_ib3;
    logic write_i1_ib1, write_i1_ib2, write_i1_ib3;
    logic shift_ib1_ib0, shift_ib2_ib1, shift_ib3_ib2;
    logic shift_ib2_ib0, shift_ib3_ib1;
    logic [3:0] ib_we;
    logic [`LA64_INST_WIDTH-1:0] ib0_in, ib1_in, ib2_in, ib3_in; 
    logic [`LA64_PC_WIDTH-1:0] ibpc0_in, ibpc1_in, ibpc2_in, ibpc3_in;
    logic [`LA64_INST_WIDTH-1:0] ib0, ib1, ib2, ib3;
    logic [`LA64_PC_WIDTH-1:0] ibpc0, ibpc1, ibpc2, ibpc3;
    logic [3:0] i0_we;
    logic [3:1] i1_we;
    logic [3:0] ibvalid;
    logic [3:0] ibval_in;

    // Inst allowin
    assign ifu_i0_allowin = ifu_i0_valid & ~ibval[3];
    assign ifu_i1_allowin = ifu_i1_valid & ~ibval[2];

    // Shift number
    assign shift0 = ~deu_i0_decode;
    assign shift1 =  deu_i0_decode & ~deu_i1_decode;
    assign shift2 =  deu_i0_decode &  deu_i1_decode;

    // Shift ibval
    assign shift_ibval = ({4{shift0}} &        ibval[3:0] ) |
                         ({4{shift1}} & {1'b0, ibval[3:1]}) |
                         ({4{shift2}} & {2'b0, ibval[3:2]});

    // write i0, i1 to ib0, ib1, ib2, ib3
    assign write_i0_ib0 = ~shift_ibval[0]                   & ifu_i0_allowin;
    assign write_i0_ib1 =  shift_ibval[0] & ~shift_ibval[1] & ifu_i0_allowin;
    assign write_i0_ib2 =  shift_ibval[1] & ~shift_ibval[2] & ifu_i0_allowin;
    assign write_i0_ib3 =  shift_ibval[2] & ~shift_ibval[3] & ifu_i0_allowin;

    assign write_i1_ib1 = ~shift_ibval[0]                   & ifu_i1_allowin;
    assign write_i1_ib2 =  shift_ibval[0] & ~shift_ibval[1] & ifu_i1_allowin;
    assign write_i1_ib3 =  shift_ibval[1] & ~shift_ibval[2] & ifu_i1_allowin;

    // Shift ib1, ib2, ib3 to ib0, ib1, ib2
    assign shift_ib1_ib0 = shift1 & ibval[1];
    assign shift_ib2_ib1 = shift1 & ibval[2];
    assign shift_ib3_ib2 = shift1 & ibval[3];   

    assign shift_ib2_ib0 = shift2 & ibval[2];
    assign shift_ib3_ib1 = shift2 & ibval[3];

    // Ib_in
    assign ib0_in = ({`LA64_INST_WIDTH{write_i0_ib0 }} & ifu_i0_inst) |
                    ({`LA64_INST_WIDTH{shift_ib1_ib0}} & ib1        ) |
                    ({`LA64_INST_WIDTH{shift_ib2_ib0}} & ib2        );

    assign ib1_in = ({`LA64_INST_WIDTH{write_i0_ib1 }} & ifu_i0_inst) |
                    ({`LA64_INST_WIDTH{write_i1_ib1 }} & ifu_i1_inst) |
                    ({`LA64_INST_WIDTH{shift_ib2_ib1}} & ib2        ) |
                    ({`LA64_INST_WIDTH{shift_ib3_ib1}} & ib3        );

    assign ib2_in = ({`LA64_INST_WIDTH{write_i0_ib2 }} & ifu_i0_inst) |
                    ({`LA64_INST_WIDTH{write_i1_ib2 }} & ifu_i1_inst) |
                    ({`LA64_INST_WIDTH{shift_ib3_ib2}} & ib3        );

    assign ib3_in = ({`LA64_INST_WIDTH{write_i0_ib3 }} & ifu_i0_inst) | 
                    ({`LA64_INST_WIDTH{write_i1_ib3 }} & ifu_i1_inst);

    assign pc0_in = ({`LA64_PC_WIDTH{write_i0_ib0 }} & ifu_i0_pc) |
                    ({`LA64_PC_WIDTH{shift_ib1_ib0}} & ibpc1    ) |
                    ({`LA64_PC_WIDTH{shift_ib2_ib0}} & ibpc2    );    

    assign pc1_in = ({`LA64_PC_WIDTH{write_i0_ib1 }} & ifu_i0_pc) |
                    ({`LA64_PC_WIDTH{write_i1_ib1 }} & ifu_i1_pc) |
                    ({`LA64_PC_WIDTH{shift_ib2_ib1}} & ibpc2    ) |
                    ({`LA64_PC_WIDTH{shift_ib3_ib1}} & ibpc3    );

    assign pc2_in = ({`LA64_PC_WIDTH{write_i0_ib2 }} & ifu_i0_pc) |
                    ({`LA64_PC_WIDTH{write_i1_ib2 }} & ifu_i1_pc) |
                    ({`LA64_PC_WIDTH{shift_ib3_ib2}} & ibpc3    );

    assign pc3_in = ({`LA64_PC_WIDTH{write_i0_ib3 }} & ifu_i0_pc) |
                    ({`LA64_PC_WIDTH{write_i1_ib3 }} & ifu_i1_pc);

    // Ib_we
    assign ib_we = {write_i0_ib3 | write_i1_ib3,
                    write_i0_ib2 | write_i1_ib2  | shift_ib3_ib2,
                    write_i0_ib1 | write_i1_ib1  | shift_ib2_ib1 | shift_ib3_ib1,
                    write_i0_ib0 | shift_ib1_ib0 | shift_ib2_ib0};

    // Ib
    dffe #(`LA64_INST_WIDTH) u_dffe_ib0 (.*, .en(ib_we[0]), .din(ib0_in), .dout(ib0));
    dffe #(`LA64_INST_WIDTH) u_dffe_ib1 (.*, .en(ib_we[1]), .din(ib1_in), .dout(ib1));
    dffe #(`LA64_INST_WIDTH) u_dffe_ib2 (.*, .en(ib_we[2]), .din(ib2_in), .dout(ib2));
    dffe #(`LA64_INST_WIDTH) u_dffe_ib3 (.*, .en(ib_we[3]), .din(ib3_in), .dout(ib3));

    dffe #(`LA64_PC_WIDTH) u_dffe_ibpc0 (.*, .en(ib_we[0]), .din(ibpc0_in), .dout(ibpc0));
    dffe #(`LA64_PC_WIDTH) u_dffe_ibpc1 (.*, .en(ib_we[1]), .din(ibpc1_in), .dout(ibpc1));
    dffe #(`LA64_PC_WIDTH) u_dffe_ibpc2 (.*, .en(ib_we[2]), .din(ibpc2_in), .dout(ibpc2));
    dffe #(`LA64_PC_WIDTH) u_dffe_ibpc3 (.*, .en(ib_we[3]), .din(ibpc3_in), .dout(ibpc3));

    // Ibval_in
    assign ibval_in = shift_ibval | ib_we;

    // Ibval
    dff #(4) u_dff_ibval (.*, .din(ibval_in), .dout(ibval));

    assign {deu_ib3_val, deu_ib2_val, deu_ib1_val, deu_ib0_val} = ibval;

    assign deu_i0_pc   = ibpc0;
    assign deu_i1_pc   = ibpc1;
    assign deu_i0_inst = ib0;
    assign deu_i1_inst = ib1;

endmodule
