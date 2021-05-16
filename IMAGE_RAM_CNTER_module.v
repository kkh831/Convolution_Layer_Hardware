module IMAGE_RAM_ADDR_CNTER_module(
    //inputs
    input wire CLK,
    input wire RST,
    input wire EN,
    input wire [2:0]IMAGE_idx_msel,
    
    output wire [4:0] IMAGE_RAM_ADDR
);
    localparam IFMAP_W = 5;
    localparam FILTER_W = 3;
    localparam STRIDE = 1;

    wire [4:0] cur_addr;
    reg [4:0] next_addr;
    wire [4:0] bias0;
    wire [4:0] bias1;
    wire [4:0] bias2;
    wire [4:0] bias3;

    assign IMAGE_RAM_ADDR = cur_addr;

    PipeReg #(5) ADDR_FF(
    .CLK(CLK),
    .RST(RST),
    .EN(EN),
    .D(next_addr),
    .Q(cur_addr)
    );

    assign bias0 = 5'd1;
    assign bias1 = IFMAP_W - (FILTER_W-1);
    assign bias2 = -((FILTER_W-1)*(IFMAP_W)+(FILTER_W-1-STRIDE));
    assign bias3 = -((FILTER_W-2)*(IFMAP_W)+(IFMAP_W-1));

    always@(*) begin
        case(IMAGE_idx_msel)
           0 : begin
            next_addr <= bias0 + cur_addr;
            end
           1 : begin
            next_addr <= bias1 + cur_addr;
            end
           2 : begin
            next_addr <= bias2 + cur_addr;
           end
           3 : begin
            next_addr <= bias3 + cur_addr;
            end
         endcase
    end



endmodule




