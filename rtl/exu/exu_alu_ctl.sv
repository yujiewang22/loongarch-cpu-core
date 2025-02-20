`include "constants.vh"

module exu_alu_ctl (
    input  logic                        clk,              
    input  logic                        rst_n,  
    input  logic [`ALU_OP_WIDTH-1:0]    alu_op,
    input  logic [`LA64_DATA_WIDTH-1:0] src1,
    input  logic [`LA64_DATA_WIDTH-1:0] src2,
    output logic [`LA64_DATA_WIDTH-1:0] result
);

    logic [`ALU_OP_WIDTH-1:0]    alu_op_ff;
    logic [`LA64_DATA_WIDTH-1:0] src1_ff;
    logic [`LA64_DATA_WIDTH-1:0] src2_ff;

    dffe #(WIDTH(`ALU_OP_WIDTH   )) u_dffe_alu_op_ff (.*, .en(), .din(alu_op), .dout(alu_op_ff));
    dffe #(WIDTH(`LA64_DATA_WIDTH)) u_dffe_src1_ff   (.*, .en(), .din(src1  ), .dout(src1_ff  ));
    dffe #(WIDTH(`LA64_DATA_WIDTH)) u_dffe_src2_ff   (.*, .en(), .din(src2  ), .dout(src2_ff  ));

    logic op_add;
    logic op_sub;
    logic op_slt;
    logic op_sltu;
    logic op_nor;
    logic op_and;
    logic op_or;
    logic op_xor;
    logic op_orn;
    logic op_andn;
    logic op_sll;
    logic op_srl;
    logic op_sra;
    logic op_lui;

    logic [`LA64_DATA_WIDTH-1:0] add_sub_result;
    logic [`LA64_DATA_WIDTH-1:0] slt_result;  
    logic [`LA64_DATA_WIDTH-1:0] sltu_result;
    logic [`LA64_DATA_WIDTH-1:0] nor_result;
    logic [`LA64_DATA_WIDTH-1:0] and_result;  
    logic [`LA64_DATA_WIDTH-1:0] or_result;  
    logic [`LA64_DATA_WIDTH-1:0] xor_result;  
    logic [`LA64_DATA_WIDTH-1:0] orn_result;  
    logic [`LA64_DATA_WIDTH-1:0] andn_result;
    logic [`LA64_DATA_WIDTH-1:0] sll_result;
    logic [`LA64_DATA_WIDTH-1:0] sr_result;
    logic [`LA64_DATA_WIDTH-1:0] lui_result;

    // Adder
    logic [`LA64_DATA_WIDTH:0] adder_a;
    logic [`LA64_DATA_WIDTH:0] adder_b;
    logic                      adder_cin;
    logic [`LA64_DATA_WIDTH:0] adder_result;
    logic                      adder_cout;
    
    assign op_add  = alu_op_ff[ 0];
    assign op_sub  = alu_op_ff[ 1];
    assign op_slt  = alu_op_ff[ 2];
    assign op_sltu = alu_op_ff[ 3];
    assign op_nor  = alu_op_ff[ 4];
    assign op_and  = alu_op_ff[ 5];
    assign op_or   = alu_op_ff[ 6];
    assign op_xor  = alu_op_ff[ 7];
    assign op_orn  = alu_op_ff[ 8];
    assign op_andn = alu_op_ff[ 9];
    assign op_sll  = alu_op_ff[10];
    assign op_srl  = alu_op_ff[11];
    assign op_sra  = alu_op_ff[12];
    assign op_lui  = alu_op_ff[13]; 
    
    assign adder_a   = src1_ff;
    assign adder_b   = (op_sub | op_slt | op_sltu) ? ~src2_ff : src2_ff;  
    assign adder_cin = (op_sub | op_slt | op_sltu) ? 1'b1      : 1'b0;
    assign {adder_cout, adder_result} = adder_a + adder_b + adder_cin;

    // ADD, SUB result
    assign add_sub_result = adder_result;

    // SLT result
    assign slt_result[31:1] = 31'b0;  
    assign slt_result[0]    = (src1_ff[31] & ~src2_ff[31])
                            | ((src1_ff[31] ~^ src2_ff[31]) & adder_result[31]);

    // SLTU result
    assign sltu_result[31:1] = 31'b0;
    assign sltu_result[0]    = ~adder_cout;

    // Bitwise operation
    assign nor_result = ~or_result;
    assign and_result = src1_ff & src2_ff;
    assign or_result  = src1_ff | src2_ff;    
    assign xor_result = src1_ff ^ src2_ff;
    assign orn_result = src1_ff | ~src2_ff;
    assign andn_result= src1_ff & ~src2_ff;

    // SLL result 
    assign sll_result = src1_ff << src2_ff[4:0];  

    // SRL, SRA result
    logic [63:0] sr_64_result;
    assign sr_64_result = {{32{op_sra & src1_ff[31]}}, src1_ff[31:0]} >> src2_ff[4:0]; 
    assign sr_result   = sr_64_result[31:0];

    // Lui result
    assign lui_result = src2_ff;

    // Final result mux
    assign result = ({`LA64_DATA_WIDTH{op_add | op_sub}} & add_sub_result) | 
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
