 module mux_5bit (in0, in1, s, out);
 input [4:0] in0, in1;
 output [4:0] out;
 input s;
 
 assign out = s? in1:in0;

endmodule