module register(out, in, clk, en, clr);


input[31:0] in;
input clr, clk, en;
wire clr;


output [31:0] out;



	genvar i;
	generate
	for(i = 0;i < 32; i = i + 1) begin: dffe
		dffe_ref dffe (out[i], in[i], clk, en, clr);

	end
	endgenerate


endmodule