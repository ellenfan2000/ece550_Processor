module regfile(
	clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
	data_readRegB
);
	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	output [31:0] data_readRegA, data_readRegB;

	reg[31:0] registers[31:0];
	integer i;
	always @(posedge clock or posedge ctrl_reset)
	begin
		if(ctrl_reset)
			begin
				for(i = 0; i < 32; i = i + 1)
					begin : registers_init
						registers[i] = 32'd0;
					end
			end
		else
			if(ctrl_writeEnable && ctrl_writeReg != 5'd0)
				registers[ctrl_writeReg] = data_writeReg;
	end
	
	assign data_readRegA = ctrl_writeEnable && (ctrl_writeReg == ctrl_readRegA) ? 32'bz : registers[ctrl_readRegA];
	assign data_readRegB = ctrl_writeEnable && (ctrl_writeReg == ctrl_readRegB) ? 32'bz : registers[ctrl_readRegB];
	
endmodule

module regfile_my (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;
	

   /* YOUR CODE HERE */
	
	//write
	wire [31:0] decoder_write,write_enable,out_write;
	decoder de_write (decoder_write, ctrl_writeReg);
	
	genvar i,j;
	generate
	for (i = 0; i < 32; i = i + 1) begin: enable_gen
		and write_enable_i(write_enable[i],decoder_write[i],ctrl_writeEnable);
	end
	endgenerate
	
	/* READ */
	wire [31:0] enable_readA,enable_readB;
	
	decoder de_readA (enable_readA, ctrl_readRegA);
	decoder de_readB (enable_readB, ctrl_readRegB);
	

	/*REGISTERS*/
	//register 0 should always be 0
	assign data_readRegA = enable_readA[0] ? 32'h00000000 : 32'hzzzzzzzz;
	assign data_readRegB = enable_readB[0] ? 32'h00000000 : 32'hzzzzzzzz;
	generate
	for (i = 1; i < 32; i = i + 1) begin: register_gen
		wire [31:0] Q;
		register register (Q,data_writeReg,clock,write_enable[i],ctrl_reset);
		assign data_readRegA = enable_readA[i] ? Q : 32'hzzzzzzzz;
		assign data_readRegB = enable_readB[i] ? Q : 32'hzzzzzzzz;
	end
	endgenerate
	
endmodule


