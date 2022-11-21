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
   
			
	  and DMwe(ctrl_DMwe, ~opcode[4], ~opcode[3], opcode[2], opcode[1], opcode[0]); // only one case (00111) that enables memory write.
	  assign ctrl_Rwe = ~ctrl_DMwe; // no b or j means only one case (00111) disables register write.
     and sw(ctrl_sw, ~opcode[4], ~opcode[3], opcode[2], opcode[1], opcode[0]); // sw
	  or ALUinB(ctrl_ALUinB, opcode[4], opcode[3], opcode[2], opcode[1], opcode[0]); // output 1 unless opcode is 00000.
	  or RI(ctrl_RI, opcode[4], opcode[3], opcode[2], opcode[1], opcode[0]); // output 1 unless opcode is 00000. 
	  nor lw(ctrl_lw, opcode[4], ~opcode[3], opcode[2], opcode[1], opcode[0]);
	  
	  
	  
				
endmodule
