//----------------------------------------------------------------------
//	TB: FftTop Testbench
//----------------------------------------------------------------------
`timescale	1ns/1ns
module TB;

reg 		clock;
reg 		reset;
reg 		di_en;
reg [13:0]	di_re;
reg [13:0]	di_im;
wire		do_en;
wire[13:0]	do_re;
wire[13:0]	do_im;

reg [13:0]	imem[0:127];
reg [13:0]	omem[0:127];

reg [31:0] clk_counter; // for debugging

//----------------------------------------------------------------------
//	Clock and Reset
//----------------------------------------------------------------------
always begin
	clock = 0; #10;
	clock = 1; #10;
end

initial begin
	reset = 0; #20;
	reset = 1; #1215752192;
	reset = 0;
end

//----------------------------------------------------------------------
//	Functional Blocks
//----------------------------------------------------------------------

//	Input Control Initialize
initial begin
	wait (reset == 1);
	di_en = 0;
end

//	Output Data Capture
initial begin : OCAP
	integer 	n;
	forever begin
		n = 0;
		while (do_en !== 1) @(negedge clock);
		while ((do_en == 1) && (n < 64)) begin
			omem[2*n  ] = do_re;
			omem[2*n+1] = do_im;
			n = n + 1;
			@(negedge clock);
		end
	end
end

always @(posedge clock or negedge reset) begin
	if(!reset) begin
		clk_counter <= 0;
	end
	else begin
		clk_counter <= clk_counter +1;
		if (clk_counter%71==0) begin
			$display("clk_counter=%d, omem", clk_counter);
		end
	end
end

//----------------------------------------------------------------------
//	Tasks
//----------------------------------------------------------------------
task LoadInputData;
	input[80*8:1]	filename;
begin
	$readmemb(filename, imem);
end
endtask

task GenerateInputWave;
	integer n;
begin
	di_en <= 1;
	for (n = 0; n < 64; n = n + 1) begin
		di_re <= imem[2*n];
		di_im <= imem[2*n+1];
		@(posedge clock);
	end
	di_en <= 0;
	di_re <= 'bx;
	di_im <= 'bx;
end
endtask

task SaveOutputData;
	input[80*8:1]	filename;
	integer 		fp, n, m;
begin
	fp = $fopen(filename);
	m = 0;
	for (n = 0; n < 64; n = n + 1) begin
		m[5] = n[0];
		m[4] = n[1];
		m[3] = n[2];
		m[2] = n[3];
		m[1] = n[4];
		m[0] = n[5];
		$fdisplay(fp, "%h  %h  // %d", omem[2*m], omem[2*m+1], n[5:0]);
	end
	$fclose(fp);
end
endtask

//----------------------------------------------------------------------
//	Module Instances
//----------------------------------------------------------------------
FFT FFT (
	.clock	(clock	),	//	i
	.reset	(reset	),	//	i
	.di_en	(di_en	),	//	i
	.di_re	(di_re	),	//	i
	.di_im	(di_im	),	//	i
	.do_en	(do_en	),	//	o
	.do_re	(do_re	),	//	o
	.do_im	(do_im	)	//	o
);

//----------------------------------------------------------------------
//	Include Stimuli
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//	Test Stimuli
//----------------------------------------------------------------------
initial begin : STIM
	wait (reset == 1);
	// wait (reset == 0);
	repeat(10) @(posedge clock);

	fork
		begin
			LoadInputData("input4.txt");
			GenerateInputWave;
			@(posedge clock);
			// LoadInputData("input5.txt");
			// GenerateInputWave;
		end
		begin
			wait (do_en == 1);
			repeat(64) @(posedge clock);
			SaveOutputData("output4.txt");
			@(negedge clock);
			wait (do_en == 1);
			// repeat(64) @(posedge clock);
			// SaveOutputData("output5.txt");
		end
	join

	repeat(10) @(posedge clock);
	$finish;
end
initial begin : TIMEOUT
	repeat(1215752192) #20;	//  1000 Clock Cycle Time
	$display("[FAILED] Simulation timed out.");
	$finish;
end

endmodule
