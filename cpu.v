//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:49:20 09/19/2018 
// Design Name: 
// Module Name:    cpu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`define STAGE_T0 0
`define STAGE_T1 1
`define STAGE_T2 2
`define STAGE_T3 3
`define STAGE_T4 4

`define OP_NOP 4'b0000
`define OP_LDI 4'b0101
`define OP_OUT 4'b1110
`define OP_HLT 4'b1111

module cpu (
    input i_clk,
    input i_rst,
    output wire [7:0] o_out
);

    localparam AI  =  0; // reg A in
    localparam AO  =  1; // reg A out
    localparam BI  =  2; // reg B in
    localparam BO  =  3; // reg B out
    localparam II  =  4; // instruction reg in
    localparam IO  =  5; // instruction reg out
    localparam OI  =  6; // output register in
    localparam OO  =  7; // output register out
    localparam RI  =  8; // memory (ROM) in
    localparam RO  =  9; // memory (ROM) out
    localparam J   = 10; // program counter in (jump)
    localparam CO  = 11; // program counter out
    localparam CE  = 12; // enable counting

    reg [15:0] ctrl = 0;
    reg halted = 0;
    reg [3:0] stage = 0;
    reg [7:0] instr_reg = 0;
    wire [3:0] opcode = instr_reg[7:4];
    tri [7:0] bus;
    reg [7:0] out = 0;

    assign o_out = out;

    register a (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_load(ctrl[AI]),
        .i_enable(ctrl[AO]),
        .i_only_lower(1'b0),
        .i_D(bus),
        .o_Q(bus)
    );

    register b (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_load(ctrl[BI]),
        .i_enable(ctrl[BO]),
        .i_only_lower(1'b0),
        .i_D(bus),
        .o_Q(bus)
    );

    register instr (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_load(ctrl[II]),
        .i_enable(ctrl[IO]),
        .i_only_lower(ctrl[IO]),
        .i_D(bus),
        .o_Q(bus)
    );

    counter pc (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_load(ctrl[J]),
        .i_enable(ctrl[CO]),
        .i_count(ctrl[CE]),
        .i_bus(bus[3:0]),
        .o_bus(bus[3:0])
    );

    rom rom (
        .i_clk(i_clk),
        .i_enable(ctrl[RO]),
        .i_addr(bus[3:0]),
        .o_instr(bus)
    );

    always @ (posedge i_clk or negedge i_rst) begin
        if (~i_rst) begin
            ctrl <= 0;
            stage <= `STAGE_T0;
            halted <= 0;
            out <= 0;
        end else if (halted) begin
            // nop
        end else begin // ~i_rst
            ctrl <= 0;

            case (stage)
                `STAGE_T0: begin
                    ctrl <= (1 << CO) | (1 << RI);
                    stage <= `STAGE_T1;
                end
                `STAGE_T1: begin
                    ctrl <= (1 << RO) | (1 << II);
                    stage <= `STAGE_T2;
                end // `STAGE_T1
                `STAGE_T2: begin
                    ctrl <= (1 << CE);
                    instr_reg <= bus;
                    stage <= `STAGE_T3;
                end // `STAGE_T2
                `STAGE_T3: begin
                    case (opcode)
                        `OP_NOP: begin
                            stage <= `STAGE_T0;
                        end
                        `OP_LDI: begin
                            ctrl <= (1 << AI) | (1 << IO);
                            stage <= `STAGE_T4;
                        end
                        `OP_OUT: begin
                            ctrl <= (1 << AO) | (1 << OI);
                            stage <= `STAGE_T4;
                        end
                        `OP_HLT: begin
                            halted <= 1;
                            stage <= `STAGE_T0; // doesn't really matter but hey
                        end
                        default: begin
                            $display("WARNING: unknown opcode: %b", opcode);
                            stage <= `STAGE_T0;
                        end
                    endcase
                end // `STAGE_T3
                `STAGE_T4: begin
                    case (opcode)
                        `OP_LDI: begin
                            stage <= `STAGE_T0;
                        end
                        `OP_OUT: begin
                            out <= bus;
                            stage <= `STAGE_T0;
                        end
                        default: begin
                            $display("WARNING: unknown opcode: %b", opcode);
                            stage <= `STAGE_T0;
                        end
                    endcase
                end // `STAGE_T4
            endcase
        end // i_rst
    end

endmodule
