module FILTER_RAM_ADDR_CNTER_module(
    //inputs
    input wire CLK,
    input wire RST,
    input wire EN,
    input wire FILTER_idx_msel,
    
    output wire [4:0] FILTER_RAM_ADDR
);
    wire [4:0] cur_addr;
    reg [4:0] next_addr;
    wire [4:0] bias0;
    wire [4:0] bias1;

    assign FILTER_RAM_ADDR = cur_addr;

    PipeReg #(5) ADDR_FF(
    .CLK(CLK),
    .RST(RST),
    .EN(EN),
    .D(next_addr),
    .Q(cur_addr)
    );

    assign bias0 = 5'd1;
    assign bias1 = 5'd0;

    always@(*) begin
        case(FILTER_idx_msel)
           0 : begin
            next_addr <= bias0 + cur_addr;
            end
           1 : begin
            next_addr <= bias1;
            end
         endcase
    end



endmodule




