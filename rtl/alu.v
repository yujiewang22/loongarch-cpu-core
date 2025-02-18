`default_nettype none
`include "constants.vh"

module alu (
    input  wire [`ALU_OP_WIDTH-1:0]    i_alu_op,
    input  wire [`LA64_DATA_WIDTH-1:0] i_alu_src1,
    input  wire [`LA64_DATA_WIDTH-1:0] i_alu_src2,
    output wire [`LA64_DATA_WIDTH-1:0] o_alu_result
);

    wire op_add;
    wire op_sub;
    wire op_slt;
    wire op_sltu;
    wire op_nor;
    wire op_and;
    wire op_or;
    wire op_xor;
    wire op_orn;
    wire op_andn;
    wire op_sll;
    wire op_srl;
    wire op_sra;
    wire op_lui;

    assign op_add  = i_alu_op[ 0];
    assign op_sub  = i_alu_op[ 1];
    assign op_slt  = i_alu_op[ 2];
    assign op_sltu = i_alu_op[ 3];
    assign op_nor  = i_alu_op[ 4];
    assign op_and  = i_alu_op[ 5];
    assign op_or   = i_alu_op[ 6];
    assign op_xor  = i_alu_op[ 7];
    assign op_orn  = i_alu_op[ 8];
    assign op_andn = i_alu_op[ 9];
    assign op_sll  = i_alu_op[10];
    assign op_srl  = i_alu_op[11];
    assign op_sra  = i_alu_op[12];
    assign op_lui  = i_alu_op[13]; 

    wire [`LA64_DATA_WIDTH-1:0] add_sub_result;
    wire [`LA64_DATA_WIDTH-1:0] slt_result;  
    wire [`LA64_DATA_WIDTH-1:0] sltu_result;
    wire [`LA64_DATA_WIDTH-1:0] nor_result;
    wire [`LA64_DATA_WIDTH-1:0] and_result;  
    wire [`LA64_DATA_WIDTH-1:0] or_result;  
    wire [`LA64_DATA_WIDTH-1:0] xor_result;  
    wire [`LA64_DATA_WIDTH-1:0] orn_result;  
    wire [`LA64_DATA_WIDTH-1:0] andn_result;
    wire [`LA64_DATA_WIDTH-1:0] sll_result;
    wire [`LA64_DATA_WIDTH-1:0] sr_result;
    wire [`LA64_DATA_WIDTH-1:0] lui_result;

    // Adder
    wire [`LA64_DATA_WIDTH:0] adder_a;
    wire [`LA64_DATA_WIDTH:0] adder_b;
    wire                      adder_cin;
    wire [`LA64_DATA_WIDTH:0] adder_result;
    wire                      adder_cout;

    assign adder_a   = i_alu_src1;
    assign adder_b   = (op_sub | op_slt | op_sltu) ? ~i_alu_src2 : i_alu_src2;  
    assign adder_cin = (op_sub | op_slt | op_sltu) ? 1'b1      : 1'b0;
    assign {adder_cout, adder_result} = adder_a + adder_b + adder_cin;

    // ADD, SUB result
    assign add_sub_result = adder_result;

    // SLT result
    assign slt_result[31:1] = 31'b0;  
    assign slt_result[0]    = (i_alu_src1[31] & ~i_alu_src2[31])
                            | ((i_alu_src1[31] ~^ i_alu_src2[31]) & adder_result[31]);

    // SLTU result
    assign sltu_result[31:1] = 31'b0;
    assign sltu_result[0]    = ~adder_cout;

    // Bitwise operation
    assign nor_result = ~or_result;
    assign and_result = i_alu_src1 & i_alu_src2;
    assign or_result  = i_alu_src1 | i_alu_src2;    
    assign xor_result = i_alu_src1 ^ i_alu_src2;
    assign orn_result = i_alu_src1 | ~i_alu_src2;
    assign andn_result= i_alu_src1 & ~i_alu_src2;

    // SLL result 
    assign sll_result = i_alu_src1 << i_alu_src2[4:0];  

    // SRL, SRA result
    wire [63:0] sr_64_result;
    assign sr_64_result = {{32{op_sra & i_alu_src1[31]}}, i_alu_src1[31:0]} >> i_alu_src2[4:0]; 
    assign sr_result   = sr_64_result[31:0];

    // Lui result
    assign lui_result = i_alu_src2;

    // Final result mux
    assign o_alu_result = ({`LA64_DATA_WIDTH{op_add | op_sub}} & add_sub_result) | 
                          ({`LA64_DATA_WIDTH{op_slt         }} & slt_result    ) | 
                          ({`LA64_DATA_WIDTH{op_sltu        }} & sltu_result   ) | 
                          ({`LA64_DATA_WIDTH{op_nor         }} & nor_result    ) | 
                          ({`LA64_DATA_WIDTH{op_and         }} & and_result    ) | 
                          ({`LA64_DATA_WIDTH{op_or          }} & or_result     ) | 
                          ({`LA64_DATA_WIDTH{op_xor         }} & xor_result    ) | 
                          ({`LA64_DATA_WIDTH{op_orn         }} & orn_result    ) | 
                          ({`LA64_DATA_WIDTH{op_andn        }} & andn_result   ) | 
                          ({`LA64_DATA_WIDTH{op_sll         }} & sll_result    ) | 
                          ({`LA64_DATA_WIDTH{op_srl | op_sra}} & sr_result     ) | 
                          ({`LA64_DATA_WIDTH{op_lui         }} & lui_result    );

endmodule

`default_nettype wire
