`include "../include/constants.vh"

module deu_gpr_ctl (
   input  logic                        clk,
   input  logic                        rst_n,
                  
   input  logic                        re0,   
   input  logic                        re1,
   input  logic                        re2,
   input  logic                        re3,
    
   input  logic [`LA64_ARF_SEL-1:0]    raddr0, 
   input  logic [`LA64_ARF_SEL-1:0]    raddr1,
   input  logic [`LA64_ARF_SEL-1:0]    raddr2,
   input  logic [`LA64_ARF_SEL-1:0]    raddr3, 
   
   output logic [`LA64_DATA_WIDTH-1:0] rdata0,  
   output logic [`LA64_DATA_WIDTH-1:0] rdata1,
   output logic [`LA64_DATA_WIDTH-1:0] rdata2,
   output logic [`LA64_DATA_WIDTH-1:0] rdata3,

   input  logic                        we0,         
   input  logic                        we1, 
   input  logic                        we2,
    
   input  logic [`LA64_ARF_SEL-1:0]    waddr0,  
   input  logic [`LA64_ARF_SEL-1:0]    waddr1, 
   input  logic [`LA64_ARF_SEL-1:0]    waddr2, 
 
   input  logic [`LA64_DATA_WIDTH-1:0] wdata0,    
   input  logic [`LA64_DATA_WIDTH-1:0] wdata1,
   input  logic [`LA64_DATA_WIDTH-1:0] wdata2  
);

   logic [`LA64_ARF_NUM-1:1]                        w0v,w1v,w2v; 
   logic [`LA64_ARF_NUM-1:1]                        gpr_we;
   logic [`LA64_ARF_NUM-1:1] [`LA64_DATA_WIDTH-1:0] gpr_in;  
   logic [`LA64_ARF_NUM-1:1] [`LA64_DATA_WIDTH-1:0] gpr_out;   

   for (genvar i=1; i<32; i++ ) begin : gpr
      dffe #(WIDTH(`LA64_DATA_WIDTH)) u_dffe_gpr (.*, .en(gpr_we[i]), .din(gpr_in[i]), .dout(gpr_out[i]));
   end : gpr
   
   always_comb begin
      rdata0 = 32'b0;
      rdata1 = 32'b0;
      rdata2 = 32'b0;
      rdata3 = 32'b0;   
      gpr_in[31:1] = 'd0;
      // Gpr read
      for (int i=1; i<32; i++)  begin
         rdata0 |= ({32{re0 & (raddr0 == 5'(i))}} & gpr_out[i]);
         rdata1 |= ({32{re1 & (raddr1 == 5'(i))}} & gpr_out[i]);
         rdata2 |= ({32{re2 & (raddr2 == 5'(i))}} & gpr_out[i]);
         rdata3 |= ({32{re3 & (raddr3 == 5'(i))}} & gpr_out[i]); 
      end 
      // Gpr write
      for (int i=1; i<32; i++)  begin
         w0v[i]     = we0 & (waddr0 == 5'(i));
         w1v[i]     = we1 & (waddr1 == 5'(i));
         w2v[i]     = we2 & (waddr2 == 5'(i));
         gpr_in[i]  = ({32{w0v[i]}} & wdata0) | ({32{w1v[i]}} & wdata1) | ({32{w2v[i]}} & wdata2);    
      end	 
   end 

   assign gpr_we[31:1] = (w0v[31:1] | w1v[31:1] | w2v[31:1]);

endmodule
