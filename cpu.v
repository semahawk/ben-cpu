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
`define OP_LDA 4'b0001
`define OP_OUT 4'b1110
`define OP_HLT 4'b1111

module cpu (
    input i_clk,
    input i_rst,
    output wire [7:0] o_out
);

    localparam AI  = 0; // reg A in
    localparam AO  = 1; // reg A out
    localparam II  = 2; // instruction reg in
    localparam IO  = 3; // instruction reg out
    localparam IIO = 4; // instruction reg imm (low 4 bits) out
    localparam OI  = 5; // output register in
    localparam OO  = 6; // output register out
    localparam MI  = 7; // memory (ROM) in
    localparam MO  = 8; // memory (ROM) out

    reg [3:0] pc = 0; // program counter
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

    register instr (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_load(ctrl[II]),
        .i_enable(ctrl[IO]),
        .i_only_lower(ctrl[IIO]),
        .i_D(bus),
        .o_Q(bus)
    );

    rom rom (
        .i_clk(i_clk),
        .i_enable(ctrl[MO]),
        .i_addr(pc),
        .o_instr(bus)
    );

    always @ (posedge i_clk or negedge i_rst) begin
        if (halted) begin
            // nop
        end else if (~i_rst) begin
            pc <= 0;
            ctrl <= 0;
            stage <= `STAGE_T0;
        end else begin // ~i_rst
            ctrl <= 0;

            case (stage)
                `STAGE_T0: begin
                    ctrl <= (1 << MO) | (1 << II);
                    stage <= `STAGE_T1;
                end // `STAGE_T0
                `STAGE_T1: begin
                    instr_reg <= bus;
                    stage <= `STAGE_T2;
                    pc <= pc + 1;
                end // `STAGE_T1
                `STAGE_T2: begin
                    case (opcode)
                        `OP_NOP: begin
                            stage <= `STAGE_T0;
                        end
                        `OP_LDA: begin
                            ctrl <= (1 << AI) | (1 << IO) | (1 << IIO);
                            stage <= `STAGE_T3;
                        end
                        `OP_OUT: begin
                            ctrl <= (1 << AO) | (1 << OI);
                            stage <= `STAGE_T3;
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
                end // `STAGE_T2
                `STAGE_T3: begin
                    case (opcode)
                        `OP_LDA: begin
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
                end
            endcase
        end // i_rst
    end

endmodule
