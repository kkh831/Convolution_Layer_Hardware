module Convolver(
    input wire clk,
    input wire resetn,
    input wire signed [7:0] IMAGE_RAM_DIN,
    input wire signed [7:0] FILTER_RAM_DIN,
    input wire signed [15:0] FEATURE_RAM_DIN,
    input wire IMAGE_RAM_DATA_VAL,
    input wire FILTER_RAM_DATA_VAL,
    input wire FEATURE_RAM_DATA_VAL,    

    output wire IMAGE_RAM_EN,
    output wire FILTER_RAM_EN,
    output wire FEATURE_RAM_EN,
    output wire FEATURE_RAM_WEN,
    
    output wire [4:0] IMAGE_RAM_ADDRESS,
    output wire [4:0] FILTER_RAM_ADDRESS,
    output wire [4:0] FEATURE_RAM_ADDRESS,
    
    output wire signed [15:0] FEATURE_RAM_DOUT,
    output wire eoc

);
  wire Load_done;
  wire whole_done;
  wire index_start;
  wire MAC_en;

  wire IMAGE_RAM_EN_r;
  wire FILTER_RAM_EN_r;
  wire FEATURE_RAM_EN_r;
  wire FEATURE_RAM_WEN_r;
  wire [4:0] IMAGE_RAM_ADDRESS_r;
  wire [4:0] FILTER_RAM_ADDRESS_r;
  wire [4:0] FEATURE_RAM_ADDRESS_r;
  wire signed [15:0] FEATURE_RAM_DOUT_r;
  wire eoc_r;

  assign IMAGE_RAM_EN = IMAGE_RAM_EN_r;
  assign FILTER_RAM_EN = FILTER_RAM_EN_r;
  assign FEATURE_RAM_EN = FEATURE_RAM_EN_r;
  assign FEATURE_RAM_WEN = FEATURE_RAM_WEN_r;
  assign IMAGE_RAM_ADDRESS = IMAGE_RAM_ADDRESS_r;
  assign FILTER_RAM_ADDRESS = FILTER_RAM_ADDRESS_r;
  assign FEATURE_RAM_ADDRESS = FEATURE_RAM_ADDRESS_r;
  assign FEATURE_RAM_DOUT = FEATURE_RAM_DOUT_r;
  assign eoc = eoc_r;
  

  Convoler_ctrl_module Convoler_ctrl_module(
  .CLK(clk),
  .RST(!resetn),
  .Load_done(Load_done),
  .whole_done(whole_done),
  .Index_start(index_start),
  .MAC_en(MAC_en),
  .ram_wen(FEATURE_RAM_WEN_r),
  .ram_en(FEATURE_RAM_EN_r),
  .eoc(eoc_r)
  );

  Indexing_module Indexing_module(
  .RST(resetn),
  .CLK(clk),
  .Index_start(index_start),
  .Load_done(Load_done),
  .Whole_done(whole_done),
  .IMAGE_RAM_ADDR(IMAGE_RAM_ADDRESS_r),
  .IMAGE_RAM_EN(IMAGE_RAM_EN_r),
  .FILTER_RAM_ADDR(FILTER_RAM_ADDRESS_r),
  .FILTER_RAM_EN(FILTER_RAM_EN_r),
  .FEATURE_RAM_ADDR(FEATURE_RAM_ADDRESS_r)
  );

  MAC #(8) MAC (
  .CLK(clk),
  .RSTN(resetn),
  .EN(MAC_en),
  .IFMAP_DATA_IN(IMAGE_RAM_DIN),
  .FILTER_DATA_IN(FILTER_RAM_DIN),
  .MUL_DATA_OUT(FEATURE_RAM_DOUT_r)
  );


			

endmodule
