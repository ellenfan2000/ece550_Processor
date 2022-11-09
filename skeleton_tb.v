// set the timescale <time_unit>/<time_precision>
`timescale 1 ns / 100 ps

module skeleton_tb(); // testbenches take no arguments

	// Regfile
	reg clock, reset;
	wire ctrl_writeEnable;
	wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	wire [31:0] data_writeReg;
	wire [31:0] o_data_readRegA, o_data_readRegB;

	wire imem_clock, dmem_clock, processor_clock, regfile_clock;
	//	 
	wire [11:0] address_imem;
	wire [31:0] q_imem;

		 // Dmem
	wire [11:0] address_dmem;
	wire [31:0] data;
	wire wren;
	wire [31:0] q_dmem;
	
	
	integer i;

	// The test skeleton
	skeleton tests(clock, reset, imem_clock, dmem_clock, processor_clock, regfile_clock,
			  // Imem
			  address_imem,                   // O: The address of the data to get from imem
			  q_imem,                         // I: The data from imem

			  // Dmem
			  address_dmem,                   // O: The address of the data to get or put from/to dmem
			  data,                           // O: The data to write to dmem
			  wren,                           // O: Write enable for dmem
				q_dmem,                         // I: The data from dmem

	//        // Regfile
			  ctrl_writeEnable,               // O: Write enable for regfile
			  ctrl_writeReg,                  // O: Register to write to in regfile
			  ctrl_readRegA,                  // O: Register to read from port A of regfile
			  ctrl_readRegB,                  // O: Register to read from port B of regfile
			  data_writeReg,                  // O: Data to write to for regfile
			  o_data_readRegA,                  // I: Data from port A of regfile
				o_data_readRegB                // I: Data from port B of regfile
	);

	// Begin Simulation
	initial
    begin
        $display($time, " << Starting the Simulation >>");
        clock = 1'b0;    // at time 0
       

        reset = 1'b1;    // assert reset
        @(negedge clock);    // wait until next negative edge of clock
      // wait until next negative edge of clock

        reset = 1'b0;
		  
		  for (i = 0; i < 200; i = i + 1) begin
		  @(negedge clock); 
		  end
		  $stop;
	
    end
	 always 
       	#10 clock = ~clock;

	
endmodule