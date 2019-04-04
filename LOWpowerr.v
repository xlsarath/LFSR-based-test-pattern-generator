`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:41:26 06/19/2012 
// Design Name: 
// Module Name:    LOWpowerr 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module lfsr_lp(clk,rst,lfsrout);
input rst,clk; 
output reg [35:0]lfsrout;

reg [35:0]lfsr_reg,R_inj;

reg [2:0]curr_state,next_state;

reg [1:0]en,sel;

parameter RESET = 3'b000;
parameter Ti = 3'b001;
parameter Tk1 = 3'b010;
parameter Tk2 = 3'b011;
parameter Tk3 = 3'b100;

reg [5:0] i,j;


//Current state logic
always@(posedge rst or posedge clk)
begin
	if(rst)
	begin
		curr_state <= RESET;
		//lfsr_reg <= 36'b010010100101101011010010100101101011;
	end
	else
	begin
		curr_state <= next_state;
		//lfsr_reg <= 
	end
end

//lfsr's lower half operation with gated clk
always @(posedge rst or posedge en[0])
begin
	if(rst)
	begin
		lfsr_reg[17:0] <= 18'b010010100101101011;
	end
	else
	begin
		lfsr_reg[17:1] <= lfsr_reg [16:0];
		lfsr_reg[0] <= lfsr_reg[35]^lfsr_reg[33]^lfsr_reg[31]^lfsr_reg[25]^lfsr_reg[22]^lfsr_reg[21]^lfsr_reg[15]^lfsr_reg[11]^lfsr_reg[10]^lfsr_reg[09]^lfsr_reg[07]^lfsr_reg[06]^lfsr_reg[04]^lfsr_reg[03]^lfsr_reg[01]^lfsr_reg[00];
	end
end

//lfsr's upper half operation with gated clk
always@(posedge rst or posedge en[1])
begin
	if(rst)
	begin
		lfsr_reg[35:18] <= 18'b010010100101101011;
	end
	else
		lfsr_reg[35:18] <= lfsr_reg[34:17];
end



//next state decoder logic
always@(curr_state,rst)
begin
	if(rst)
	begin
		en = 2'b00;
		sel = 2'b00;
		next_state = Ti;
	end
	else
	begin
		case(curr_state)
			Ti:
			begin
				en = 2'b01;
				sel = 2'b11;
				next_state = Tk1;
			end
			Tk1:
			begin
				en = 2'b00;
				sel = 2'b01;
				next_state = Tk2;
			end
			Tk2:
			begin
				en = 2'b10;
				sel = 2'b11;
				next_state = Tk3;
			end
			Tk3:
			begin
				en = 2'b00;
				sel = 2'b10;
				next_state = Ti;
			end
		endcase
	end
end


//Random Injector R_inj output generations
always@(lfsr_reg)
begin
	R_inj[0] =  lfsr_reg[35]^lfsr_reg[33]^lfsr_reg[31]^lfsr_reg[25]^lfsr_reg[22]^lfsr_reg[21]^lfsr_reg[15]^lfsr_reg[11]^lfsr_reg[10]^lfsr_reg[09]^lfsr_reg[07]^lfsr_reg[06]^lfsr_reg[04]^lfsr_reg[03]^lfsr_reg[01]^lfsr_reg[00];
	for(i=1;i<=6'd35;i=i+1'b1)
	begin
		if(lfsr_reg[35] == 1'b1)
		begin
			R_inj[i] = lfsr_reg[i] & lfsr_reg[i-1'b1];
		end
		else
		begin
			R_inj[i] = lfsr_reg[i] | lfsr_reg[i-1'b1];
		end
	end
end


//output decoder block
always@(sel,R_inj,lfsr_reg)
begin
	for(j=6'd0;j<6'd18;j=j+1'b1)
	begin
		if(sel[0] == 1'b1)
		begin
			lfsrout[j] = lfsr_reg[j];
		end
		else
		begin
			lfsrout[j] = R_inj[j];
		end
	end


	for(j=6'd18;j<6'd36;j=j+1'b1)
	begin
		if(sel[1] == 1'b1)
		begin
			lfsrout[j] = lfsr_reg[j];
		end
		else
		begin
			lfsrout[j] = R_inj[j];
		end
	end
end

endmodule

		


		



