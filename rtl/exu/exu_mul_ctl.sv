`include "constants.vh"

module exu_mul_ctl (
    input  logic                        clk,              
    input  logic                        rst_n,  
    input  logic                        mul_signed,
    input  logic                        mul_low,         
    input  logic [`LA64_DATA_WIDTH-1:0] src1,                
    input  logic [`LA64_DATA_WIDTH-1:0] src2,                  
    output logic [`LA64_DATA_WIDTH-1:0] result  
); 

    // E1
    logic                        mul_signed_e1; 
    logic                        mul_low_e1;         
    logic [`LA64_DATA_WIDTH-1:0] src1_e1;              
    logic [`LA64_DATA_WIDTH-1:0] src2_e1;

    dff #(WIDTH(1'b1            )) u_dff_mul_signed_e1 (.*, .en(), .din(mul_signed), .dout(mul_signed_e1));
    dff #(WIDTH(1'b1            )) u_dff_mul_low_e1    (.*, .en(), .din(mul_low   ), .dout(mul_low_e1   ));   
    dff #(WIDTH(`LA64_DATA_WIDTH)) u_dff_src1_e1       (.*, .en(), .din(src1      ), .dout(src1_e1      ));
    dff #(WIDTH(`LA64_DATA_WIDTH)) u_dff_src2_e1       (.*, .en(), .din(src2      ), .dout(src2_e1      ));

    logic src1_neg_e1;
    logic src2_neg_e1;

    assign src1_neg_e1 =  mul_signed_e1 & src1_e1[31];
    assign src2_neg_e1 =  mul_signed_e1 & src2_e1[31];

    // E2
    logic                        mul_low_e2;         
    logic [`LA64_DATA_WIDTH-1:0] src1_e2;              
    logic [`LA64_DATA_WIDTH-1:0] src2_e2;

    dff #(WIDTH(1'b1              )) u_dff_mul_low_e2 (.*, .en(), .din(mul_low_e1            ), .dout(mul_low_e2   ));   
    dff #(WIDTH(`LA64_DATA_WIDTH+1)) u_dff_src1_e2    (.*, .en(), .din({src1_neg_e1, src1_e1}), .dout(src1_e2      ));
    dff #(WIDTH(`LA64_DATA_WIDTH+1)) u_dff_src2_e2    (.*, .en(), .din({src2_neg_e1, src2_e1}), .dout(src2_e2      ));

    logic signed [(`LA64_DATA_WIDTH+1)*2-1:0] prod_e2;

    assign prod_e2 = src1_e2 * src2_e2;

    // E3

    logic                          mul_low_e3;    
    logic [`LA64_DATA_WIDTH*2-1:0] prod_e3;

    dff #(WIDTH(1'b1              )) u_dff_mul_low_e3 (.*, .en(), .din(mul_low_e2                     ), .dout(mul_low_e3   )); 
    dff #(WIDTH(`LA64_DATA_WIDTH*2)) u_dff_prod_e3    (.*, .en(), .din(prod_e2[`LA64_DATA_WIDTH*2-1:0]), .dout(prod_e3));

    assign result = mul_low_e3 ? prod_e3[`LA64_DATA_WIDTH-1:0]  :  prod_e3[`LA64_DATA_WIDTH+:`LA64_DATA_WIDTH];

endmodule
