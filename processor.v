/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                 // I: Data from port B of regfile
	 
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;
	 

    /* All controls */
	 wire ctrl_sw, ctrl_ALUinB,  ctrl_RI, ctrl_DMwe, ctrl_lw, ctrl_Jal, 
	 ctrl_bne, ctrl_blt, ctrl_bex, ctrl_J, ctrl_Jr, ctrl_setx; 
	 
	 control ctrl(q_imem[31: 27], ctrl_writeEnable, ctrl_sw, ctrl_ALUinB,  ctrl_RI, ctrl_DMwe, ctrl_lw,
	 ctrl_Jal, ctrl_bne, ctrl_blt, ctrl_bex, ctrl_J, ctrl_Jr, ctrl_setx);

	 //PC and imem
	 wire [31:0] PC, PCnext, PCplus1;
	 wire dontcare, dontcareeither, alsodontcare;
	 
	 //J type stuffs
	 
	 
	 register PCReg_read(PC, PCnext, clock, 1'b1, reset);
	 alu PCplus(PC, 32'd1,5'b00000, 5'b00000, PCplus1, dontcare, dontcareeither, alsodontcare);

	 
	 assign address_imem = PC[11:0];
	 
	 //31:27 opcode
	 //26:22 rd
	 //21:17 rs
	 //16:12 rt
	 //11:7 shamt
	 //6:2 ALUOP
	 //16:0 immediate

	 
	 
	 //register and ALU 
	 assign ctrl_readRegA = q_imem[21:17];
	 
	 //read_regB
	 wire [31:0] ReadB_temp;	 
	 assign ReadB_temp = ctrl_sw? q_imem[26:22]: q_imem[16:12];
	 
	 assign ctrl_readRegB = ctrl_bex? 5'b11110:ReadB_temp;
	 
	
	 wire [31:0] imme, ALUin1, ALUin2, ALUout;
	 sign_ext sx_I(q_imem[16:0], imme);
	
	 assign ALUin1 = ctrl_ALUinB? imme: data_readRegB;
	 assign ALUin2 = ctrl_bex ? 32'b0:data_readRegA;
	 wire isNotEqual, isLessThan, overflow; 
	
	 
	 wire [4:0] aluop;
	 
	 assign aluop = ctrl_RI? 5'b0: q_imem[6:2];
	 
	 //main ALU
	 alu ALU(ALUin2, ALUin1, aluop, q_imem[11:7], ALUout, isNotEqual, isLessThan, overflow);
	 
	 
	 //PCnext
	 wire [31:0] PCplus1plusN, PCbranch, PCBJ;
	 wire dontcare2, dontcareeither2, alsodontcare2;
	 alu PC1N(PCplus1, imme, 5'b00000,5'b00000,PCplus1plusN,dontcare2, dontcareeither2, alsodontcare2);
	
	
	 wire bne_ctrl, blt_ctrl, ctrl_branch;
	 and bne(bne_ctrl, isNotEqual, ctrl_bne);
	 and blt(blt_ctrl, isLessThan, ctrl_blt);
	 or branch(ctrl_branch, bne_ctrl, blt_ctrl);
	 assign PCbranch = ctrl_branch? PCplus1plusN:PCplus1;
	 
	 wire bex_ctrl, J_ctrl;
	 wire [31:0] target;
	 sign_ext26 sx_t(q_imem[26:0], target);
	 
	 and bex(bex_ctrl, ctrl_bex, isNotEqual);
	 or Jtype(J_ctrl, ctrl_J, bex_ctrl);
	 assign PCBJ = J_ctrl? target:PCbranch;
	 
	 assign PCnext = ctrl_Jr? data_readRegB : PCBJ;
	 
	 
	 
	 //data write to PC
	 
	 assign wren = ctrl_DMwe;
	 assign address_dmem = ALUout[11:0];
	 assign data = data_readRegB;
	 
	 wire [31:0] Regwrite_temp, r30_out, write_jal, write_setx;
	 wire ctrl_overflow;
	 	 
	 assign Regwrite_temp = ctrl_lw?q_dmem:ALUout;
	 assign write_jal = ctrl_Jal? PCplus1: Regwrite_temp;
	 assign write_setx = ctrl_setx? target: write_jal;
	 
	 d30 d30out(overflow, q_imem[31:27], aluop, r30_out, ctrl_overflow);
	 
	 assign data_writeReg = ctrl_overflow? r30_out: write_setx;
	 
	 wire[4:0] writeReg_temp;
	 
	 wire ctrl_r30;
	 
	// mux_5bit Rw(q_imem[26:22], 5'b11110, ctrl_overflow, ctrl_writeReg);
	 or R30contr(ctrl_r30, ctrl_overflow, ctrl_setx);
	 
	 assign writeReg_temp = ctrl_r30? 5'b11110:q_imem[26:22];
	 
	 assign ctrl_writeReg = ctrl_Jal? 5'b11111:writeReg_temp;
	 
	 
endmodule
