module CIM(
    //INPUT
	rst_n,
	clk,
	in_valid,
	weight_valid,
	In_IFM,
	In_Weight,
	// OUTPUT
	out_valid,
	Out_OFM
);

input clk, rst_n, in_valid, weight_valid;
input [0:127]In_IFM; //4bit*32
input [0:127]In_Weight;// 4bit*32

output reg out_valid;
output reg[12:0] Out_OFM;

reg [3:0]IFM [1:32];   //memory array
reg [3:0]Weight[1:32]; //memory array

parameter delay=1;

integer i;
//////////////////
reg clk21;
reg clk22;
reg [1:0]state_cs, state_ns;
// parameter
parameter IDLE = 2'd0;
parameter PRE = 2'd1;
parameter EXE = 2'd2;
parameter ENDS = 2'd3;
reg[12:0] Out_OFM1;
reg[12:0] Out_OFM2;
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		Out_OFM <= 0;
	end
	else
		if (clk21)
			Out_OFM <= Out_OFM1;
		else
			Out_OFM <= Out_OFM2;
end

//Another clock
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		clk21 <= 0;
	end
	else
		clk21 <= !clk21;
end

//Another clock
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		clk22 <= 1;
	end
	else
		clk22 <= !clk22;
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		state_cs <= IDLE;
	else
		state_cs <= state_ns;
end

always@(*) begin
	case(state_cs)
		IDLE: begin
			if(in_valid)
				state_ns = PRE; //start getting data
			else
				state_ns = IDLE; //remain idle
		end

		PRE: begin
			state_ns = EXE;
		end

		EXE: begin
			if(!in_valid)
				state_ns = ENDS; //after the process
			else
				state_ns = EXE; //processing
		end

		ENDS: begin
			state_ns = IDLE;
		end

		default:
			state_ns = IDLE;
	endcase
end

always@(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for(i=1;i<=32;i=i+1)
			IFM[i]<=0;
	end
	else if (in_valid) begin
		for(i=1;i<=32;i=i+1)
			IFM[i]<=In_IFM[0+4*(i-1)+:4];
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for(i=1;i<=32;i=i+1)
			Weight[i] <= 0 ;
	end
	else if (weight_valid) begin
		for(i=1;i<=32;i=i+1)
			Weight[i] <= In_Weight[0+4*(i-1)+:4];
	end
end

always@(posedge clk21) begin
	if (state_ns == EXE || state_ns == ENDS) begin
		Out_OFM1 <= IFM[1]*Weight[1]+
		IFM[2]*Weight[2]+
		IFM[3]*Weight[3]+
		IFM[4]*Weight[4]+
		IFM[5]*Weight[5]+
		IFM[6]*Weight[6]+
		IFM[7]*Weight[7]+
		IFM[8]*Weight[8]+
		IFM[9]*Weight[9]+
		IFM[10]*Weight[10]+
		IFM[11]*Weight[11]+
		IFM[12]*Weight[12]+
		IFM[13]*Weight[13]+
		IFM[14]*Weight[14]+
		IFM[15]*Weight[15]+
		IFM[16]*Weight[16]+
		IFM[17]*Weight[17]+
		IFM[18]*Weight[18]+
		IFM[19]*Weight[19]+
		IFM[20]*Weight[20]+
		IFM[21]*Weight[21]+
		IFM[22]*Weight[22]+
		IFM[23]*Weight[23]+
		IFM[24]*Weight[24]+
		IFM[25]*Weight[25]+
		IFM[26]*Weight[26]+
		IFM[27]*Weight[27]+
		IFM[28]*Weight[28]+
		IFM[29]*Weight[29]+
		IFM[30]*Weight[30]+
		IFM[31]*Weight[31]+
		IFM[32]*Weight[32];
	end
	else
		Out_OFM1 <= 0;
end

always@(posedge clk22) begin
	if (state_ns == EXE || state_ns == ENDS) begin
		Out_OFM2 <= IFM[1]*Weight[1]+
		IFM[2]*Weight[2]+
		IFM[3]*Weight[3]+
		IFM[4]*Weight[4]+
		IFM[5]*Weight[5]+
		IFM[6]*Weight[6]+
		IFM[7]*Weight[7]+
		IFM[8]*Weight[8]+
		IFM[9]*Weight[9]+
		IFM[10]*Weight[10]+
		IFM[11]*Weight[11]+
		IFM[12]*Weight[12]+
		IFM[13]*Weight[13]+
		IFM[14]*Weight[14]+
		IFM[15]*Weight[15]+
		IFM[16]*Weight[16]+
		IFM[17]*Weight[17]+
		IFM[18]*Weight[18]+
		IFM[19]*Weight[19]+
		IFM[20]*Weight[20]+
		IFM[21]*Weight[21]+
		IFM[22]*Weight[22]+
		IFM[23]*Weight[23]+
		IFM[24]*Weight[24]+
		IFM[25]*Weight[25]+
		IFM[26]*Weight[26]+
		IFM[27]*Weight[27]+
		IFM[28]*Weight[28]+
		IFM[29]*Weight[29]+
		IFM[30]*Weight[30]+
		IFM[31]*Weight[31]+
		IFM[32]*Weight[32];
	end	
	else
		Out_OFM2 <= 0;
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		out_valid <=0;
	else if(state_cs == EXE || state_cs == ENDS)
		out_valid <= 1;
	else
		out_valid <= 0;
end

endmodule