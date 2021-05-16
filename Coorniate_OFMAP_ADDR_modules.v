module OFMAP_ADDR_module(
    //inputs
    input wire [4:0] IMAGE_RAM_ADDR,
    //outputs
    output wire [4:0] FEATURE_RAM_ADDR
);

localparam IFMAP_H = 5;
localparam IFMAP_W = 5;
localparam FILTER_W = 3;

wire [4:0] feature_addr_temp;

assign feature_addr_temp = (IMAGE_RAM_ADDR%(IFMAP_W*IFMAP_H)) - (FILTER_W-1)*(IFMAP_W+1);

assign FEATURE_RAM_ADDR = feature_addr_temp - ((feature_addr_temp/IFMAP_W)*2);


endmodule




module Coordinate_module(
input wire [4:0] IMAGE_RAM_ADDR,

output wire last_channel,
output wire last_row,
output wire last_col
);

localparam IFMAP_H = 5;
localparam IFMAP_W = 5;
localparam IFMAP_C = 1;

wire [3:0] col;
wire [3:0] row;
wire [3:0] channel;

wire [4:0] IF_SIZE;
wire [4:0] IF_LOC;
assign IF_SIZE = IFMAP_H*IFMAP_W;
assign IF_LOC = IMAGE_RAM_ADDR%IF_SIZE;

assign col = IF_LOC/IFMAP_W;
assign row = IF_LOC%IFMAP_W;
assign channel = IMAGE_RAM_ADDR/IF_SIZE;
//assign col = (IMAGE_RAM_ADDR%(IFMAP_H*IFMAP_W))/IFMAP_W);
//assign row = (IMAGE_RAM_ADDR%(IFMAP_H*IFMAP_W))%IFMAP_W);
//assign channel = (IMAGE_RAM_ADDR/(IFMAP_H*IFMAP_W));


assign last_channel = (channel==(IFMAP_C-1)) ? 1'b1 : 1'b0;
assign last_col = (col==(IFMAP_H-1)) ? 1'b1 : 1'b0;
assign last_row = (row==(IFMAP_W-1)) ? 1'b1 : 1'b0;

endmodule
