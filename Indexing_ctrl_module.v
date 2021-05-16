module Indexing_ctrl_module(
    //inputs
    input wire CLK,
    input wire RST,
    input wire Index_start,
    input wire full_3,
    input wire full_9,
    input wire full_10,
    input wire last_row,
    input wire last_col,
    input wire last_channel,
    //outputs
    output wire Load_done,
    output wire Whole_done,
    output wire FILTER_RAM_ADDR_rst,
    output wire FILTER_RAM_ADDR_en,
    output wire FILTER_RAM_msel,
    output wire IMAGE_RAM_ADDR_rst,
    output wire IMAGE_RAM_ADDR_en,
    output wire [2:0] IMAGE_RAM_msel,
    output wire cnt_3_rst,
    output wire cnt_3_en,
    output wire cnt_9_rst,
    output wire cnt_9_en,
    output wire cnt_10_rst,
    output wire cnt_10_en,
    
    output wire FILTER_RAM_EN,
    output wire IMAGE_RAM_EN
);
    localparam IDLE                 = 4'd0;
    localparam START                = 4'd1;
    localparam FILTER_ROW_SHIFT     = 4'd2;
    localparam FILTER_COL_SHIFT     = 4'd3;
    localparam OFMAP_ROW_SHIFT      = 4'd4;
    localparam OFMAP_COL_SHIFT      = 4'd5;
    localparam CHANNEL_SHIFT        = 4'd6;
    localparam CNT_10               = 4'd7;
    localparam LOAD_DONE            = 4'd8;
    localparam WHOLE_DONE           = 4'd9;

    wire [3:0] cur_state;
    reg [3:0] next_state;
    
    //wire state_reset;

    // inside regs
    //
    reg Load_done_r;
    reg Whole_done_r;
    reg FILTER_RAM_ADDR_rst_r;
    reg FILTER_RAM_ADDR_en_r;
    reg FILTER_RAM_msel_r;
    reg IMAGE_RAM_ADDR_rst_r;
    reg IMAGE_RAM_ADDR_en_r;
    reg [2:0] IMAGE_RAM_msel_r;
    reg FILTER_RAM_EN_r;
    reg IMAGE_RAM_EN_r;

    reg cnt_3_rst_r;
    reg cnt_3_en_r;
    reg cnt_9_rst_r;
    reg cnt_9_en_r;
    reg cnt_10_rst_r;
    reg cnt_10_en_r;
    //output signal
    //
    assign Load_done    =          Load_done_r;
    assign Whole_done   =          Whole_done_r;

    assign FILTER_RAM_ADDR_rst = FILTER_RAM_ADDR_rst_r;
    assign FILTER_RAM_ADDR_en = FILTER_RAM_ADDR_en_r;
    assign FILTER_RAM_msel  =   FILTER_RAM_msel_r;
    assign IMAGE_RAM_ADDR_rst = IMAGE_RAM_ADDR_rst_r;
    assign IMAGE_RAM_ADDR_en = IMAGE_RAM_ADDR_en_r;
    assign IMAGE_RAM_msel =  IMAGE_RAM_msel_r;
    assign FILTER_RAM_EN = FILTER_RAM_EN_r;
    assign IMAGE_RAM_EN = IMAGE_RAM_EN_r;

    assign cnt_3_rst = cnt_3_rst_r;
    assign cnt_3_en = cnt_3_en_r;
    assign cnt_9_rst = cnt_9_rst_r;
    assign cnt_9_en = cnt_9_en_r;
    assign cnt_10_rst = cnt_10_rst_r;
    assign cnt_10_en = cnt_10_en_r;

    PipeReg #(4) STATE_FF(
    .CLK(CLK),
    .RST(1'b0),
    .EN(1'b1),
    .D(next_state),
    .Q(cur_state)
    );


    //FSM
    always @ (*)begin
        if(RST) begin
            next_state <= IDLE;
            //output signals
            Load_done_r <= 0;
            Whole_done_r <= 0;
            FILTER_RAM_ADDR_rst_r <= 1;
            FILTER_RAM_ADDR_en_r <= 0;
            FILTER_RAM_msel_r <= 0;
            IMAGE_RAM_ADDR_rst_r <= 1;
            IMAGE_RAM_ADDR_en_r <= 0;
            IMAGE_RAM_msel_r <=0;
            FILTER_RAM_EN_r <= 0;
            IMAGE_RAM_EN_r <= 0;
            cnt_3_rst_r <= 1;
            cnt_3_en_r <= 0;
            cnt_9_rst_r <= 1;
            cnt_9_en_r <= 0;
            cnt_10_rst_r <= 1;
            cnt_10_en_r <= 0;
        end
        else begin
            case(cur_state)
                IDLE : begin
                    if (Index_start == 1'b1) begin
                        next_state <= START;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                    else if(Index_start ==1'b0) begin
                        next_state <= IDLE;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 1;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 1;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 1;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 1;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 1;
                        cnt_10_en_r <= 0;
                    end
                end
                START : begin
                    next_state <= CNT_10;
                    //output signals
                    Load_done_r <= 0;
                    Whole_done_r <= 0;
                    FILTER_RAM_ADDR_rst_r <= 0;
                    FILTER_RAM_ADDR_en_r <= 0;
                    FILTER_RAM_msel_r <= 0;
                    IMAGE_RAM_ADDR_rst_r <= 0;
                    IMAGE_RAM_ADDR_en_r <= 0;
                    IMAGE_RAM_msel_r <=0;
                    FILTER_RAM_EN_r <= 1;
                    IMAGE_RAM_EN_r <= 1;
                    cnt_3_rst_r <= 0;
                    cnt_3_en_r <= 0;
                    cnt_9_rst_r <= 0;
                    cnt_9_en_r <= 0;
                    cnt_10_rst_r <= 0;
                    cnt_10_en_r <= 1;
                end
                LOAD_DONE : begin
                //START : begin
                    casex({full_3,full_9,last_row,last_col,last_channel})
                    5'b1_1_1_1_1 : begin
                    //if ({full_3,full_9,last_row,last_col,last_channel} == 5'b1_1_1_1_1) begin
                        next_state <= WHOLE_DONE;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 1;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                    5'b1_1_1_1_0 : begin
                    //else if ({full_3,full_9,last_row,last_col,last_channel} == 5'b1_1_1_1_0) begin
                        next_state <= CHANNEL_SHIFT;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 1;
                        FILTER_RAM_msel_r <= 1;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 1;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 1;
                        cnt_3_en_r <= 1;
                        cnt_9_rst_r <= 1;
                        cnt_9_en_r <= 1;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                    5'b1_1_1_0_x : begin
                    //else if({full_3,full_9,last_row,last_col,last_channel} == 5'b1_1_1_0_x) begin
                        next_state <= OFMAP_COL_SHIFT;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 1;
                        FILTER_RAM_msel_r <= 1;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 1;
                        IMAGE_RAM_msel_r <=3;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 1;
                        cnt_3_en_r <= 1;
                        cnt_9_rst_r <= 1;
                        cnt_9_en_r <= 1;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                    5'b1_1_0_x_x : begin
                    //else if({full_3,full_9,last_row,last_col,last_channel} == 5'b1_1_0_x_x) begin
                        next_state <= OFMAP_ROW_SHIFT;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 1;
                        FILTER_RAM_msel_r <= 1;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 1;
                        IMAGE_RAM_msel_r <=2;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 1;
                        cnt_3_en_r <= 1;
                        cnt_9_rst_r <= 1;
                        cnt_9_en_r <= 1;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                    5'b1_0_x_x_x : begin
                    //else if({full_3,full_9,last_row,last_col,last_channel} == 5'b1_0_x_x_x) begin
                        next_state <= FILTER_COL_SHIFT;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 1;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 1;
                        IMAGE_RAM_msel_r <=1;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 1;
                        cnt_3_en_r <= 1;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 1;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                    5'b0_x_x_x_x : begin
                    //else if({full_3,full_9,last_row,last_col,last_channel} == 5'b0_x_x_x_x) begin
                        next_state <= FILTER_ROW_SHIFT;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 1;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 1;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 1;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 1;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                    endcase
                end
                CHANNEL_SHIFT : begin
                    if(Index_start == 1'b1) begin
                        next_state <= START;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                    else if(Index_start ==1'b0) begin
                        next_state <= CHANNEL_SHIFT;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                end
                OFMAP_COL_SHIFT : begin
                    if(Index_start == 1'b1) begin
                        next_state <= START;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                    else if(Index_start ==1'b0) begin
                        next_state <= OFMAP_COL_SHIFT;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                end
                OFMAP_ROW_SHIFT : begin
                    if(Index_start == 1'b1) begin
                        next_state <= START;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                    else if(Index_start ==1'b0) begin
                        next_state <= OFMAP_ROW_SHIFT;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                end
                FILTER_COL_SHIFT : begin
                    if(Index_start == 1'b1) begin
                        next_state <= START;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                    else if(Index_start ==1'b0) begin
                        next_state <= FILTER_COL_SHIFT;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                end
                FILTER_ROW_SHIFT : begin
                    if(Index_start == 1'b1) begin
                        next_state <= START;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                    else if(Index_start ==1'b0) begin
                        next_state <= FILTER_ROW_SHIFT;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 0;
                        IMAGE_RAM_EN_r <= 0;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 0;
                    end
                end
                CNT_10 : begin
                    if (full_10 == 1'b1) begin
                        next_state <= LOAD_DONE;
                        //output signals
                        Load_done_r <= 1;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 1;
                        IMAGE_RAM_EN_r <= 1;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 1;
                        cnt_10_en_r <= 0;
                    end
                    else if (full_10 == 1'b0) begin
                        next_state <= CNT_10;
                        //output signals
                        Load_done_r <= 0;
                        Whole_done_r <= 0;
                        FILTER_RAM_ADDR_rst_r <= 0;
                        FILTER_RAM_ADDR_en_r <= 0;
                        FILTER_RAM_msel_r <= 0;
                        IMAGE_RAM_ADDR_rst_r <= 0;
                        IMAGE_RAM_ADDR_en_r <= 0;
                        IMAGE_RAM_msel_r <=0;
                        FILTER_RAM_EN_r <= 1;
                        IMAGE_RAM_EN_r <= 1;
                        cnt_3_rst_r <= 0;
                        cnt_3_en_r <= 0;
                        cnt_9_rst_r <= 0;
                        cnt_9_en_r <= 0;
                        cnt_10_rst_r <= 0;
                        cnt_10_en_r <= 1;
                    end
                end
                WHOLE_DONE : begin
                    next_state <= WHOLE_DONE;
                    //output signals
                    Load_done_r <= 0;
                    Whole_done_r <= 1;
                    FILTER_RAM_ADDR_rst_r <= 0;
                    FILTER_RAM_ADDR_en_r <= 0;
                    FILTER_RAM_msel_r <= 0;
                    IMAGE_RAM_ADDR_rst_r <= 0;
                    IMAGE_RAM_ADDR_en_r <= 0;
                    IMAGE_RAM_msel_r <=0;
                    FILTER_RAM_EN_r <= 0;
                    IMAGE_RAM_EN_r <= 0;
                    cnt_3_rst_r <= 0;
                    cnt_3_en_r <= 0;
                    cnt_9_rst_r <= 0;
                    cnt_9_en_r <= 0;
                    cnt_10_rst_r <= 0;
                    cnt_10_en_r <= 0;
                end
            endcase
        end // else end
    end // always end 



endmodule
