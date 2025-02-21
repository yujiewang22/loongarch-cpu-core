`include "../include/constants.vh"

module exu (
    input logic        clk,              
    input logic        rst_n
);   

    // Ex1, 2, 3
    
    exu_alu_ctl u_exu_alu_ctl_1 (
        .*,
        .alu_op (),
        .src0   (),
        .src1   (),
        .result ()
    );

    exu_alu_ctl u_exu_alu_ctl_2 (
        .*,
        .alu_op (),
        .src0   (),
        .src1   (),
        .result ()
    );

    exu_mul_ctl u_exu_mul_ctl (
        .*,
        .mul_signed (),
        .mul_low    (),
        .src0       (),
        .src1       (),
        .result     ()
    );

    // Ex4

    exu_alu_ctl u_exu_alu_ctl_3 (
        .*,
        .alu_op (),
        .src0   (),
        .src1   (),
        .result ()
    );

    exu_alu_ctl u_exu_alu_ctl_4 (
        .*,
        .alu_op (),
        .src0   (),
        .src1   (),
        .result ()
    );

endmodule
