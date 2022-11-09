// set the timescale <time_unit>/<time_precision>
`timescale 1 ns / 100 ps

module skeleton_tb(); // testbenches take no arguments

// Regfile
reg reset, ctrl_writeEnable;
reg [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
reg [31:0] data_writeReg;
wire [31:0] data_readRegA, data_readRegB;

reg imem_clock, dmem_clock, processor_clock, regfile_clock;
//	 
reg [11:0] address_imem;
reg [31:0] q_imem;

    // Dmem
reg [11:0] address_dmem;
reg [31:0] data;
reg wren;
reg [31:0] q_dmem;
reg clock;
reg proc_done;
reg test;

integer num_correct;		// Number of tests that pass
integer curr_test_num;		// Current test
integer clock_count;		// How many times the clock has flipped
integer clock_count_max;	// How many clock cycles to run

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
       o_data_readRegB                   // I: Data from port B of regfile
);

// Begin Simulation
initial begin
	num_correct = 0;
	curr_test_num = 1;
	clock_count = 0;
	clock_count_max = 1000;
	proc_done = 0;
	reset = 0;
	test = 0;
	
	$display("@ece550:test:start");
	clock = 1'b0;
end


// When proc_done is set high, run this code
always @(posedge proc_done) begin
		
	// Set write enable to 0 so that the testbench never writes to the regfile
	ctrl_writeEnable = 0;

	// Set test to 1 so that the skeleton file feeds testbench inputs into the regfile
	test = 1;

	/* 
		After all the insns finished, you will want to check the register file's content.
		You can add more checks according to your test cases
	*/
	check_register("addi r1",1,65535);

	$display("@ece550:test:end");
	$stop;
		
end


// Always increment the clock, and set proc_done when we reach clock_count_max
always begin
	#20 clock = ~clock; 
	clock_count = clock_count + 1;
	if (clock_count == clock_count_max * 2)
		proc_done = 1;
end
	
	
// Task to check that register 'read_reg' has the value 'value'
// If it was correct, increment the number of correct values
task check_register;
	input [8*15:1] test_name;	// The name of the test
	input [4:0] read_reg;		// The register to check
	input [31:0] value;			// The value that should be in the register
	
	begin
	
		ctrl_readRegA = read_reg;
		
		@(negedge clock);
		if (data_readRegA == value) begin
			$display("@ece550:test:start");
			$display(
				"@ece550:test:data { \"name\": \"Test %d\", \"status\": \"PASS\", \"data\": { \"time\": \"%t\", \"testname\": \"%s\", \"expected\": \"%3d\", \"actual\": \"%3d\" } }",
				curr_test_num,
				$time,
				test_name,
				value,
				t_data_readRegA
			);
			$display("@ece550:test:end");
			num_correct = num_correct + 1;
		end else begin
			$display("@ece550:test:start");
			$display(
				"@ece550:test:data { \"name\": \"Test %d\", \"status\": \"FAIL\", \"data\": { \"time\": \"%t\", \"testname\": \"%s\", \"expected\": \"%3d\", \"actual\": \"%3d\" } }",
				curr_test_num,
				$time,
				test_name,
				value,
				t_data_readRegA
			);
			$display("@ece550:test:end");
		end
		
		curr_test_num = curr_test_num + 1;
	end
endtask
	
endmodule