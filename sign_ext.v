module sign_ext(in, out);
input [16:0] in;
output [31:0] out;

genvar i;
generate
for(i = 17;i < 32; i = i + 1) begin: gen
assign out[i] = in[16];
end
endgenerate

genvar j;
generate
for(i = 0; i < 17; i = i + 1) begin: gen2
assign out[i] = in[i];
end
endgenerate

endmodule

module sign_ext26(in,out);

input [26:0] in;
output [31:0] out;

genvar i;
generate
for(i = 27;i < 32; i = i + 1) begin: gen
assign out[i] = in[26];
end
endgenerate

genvar j;
generate
for(i = 0; i < 27; i = i + 1) begin: gen2
assign out[i] = in[i];
end
endgenerate

endmodule
