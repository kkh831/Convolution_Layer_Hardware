module Accum_count (
input wire rst,
input wire clk,
input wire en,
output wire accum_done
);

reg [3:0] cnt;
reg accum_done_r;

always @ (posedge en) begin
    if(rst == 1) begin
        cnt <= 0;
        accum_done_r <= 0;
    end
    else if (cnt == 8) begin
        cnt <= 0;
        accum_done_r <= 1;
    end
    else begin
        cnt <= cnt + 1;
        accum_done_r <= 0;
    end
end

assign accum_done = accum_done_r;

endmodule
        