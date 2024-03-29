module clock_divider (clk, rst, out_clk);
output reg out_clk;
input clk;
input rst;

always @(posedge clk or posedge rst)
begin
if (rst == 1'b1)
     out_clk <= 1'b0;
else
     out_clk <= ~out_clk;

end
endmodule