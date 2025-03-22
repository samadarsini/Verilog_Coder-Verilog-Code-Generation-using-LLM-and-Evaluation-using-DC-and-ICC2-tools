module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
 
 	output	reg			valid_out,
	output   reg [15:0]	data_out
);

	reg [7:0] data_lock;

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			data_out <= 0;
			valid_out <= 0;
			data_lock <= 0;
		end
		else begin
			if(valid_in) begin
				if(data_lock == 0) begin
					data_lock <= data_in;
				end
				else begin
					data_out <= {data_lock, data_in};
					valid_out <= 1;
					data_lock <= 0;
				end
			end
		end
	end


endmodule