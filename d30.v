//module d30 (overflow, opcode, aluopcode, d30_out,ctrl_overflow);
//	input [4:0] opcode, aluopcode;
//	input overflow;
//	output [31:0] d30_out;
//	output ctrl_overflow;
//
//	genvar i;
//	generate
//	for(i = 2;i < 32; i = i + 1) begin: gen
//	assign d30_out[i] = 1'b0;
//	end
//	endgenerate
//
////or bit1(d30_out[1],aluopcode[0], opcode[0]);
////not bit0(d30_out[0],opcode[0]);
//	and bit0(d30_out[0], ~aluopcode[0], overflow);
//	wire b1;
//	or temp(b1, aluopcode[0], opcode[0]);
//	and bit1(d30_out[1], b1, overflow);
//
//
//wire add, addi, sub;
//and add_ct(add, ~opcode[4], ~opcode[3], ~opcode[2], ~opcode[1], ~opcode[0], ~aluopcode[4], ~aluopcode[3], ~aluopcode[2], ~aluopcode[1], ~aluopcode[0]);
//and addi_ct(addi, ~opcode[4], ~opcode[3], opcode[2], ~opcode[1], opcode[0]);
//and sub_ct(sub, ~opcode[4], ~opcode[3], ~opcode[2], ~opcode[1], ~opcode[0], ~aluopcode[4], ~aluopcode[3], ~aluopcode[2], ~aluopcode[1], aluopcode[0]);
//
//or tempall(temp_all, add, addi, sub);
//and out_over(ctrl_overflow, overflow, temp_all);
//
//endmodule

module d30 (overflow, opcode, aluopcode, d30_out, ctrl_overflow);
 input [4:0] opcode, aluopcode;
 input overflow;
 output [31:0] d30_out;
 output ctrl_overflow;

 genvar i;
 generate
 for(i = 2;i < 32; i = i + 1) begin: gen
 assign d30_out[i] = 1'b0;
 end
 endgenerate

//or bit1(d30_out[1],aluopcode[0], opcode[0]);
//not bit0(d30_out[0],opcode[0]);
// and bit0(d30_out[0], ~aluopcode[0], overflow);
// wire b1;
// or temp(b1, aluopcode[0], opcode[0]);
// and bit1(d30_out[1], b1, overflow);





wire add, addi, sub;
and add_ct(add, ~opcode[4], ~opcode[3], ~opcode[2], ~opcode[1], ~opcode[0], ~aluopcode[4], ~aluopcode[3], ~aluopcode[2], ~aluopcode[1], ~aluopcode[0]);
and addi_ct(addi, ~opcode[4], ~opcode[3], opcode[2], ~opcode[1], opcode[0], ~aluopcode[4], ~aluopcode[3], ~aluopcode[2], ~aluopcode[1], ~aluopcode[0]);
and sub_ct(sub, ~opcode[4], ~opcode[3], ~opcode[2], ~opcode[1], ~opcode[0], ~aluopcode[4], ~aluopcode[3], ~aluopcode[2], ~aluopcode[1], aluopcode[0]);

or addiorsub(d30_out[1], addi, sub);
or dddedd(d30_out[0], add, sub);

or tempall(temp_all, add, addi, sub);
and out_over(ctrl_overflow, overflow, temp_all);

endmodule