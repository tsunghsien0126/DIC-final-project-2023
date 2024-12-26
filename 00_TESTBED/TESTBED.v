`timescale 1ps/1ps

`define clk_PERIOD 220//# the unit of the clk_PERIOD  in here is ns
`define End_CYCLE 10000

`ifdef RTL
`include "../01_RTL/CIM.v"
`elsif GATE
`include "../02_SYN/Netlist/CIM_SYN.v"
`endif

module TESTBED;

reg [3:0] mem [1:1632];
reg [12:0] mem2 [1:50];

reg [3:0] In_Weight[1:32] ;// pattern weight
reg [3:0] In_IFM [1:32]; // pattern in
reg [12:0] Out_OFM_ans; // pattern out

reg weight_valid;
reg in_valid;
reg clk;
reg rst_n;
integer i,j;
wire [12:0]Out_OFM;
wire out_valid;

wire [0:127]In_Weight_all;
wire [0:127]In_IFM_all;

assign In_Weight_all={In_Weight[1], In_Weight[2], In_Weight[3], In_Weight[4], In_Weight[5], In_Weight[6], In_Weight[7], In_Weight[8], In_Weight[9], In_Weight[10], In_Weight[11], In_Weight[12], In_Weight[13], In_Weight[14], In_Weight[15], In_Weight[16], In_Weight[17], In_Weight[18], In_Weight[19], In_Weight[20], In_Weight[21], In_Weight[22], In_Weight[23], In_Weight[24], In_Weight[25], In_Weight[26], In_Weight[27], In_Weight[28], In_Weight[29], In_Weight[30], In_Weight[31], In_Weight[32]};
assign In_IFM_all={In_IFM[1], In_IFM[2], In_IFM[3], In_IFM[4], In_IFM[5], In_IFM[6], In_IFM[7], In_IFM[8], In_IFM[9], In_IFM[10], In_IFM[11], In_IFM[12], In_IFM[13], In_IFM[14], In_IFM[15], In_IFM[16], In_IFM[17], In_IFM[18], In_IFM[19], In_IFM[20], In_IFM[21], In_IFM[22], In_IFM[23], In_IFM[24], In_IFM[25], In_IFM[26], In_IFM[27], In_IFM[28], In_IFM[29], In_IFM[30], In_IFM[31], In_IFM[32]};

initial begin
$readmemb("./indata.txt",mem);
$readmemb("./outdata.txt",mem2);
end
real	CYCLE = `clk_PERIOD;

initial begin
	`ifdef RTL
		$fsdbDumpfile("CIM_v2.fsdb");
		$fsdbDumpvars();
		$fsdbDumpvars(0,"+mda");
	`elsif GATE
		$fsdbDumpfile("CIM_SYN.fsdb");
		//`endif
		$sdf_annotate("CIM_SYN.sdf",u_CIM);   	
		$fsdbDumpvars(0,"+mda");
		$fsdbDumpvars();
	`endif
end

initial begin
	weight_valid=0;
	in_valid=0;
	rst_n=1;
	#(CYCLE)
	rst_n=0;
	#(CYCLE)
	rst_n=1;
	#(CYCLE)
	weight_valid=1;
	for (i=1;i<=32;i=i+1)
	In_Weight[i]=mem[i];
	#(CYCLE) weight_valid=0;
	#(CYCLE)
	
	in_valid=1;
	for(j=1;j<=50;j=j+1) begin
	
		for(i=1;i<=32;i=i+1) begin
		In_IFM[i]=mem[j*32+i];
		end
		Out_OFM_ans=mem2[j];
		#(CYCLE);
	end
	in_valid=0;
	#(CYCLE*20)
	$finish;
end

initial clk=1;
always #(CYCLE/2) clk<=~clk;


CIM u_CIM(
	.rst_n(rst_n),
	.clk(clk),
	.in_valid(in_valid),
	.weight_valid(weight_valid),
	.In_IFM(In_IFM_all),
	.In_Weight(In_Weight_all),
	
	// OUTPUT
	.out_valid(out_valid),
	.Out_OFM(Out_OFM)

);


endmodule
