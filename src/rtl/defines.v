
// ALU_OP {instr[30], func3}
`define ALU_OP_ADD      4'b0000
`define ALU_OP_SUB      4'b1000
`define ALU_OP_SLL      4'b0001
`define ALU_OP_SLT      4'b0010
`define ALU_OP_SLTU     4'b0011
`define ALU_OP_XOR      4'b0100
`define ALU_OP_SRL      4'b0101
`define ALU_OP_SRA      4'b1101
`define ALU_OP_OR       4'b0110
`define ALU_OP_AND      4'b0111

`define ALU_OP_EQ       4'b1001
`define ALU_OP_NEQ      4'b1010
`define ALU_OP_GE       4'b1100
`define ALU_OP_GEU      4'b1011

`define ALU_OP_XXX      4'b1111


`define BEQ_FUNCT3      3'b000
`define BNE_FUNCT3      3'b001
`define BLT_FUNCT3      3'b100
`define BGE_FUNCT3      3'b101
`define BLTU_FUNCT3     3'b110
`define BGEU_FUNCT3     3'b111

`define OPCODE_LUI             7'b01_101_11
`define OPCODE_AUIPC           7'b00_101_11
`define OPCODE_JAL             7'b11_011_11
`define OPCODE_JALR            7'b11_001_11
`define OPCODE_BRANCH          7'b11_000_11
`define OPCODE_LOAD            7'b00_000_11
`define OPCODE_STORE           7'b01_000_11
`define OPCODE_ALUI            7'b00_100_11
`define OPCODE_ALUR            7'b01_100_11
`define OPCODE_FENCE           7'b00_011_11
`define OPCODE_SYSTEM          7'b11_100_11
