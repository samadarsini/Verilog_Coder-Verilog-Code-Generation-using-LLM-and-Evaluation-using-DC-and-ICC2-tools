module multi_pipe_4bit#(
	parameter size = 4
)(
	input 						clk 		,   
	input 						rst_n		,
	input	[size-1:0]			mul_a		,
	input	[size-1:0]			mul_b		,
 
 	output	reg	[size*2-1:0]	mul_out		
);

parameter N = 2 * size;

reg [size-1:0] partial_product [size-1:0];
reg [size*2-1:0] sum;

integer i;

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		sum <= 0;
	end else begin
		sum <= 0;
		for (i = 0; i < size; i = i + 1) begin
			if (mul_b[i] == 1) begin
				partial_product[i] <= {size{1'b0}};
				partial_product[i] <= {partial_product[i], mul_a} << i;
			end else begin
				partial_product[i] <= 0;
			end
			sum <= sum + partial_product[i];
		end
	end
end

assign mul_out = sum;


endmodule