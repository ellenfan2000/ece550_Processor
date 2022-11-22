// set the timescale <time_unit>/<time_precision>
`timescale 1 ns / 100 ps

module processor_tb(); // testbenches take no arguments

	// Control signals
    reg clock, reset;

    // Imem
    wire [11:0] address_imem;
    reg [31:0] q_imem;

    // Dmem
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire wren;
    reg [31:0] q_dmem;

    // Regfile
    wire ctrl_writeEnable;
    wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    reg [31:0] data_readRegA, data_readRegB;
	
	
	integer i;

	processor test(
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
    data_readRegB 
);
	// Begin Simulation
	initial
    begin
        $display($time, " << Starting the Simulation >>");
        clock = 1'b0;    // at time 0
       
        reset = 1'b1;    // assert reset
		  #50

        reset = 1'b0;
		  q_imem = 32'b00000000000000000000000000000000;
		  #50
		  
		  q_imem = 32'b00101000010000000000000000000101;
		  #50
		  
		  q_imem = 32'b00101000100000000000000000000011;
		  #50
		  
		  q_imem = 32'b00000000110000100010000000000000;
		  #50
		  
		  q_imem = 32'b00000001000000100010000000000100;
		  #50
		  
//		  for (i = 0; i < 200; i = i + 1) begin
//		  @(negedge clock); 
//		  end
		  $stop;
	
    end
	 always 
       	#10 clock = ~clock;

	
endmodule