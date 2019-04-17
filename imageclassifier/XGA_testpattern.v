module XGA_testpattern(
    input  wire       CLOCK_50,
    input  wire [3:0] KEY,
	input  wire [9:0] SW,
    output wire [7:0] VGA_R,
    output wire [7:0] VGA_G,
    output wire [7:0] VGA_B,
    output wire       VGA_CLK,
    output wire       VGA_BLANK_N,
    output wire       VGA_SYNC_N,
    output wire       VGA_HS,
    output wire       VGA_VS,
	 output [9:0] LEDR
	 );
	
	//---------- load train/test memory ------------------
	reg [23:0] banana0 [2560:0];
	reg [23:0] banana1 [2560:0];
	reg [23:0] banana2 [2560:0];
	reg [23:0] banana3 [2560:0];
	reg [23:0] banana4 [2560:0];
	reg [23:0] banana5 [2560:0];
	reg [23:0] apple0 [2560:0];
	reg [23:0] apple1 [2560:0];
	reg [23:0] apple2 [2560:0];
	reg [23:0] apple3 [2560:0];
	reg [23:0] apple4 [2560:0];
	reg [23:0] apple5 [2560:0];
	
	initial
	begin 
		$readmemh("banana0.txt",banana0);
		$readmemh("banana1.txt",banana1);
		$readmemh("banana2.txt",banana2);
		$readmemh("banana3.txt",banana3);
		$readmemh("banana4.txt",banana4);
		$readmemh("banana5.txt",banana5);
		$readmemh("apple0.txt",apple0);
		$readmemh("apple1.txt",apple1);
		$readmemh("apple2.txt",apple2);
		$readmemh("apple3.txt",apple3);
		$readmemh("apple4.txt",apple4);
		$readmemh("apple5.txt",apple5);
	end
	

	
	//---------- VGA clock gen-----------------
	wire reset;
	wire locked; //do nothing
	
	assign reset = ~KEY[0]; 
	
	clockgen gen( CLOCK_50, reset, VGA_CLK, locked);
	testclock test( reset, VGA_CLK, LEDR);
	
	//----------VGA sync gen------------------
	wire inDisplayArea;
	assign VGA_BLANK_N = inDisplayArea;
	
	wire [10:0] X;
   wire [9:0] Y;
	sync syngen(VGA_CLK, VGA_HS, VGA_VS, inDisplayArea, X, Y);
	
	//set color
	wire[23:0] color; 	
	assign color = (X < 64 && Y < 40)? banana0[Y*64 + X]: 24'b0;
	assign VGA_R =  color[23:16];
	assign VGA_G =  color[15:8];
	assign VGA_B =  color[7:0];
	
	
endmodule
