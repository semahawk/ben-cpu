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
`define STAGE_T5 5

`define OP_NOP 4'b0000
`define OP_LDA 4'b0001
`define OP_ADD 4'b0010
`define OP_SUB 4'b0011
`define OP_LDI 4'b0101
`define OP_JMP 4'b0110
`define OP_JC  4'b0111
`define OP_JZ  4'b1000
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
    localparam EO  = 13; // ALU result out
    localparam SU  = 14; // subtract signal for the ALU
    localparam FI  = 15; // flags register in

    // meaning of bits in the flags register
    localparam FL_C = 1; // ALU result overflown (carry)
    localparam FL_Z = 0; // ALU result equal to 0

    reg [15:0] ctrl = 0;
    reg halted = 0;
    reg [3:0] stage = 0;
    reg [7:0] instr_reg = 0;
    wire [3:0] opcode = instr_reg[7:4];
    tri [7:0] bus;
    reg [7:0] out = 0;

    assign o_out = out;

    wire [7:0] reg_a_direct, reg_b_direct;
    // these are outputs from the ALU, inputs to the flags register
    wire alu_out_carry, alu_out_zero;
    // this is the direct output of the flags register
    // ie. it doesn't need to go onto the bus
    wire [7:0] flags_direct;

    register a (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_load(ctrl[AI]),
        .i_enable(ctrl[AO]),
        .i_only_lower(1'b0),
        .i_D(bus),
        .o_Q(bus),
        .o_direct(reg_a_direct)
    );

    register b (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_load(ctrl[BI]),
        .i_enable(ctrl[BO]),
        .i_only_lower(1'b0),
        .i_D(bus),
        .o_Q(bus),
        .o_direct(reg_b_direct)
    );

    register instr (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_load(ctrl[II]),
        .i_enable(ctrl[IO]),
        .i_only_lower(ctrl[IO]),
        .i_D(bus),
        .o_Q(bus),
        .o_direct(/* nc */)
    );

    register flags (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_load(ctrl[FI]),
        .i_enable(1'b0),
        .i_only_lower(1'b0),
        .i_D({ 6'b0, alu_out_carry, alu_out_zero }),
        .o_Q(/* nc */),
        .o_direct(flags_direct)
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

    alu alu (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_enable(ctrl[EO]),
        .i_subtract(ctrl[SU]),
        .i_reg_a(reg_a_direct),
        .i_reg_b(reg_b_direct),
        .o_carry(alu_out_carry),
        .o_zero(alu_out_zero),
        .o_result(bus)
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
                        `OP_LDA: begin
                            ctrl <= (1 << RI) | (1 << IO);
                            stage <= `STAGE_T4;
                        end
                        `OP_LDI: begin
                            ctrl <= (1 << AI) | (1 << IO);
                            stage <= `STAGE_T4;
                        end
                        `OP_ADD: begin
                            ctrl <= (1 << RI) | (1 << IO);
                            stage <= `STAGE_T4;
                        end
                        `OP_SUB: begin
                            ctrl <= (1 << RI) | (1 << IO);
                            stage <= `STAGE_T4;
                        end
                        `OP_JMP: begin
                            ctrl <= (1 << IO) | (1 << J);
                            stage <= `STAGE_T0;
                        end
                        `OP_JC: begin
                            if (flags_direct[FL_C]) begin
                                ctrl <= (1 << IO) | (1 << J);
                            end else begin
                                ctrl <= 0;
                            end

                            stage <= `STAGE_T0;
                        end
                        `OP_JZ: begin
                            if (flags_direct[FL_Z]) begin
                                ctrl <= (1 << IO) | (1 << J);
                            end else begin
                                ctrl <= 0;
                            end

                            stage <= `STAGE_T0;
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
                        `OP_LDA: begin
                            ctrl <= (1 << RO) | (1 << AI);
                            stage <= `STAGE_T0;
                        end
                        `OP_LDI: begin
                            stage <= `STAGE_T0;
                        end
                        `OP_ADD: begin
                            ctrl <= (1 << RO) | (1 << BI);
                            stage <= `STAGE_T5;
                        end
                        `OP_SUB: begin
                            ctrl <= (1 << RO) | (1 << BI);
                            stage <= `STAGE_T5;
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
                `STAGE_T5: begin
                    case (opcode)
                        `OP_ADD: begin
                            ctrl <= (1 << EO) | (1 << AI) | (1 << FI);
                            stage <= `STAGE_T0;
                        end
                        `OP_SUB: begin
                            ctrl <= (1 << EO) | (1 << AI) | (1 << SU) | (1 << FI);
                            stage <= `STAGE_T0;
                        end
                        default: begin
                            $display("WARNING: unknown opcode: %b", opcode);
                            stage <= `STAGE_T0;
                        end
                    endcase
                end // `STAGE_T5
            endcase
        end // i_rst
    end

endmodule
