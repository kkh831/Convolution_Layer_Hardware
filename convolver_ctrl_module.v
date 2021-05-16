module Convoler_ctrl_module(
    input wire CLK,
    input wire RST,
    input wire Load_done,
    input wire whole_done,
//  input wire accum_done,

    output wire Index_start,
    output wire MAC_en,
    output wire ram_wen,
    output wire ram_en,
    output wire eoc
);

  localparam IDLE			=3'd0;
  localparam START		=3'd1;
  localparam ACC0			=3'd2;
  localparam ACC1			=3'd3;
  localparam LOAD			=3'd4;
  localparam SAVE			=3'd5;
  localparam EOC			=3'd6;

  wire [2:0] cur_state;
  reg  [2:0] next_state;
  reg Accum_done;

  reg [3:0] count_9;

  reg Index_start_r;
  reg MAC_en_r;
  reg ram_wen_r;
  reg ram_en_r;
  reg eoc_r;

  assign Index_start 	= Index_start_r;
  assign MAC_en	 	= MAC_en_r;
  assign ram_wen	 	= ram_wen_r;
  assign ram_en		= ram_en_r;
  assign eoc		= eoc_r;


  PipeReg #(3) STATE_FF(
  .CLK(clk),
  .RST(1'b0),
  .EN(1'b1),
  .D(next_state),
  .Q(cur_state)
  );

  Accum_count Accum_count(
  .clk(CLK),
  .rst(RST),
  .en(Load_done),
  .accum_done(accum_done)
  );


  always @(*) begin
      if(!RST) begin
          next_state <= IDLE;
          Index_start_r		<= 0;
          MAC_en_r			<= 0;
          ram_wen_r			<= 0;
          ram_en_r			<= 0;
          eoc_r			<= 0;
      end
      else begin
          case(cur_state)
              IDLE : begin
                  next_state <= START;
                  Index_start_r		<= 0;
                  MAC_en_r		<= 0;
                  ram_wen_r		<= 0;
                  ram_en_r		<= 0;
                  eoc_r			<= 0;
              end
              START : begin
                  if(Load_done == 1) begin
                      next_state <= ACC0;
                      Index_start_r		<= 0;
                      MAC_en_r			<= 1;
                      ram_wen_r			<= 0;
                      ram_en_r			<= 0;
                      eoc_r			<= 0;
                  end
                  else begin
                      next_state <= START;
                      Index_start_r		<= 0;
                      MAC_en_r			<= 0;
                      ram_wen_r			<= 0;
                      ram_en_r			<= 0;
                      eoc_r			<= 0;
                  end
              end
              ACC0 : begin
                  if(Accum_done == 0) begin
                      next_state <= LOAD;
                      Index_start_r		<= 1;
                      MAC_en_r			<= 0;
                      ram_wen_r			<= 0;
                      ram_en_r			<= 0;
                      eoc_r			<= 0;
                  end
                  else begin
                      next_state <= ACC1;
                      Index_start_r		<= 0;
                      MAC_en_r			<= 1;
                      ram_wen_r			<= 0;
                      ram_en_r			<= 0;
                      eoc_r			<= 0;
                  end
              end
              LOAD : begin
                  if(Load_done == 1) begin
                      next_state <= ACC0;
                      Index_start_r		<= 0;
                      MAC_en_r			<= 1;
                      ram_wen_r			<= 0;
                      ram_en_r			<= 0;
                      eoc_r			<= 0;
                  end
                  else begin
                      next_state <= LOAD;
                      Index_start_r		<= 0;
                      MAC_en_r			<= 0;
                      ram_wen_r			<= 0;
                      ram_en_r			<= 0;
                      eoc_r			<= 0;
                  end
              end
              ACC1 : begin
                  next_state <= SAVE;
                  Index_start_r		<= 0;
                  MAC_en_r		<= 0;
                  ram_wen_r		<= 1;
                  ram_en_r		<= 1;
                  eoc_r			<= 0;
              end
              SAVE : begin
                  if(whole_done == 1) begin
                      next_state <= EOC;
                      Index_start_r		<= 0;
                      MAC_en_r			<= 0;
                      ram_wen_r			<= 0;
                      ram_en_r			<= 0;
                      eoc_r			<= 1;
                  end
                  else begin
                      next_state <= START;
                      Index_start_r		<= 1;
                      MAC_en_r			<= 0;
                      ram_wen_r			<= 0;
                      ram_en_r			<= 0;
                      eoc_r			<= 0;
                  end
              end
          endcase
      end
  end

endmodule