module CNT_3(
input wire rst,
input wire clk,
input wire en,
output wire full_3
);
wire [2:0] cur_v;
wire [2:0] next_v;

PipeReg #(3) CNT_FF(
.CLK(clk),
.RST(rst),
.EN(en),
.D(next_v),
.Q(cur_v)
);


assign next_v = cur_v + 3'd1;
assign full_3 = (cur_v == 3'd3-3'd1) ? 1'b1 : 1'b0;

endmodule

module CNT_9(
input wire rst,
input wire clk,
input wire en,
output wire full_9
);
wire [3:0] cur_v;
wire [3:0] next_v;

PipeReg #(4) CNT_FF(
.CLK(clk),
.RST(rst),
.EN(en),
.D(next_v),
.Q(cur_v)
);


assign next_v = cur_v + 4'd1;
assign full_9 = (cur_v == 4'd9-4'd1) ? 1'b1 : 1'b0;

endmodule

module CNT_10(
input wire rst,
input wire clk,
input wire en,
output wire full_10
);
wire [3:0] cur_v;
wire [3:0] next_v;

PipeReg #(4) CNT_FF(
.CLK(clk),
.RST(rst),
.EN(en),
.D(next_v),
.Q(cur_v)
);


assign next_v = cur_v + 4'd1;
assign full_10 = (cur_v == 4'd10-4'd1) ? 1'b1 : 1'b0;

endmodule




module Indexing_module(
    input wire RST,
    input wire CLK,
    input wire Index_start,
    output wire Load_done,
    output wire Whole_done,
    output wire [4:0] IMAGE_RAM_ADDR,
    output wire IMAGE_RAM_EN,
    output wire [4:0] FILTER_RAM_ADDR,
    output wire FILTER_RAM_EN,
    output wire [4:0] FEATURE_RAM_ADDR
);

wire FILTER_RAM_ADDR_rst;
wire FILTER_RAM_ADDR_en;
wire FILTER_RAM_msel;

wire IMAGE_RAM_ADDR_rst;
wire IMAGE_RAM_ADDR_en;
wire [2:0]IMAGE_RAM_msel;

wire CNT_3_rst;
wire CNT_3_en;
wire FULL_3;

wire CNT_9_rst;
wire CNT_9_en;
wire FULL_9;

wire CNT_10_rst;
wire CNT_10_en;
wire FULL_10;
wire LAST_ROW;
wire LAST_CHANNEL;
wire LAST_COL;


FILTER_RAM_ADDR_CNTER_module FILTER_RAM_ADDR_CNTER_module(
//inputs
.CLK(CLK),
.RST(FILTER_RAM_ADDR_rst),
.EN(FILTER_RAM_ADDR_en),
.FILTER_idx_msel(FILTER_RAM_msel),
//outputs
.FILTER_RAM_ADDR(FILTER_RAM_ADDR)
);


IMAGE_RAM_ADDR_CNTER_module IMAGE_RAM_ADDR_CNTER_module(
//inputs
.CLK(CLK),
.RST(IMAGE_RAM_ADDR_rst),
.EN(IMAGE_RAM_ADDR_en),
.IMAGE_idx_msel(IMAGE_RAM_msel),
//outputs
.IMAGE_RAM_ADDR(IMAGE_RAM_ADDR)
);



CNT_3 CNT_3(
//inputs
.rst(CNT_3_rst),
.clk(CLK),
.en(CNT_3_en),
//outputs
.full_3(FULL_3)
);

CNT_9 CNT_9(
//inputs
.rst(CNT_9_rst),
.clk(CLK),
.en(CNT_9_en),
//outputs
.full_9(FULL_9)
);

CNT_10 CNT_10(
//inputs
.rst(CNT_10_rst),
.clk(CLK),
.en(CNT_10_en),
//outputs
.full_10(FULL_10)
);

Coordinate_module Coordinate_module(
//inputs
.IMAGE_RAM_ADDR(IMAGE_RAM_ADDR),
//outputs
.last_channel(LAST_CHANNEL),
.last_row(LAST_ROW),
.last_col(LAST_COL)
);


OFMAP_ADDR_module OFMAP_ADDR_module(
//inputs
.IMAGE_RAM_ADDR(IMAGE_RAM_ADDR),
//outputs
.FEATURE_RAM_ADDR(FEATURE_RAM_ADDR)
);


Indexing_ctrl_module Indexing_ctrl_module(
//inputs
.CLK(CLK),
.RST(RST),
.Index_start(Index_start),
.full_3(FULL_3),
.full_9(FULL_9),
.full_10(FULL_10),
.last_row(LAST_ROW),
.last_col(LAST_COL),
.last_channel(LAST_CHANNEL),
//outputs
.Load_done(Load_done),
.Whole_done(Whole_done),
.FILTER_RAM_ADDR_rst(FILTER_RAM_ADDR_rst),
.FILTER_RAM_ADDR_en(FILTER_RAM_ADDR_en),
.FILTER_RAM_msel(FILTER_RAM_msel),
.IMAGE_RAM_ADDR_rst(IMAGE_RAM_ADDR_rst),
.IMAGE_RAM_ADDR_en(IMAGE_RAM_ADDR_en),
.IMAGE_RAM_msel(IMAGE_RAM_msel),
.cnt_3_rst(CNT_3_rst),
.cnt_3_en(CNT_3_en),
.cnt_9_rst(CNT_9_rst),
.cnt_9_en(CNT_9_en),
.cnt_10_rst(CNT_10_rst),
.cnt_10_en(CNT_10_en),
.FILTER_RAM_EN(FILTER_RAM_EN),
.IMAGE_RAM_EN(IMAGE_RAM_EN)
);


endmodule






