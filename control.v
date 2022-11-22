module control(opcode,
	  ctrl_Rwe,
	  ctrl_sw, 
	  ctrl_ALUinB,  
	  ctrl_RI, 
	  ctrl_DMwe, 
	  ctrl_lw,
		 ctrl_Jal, 
		 ctrl_bne, 
		 ctrl_blt, 
		 ctrl_bex, 
		 ctrl_J, 
		 ctrl_Jr, 
		 ctrl_setx
	  );                  
	input [4:0] opcode;
	output ctrl_Rwe,
				ctrl_sw, 
				ctrl_ALUinB, 
				ctrl_RI, 
				ctrl_DMwe, 
				ctrl_lw,
				ctrl_Jal, 
				 ctrl_bne, 
				 ctrl_blt, 
				 ctrl_bex, 
				 ctrl_J, 
				 ctrl_Jr, 
				 ctrl_setx;
				 
	wire rtype, addi, lw, sw, j, bne, jal, jr, blt, bex, setx;
	
 	and Rtype(rtype, ~opcode[4], ~opcode[3], ~opcode[2], ~opcode[1], ~opcode[0]); //00000
	and addi_op(addi, ~opcode[4], ~opcode[3], opcode[2], ~opcode[1], opcode[0]); //00101
	and lw_op(lw, ~opcode[4], opcode[3], ~opcode[2], ~opcode[1], ~opcode[0]); //01000
	and sw_op(sw, ~opcode[4], ~opcode[3], opcode[2], opcode[1], opcode[0]); //00111
	and j_op(j, ~opcode[4], ~opcode[3], ~opcode[2], ~opcode[1], opcode[0]); //00001
	and bne_op(bne,~opcode[4], ~opcode[3], ~opcode[2], opcode[1], ~opcode[0]);//00010
	and jal_op(jal,~opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0]); //00011
	and jr_op(jr, ~opcode[4], ~opcode[3], opcode[2], ~opcode[1], ~opcode[0]); //00100
	and blt_op(blt,~opcode[4], ~opcode[3], opcode[2], opcode[1], ~opcode[0]); //00110
	and bex_op(bex,opcode[4], ~opcode[3], opcode[2], opcode[1], ~opcode[0]); //10110
	and setx_op(setx, opcode[4], ~opcode[3], opcode[2], ~opcode[1], opcode[0]); //10101
	
	
	or RWE(ctrl_Rwe, rtype, addi, lw, jal, setx);
	or set_sw(ctrl_sw, sw, bne, jr, blt);
	or ALUinB(ctrl_ALUinB, addi, lw, sw);
	or RI(ctrl_RI, addi, lw, sw, j, bne, jal, jr, blt, bex, setx); //1 except R type
	assign ctrl_DMWE = sw;
	assign ctrl_lw = lw;
	assign ctrl_jal = jal;
	assign ctrl_bne = bne;
	assign ctrl_blt = blt;
	assign ctrl_bex = bex;
	or set_j(ctrl_J, j, jal);
	assign ctrl_Jr = jr;
	assign ctrl_setx = setx;
	
//   
//			
//	  and DMwe(ctrl_DMwe, ~opcode[4], ~opcode[3], opcode[2], opcode[1], opcode[0]); // only one case (00111) that enables memory write.
//	  assign ctrl_Rwe = ~ctrl_DMwe; // no b or j means only one case (00111) disables register write.
//     and sw(ctrl_sw, ~opcode[4], ~opcode[3], opcode[2], opcode[1], opcode[0]); // sw
//	  or ALUinB(ctrl_ALUinB, opcode[4], opcode[3], opcode[2], opcode[1], opcode[0]); // output 1 unless opcode is 00000.
//	  or RI(ctrl_RI, opcode[4], opcode[3], opcode[2], opcode[1], opcode[0]); // output 1 unless opcode is 00000. 
//	  nor lw(ctrl_lw, opcode[4], ~opcode[3], opcode[2], opcode[1], opcode[0]);
	  
	  
	  
				
endmodule
