 module mux_32bit (in0, in1, s, out);
 input [31:0] in0, in1;
 output [31:0] out;
 input s;
 
 assign out = s? in1:in0;
 
// wire s_bar;
// wire [31:0] temp0, temp1; 
// not n_s(s_bar, s);
//
//
//genvar i;
//generate
//for(i = 0;i < 32; i = i + 1) begin: gen
//  and A(temp0[i], in0[i], s_bar);
//  and B(temp1[i], in1[i], s);
//  or C(out[i], temp0[i], temp1[i]);
//end
//endgenerate

endmodule