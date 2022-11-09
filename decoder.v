module decoder(out, in);

input[4:0] in;
output[31:0] out;

wire [3:0] en;

decoder_4b enable(en,in[4:3]);

decoder_8b out0 (out[7:0],in[2:0],en[0]);
decoder_8b out8 (out[15:8],in[2:0],en[1]);
decoder_8b out16 (out[23:16],in[2:0],en[2]);
decoder_8b out24 (out[31:24],in[2:0],en[3]);

endmodule

module decoder_8b(out,in,en);

input en;
input[2:0] in;
output[7:0] out;

and out7(out[7],in[0],in[1],in[2],en);
and out6(out[6],in[2],in[1],~in[0],en);
and out5(out[5],in[2],~in[1],in[0],en);
and out4(out[4],in[2],~in[1],~in[0],en);
and out3(out[3],~in[2],in[1],in[0],en);
and out2(out[2],~in[2],in[1],~in[0],en);
and out1(out[1],~in[2],~in[1],in[0],en);
and out0(out[0],~in[2],~in[1],~in[0],en);

endmodule

module decoder_4b(out,in);

input[1:0] in;
output[3:0] out;


and out3(out[3],in[1],in[0]);
and out2(out[2],in[1],~in[0]);
and out1(out[1],~in[1],in[0]);
and out0(out[0],~in[1],~in[0]);

endmodule
