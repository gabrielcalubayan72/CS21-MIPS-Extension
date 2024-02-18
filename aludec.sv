////////////
`timescale 1ns / 1ps
module aludec(input  logic [5:0] funct,
              input  logic [1:0] aluop,
              input  logic [5:0] op, // for checking opcode of I-type instructions
              output logic [3:0] alucontrol);

  always_comb
    case(aluop)
      2'b00: alucontrol <= 4'b0010;  // add (for lw/sw/addi)
      2'b01: alucontrol <= 4'b1010;  // sub (for beq), bit 4 set to 1 since ALU NOTs operand b for minusing
      2'b11: case(op) // I-type instructions
          6'b001110: alucontrol <= 4'b0100; // xor
          6'b001111: alucontrol <= 4'b0101; // lui
          6'b000111: alucontrol <= 4'b0011; // bgtz
          6'b010001: alucontrol <= 4'b0111; // li (16-bit from the vault version)
      endcase
      2'b10: case(funct)          // R-type instructions
          6'b100000: alucontrol <= 4'b0010; // add
          6'b100010: alucontrol <= 4'b1010; // sub, bit 4 set to 1 since ALU NOTs operand b for minusing
          6'b100100: alucontrol <= 4'b0000; // and
          6'b100101: alucontrol <= 4'b0001; // or
          6'b101010: alucontrol <= 4'b1111; // slt, bit 4 set to 1 since ALU NOTs operand b for minusing
          6'b000110: alucontrol <= 4'b0110; // srlv
          default:   alucontrol <= 4'bxxxx; // ???
        endcase
    endcase
endmodule
