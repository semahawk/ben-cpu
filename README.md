# ben-cpu
My lousy attempt at implementing the great [Ben Eater's 8-bit CPU](https://eater.net/8bit) on an FPGA

I'm using the [Mimas V2](https://numato.com/product/mimas-v2-spartan-6-fpga-development-board-with-ddr-sdram) board,
which features a Spartan 6, and I'm using Xilinx's ISE WebPack 14.7, and I'm flashing with
[MimasV2Config.py](https://github.com/numato/samplecode/blob/master/FPGA/MimasV2/tools/configuration/python/MimasV2Config.py) through the serial console (`/dev/ttyACM0` in my case).

### Currently supported instructions:

| Mnemonic | Binary coding | Meaning |
|-|-|-|
| NOP | `0000_xxxx` | Do nothing |
| LDA <addr> | `0001_nnnn` | Load 8-bit value from memory at address `nnnn` into register A |
| ADD <addr> | `0010_nnnn` | Load 8-bit value from memory at address `nnnn` into register B, then add A and B and store result in A |
| SUB <addr> | `0011_nnnn` | Load 8-bit value from memory at address `nnnn` into register B, subtract B from A and store result in A |
| JMP <addr> | `0110_nnnn` | Jump to address `nnnn` |
| JC <addr> | `0111_nnnn` | Jump to address `nnnn` if the result of a ALU operation resulted in overflow (carry) |
| JZ <addr> | `1000_nnnn` | Jump to address `nnnn` if the result of a ALU operation resulted in value `0` |
| LDI <imm> | `0101_nnnn` | Load immediate, 4-bit value `nnnn` into register A |
| OUT | `1110_xxxx` | Push the current bus's state into the OUT register (on my board it goes onto the LEDs) |
| HLT | `1111_xxxx` | Halts the CPU (cannot recover, except by powercycling) |
