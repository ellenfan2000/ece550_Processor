module d30 (overflow, opcode, aluopcode, d30_out);
	input [4:0] opcode, aluopcode;
	input overflow;
	output [31:0] d30_out;

	genvar i;
	generate
	for(i = 2;i < 32; i = i + 1) begin: gen
	assign d30_out[i] = 1'b0;
	end
	endgenerate

or bit1(d30_out[1],aluopcode[0], opcode[0]);
not bit0(d30_out[0],opcode[0]);
//	and bit0(d30_out[0], ~aluopcode[0], overflow);
//	wire b1;
//	or temp(b1, aluopcode[0], opcode[0]);
//	and bit1(d30_out[1], b1, overflow);

endmodule