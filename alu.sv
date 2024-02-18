module alu(input  logic [31:0] a, b,
           input  logic [3:0]  alucontrol,
           output logic [31:0] result,
           output logic        zero);
  
  logic [31:0] condinvb, sum;

  assign condinvb = alucontrol[3] ? ~b : b;
  assign sum = a + condinvb + alucontrol[3]; // when 4th bit is 1 (sub or slt), NOT b operand for minusing
 
  always_comb
    case (alucontrol[3:0])
      4'b0000: result = a & b; //AND
      4'b0001: result = a | b; //OR
      4'b0010: result = sum; //ADD
      4'b1010: result = sum; //SUBTRACT
      4'b1111: result = sum[31]; //SLT
      4'b0100: result = a ^ {16'h0000, b[15:0]}; //XORI
      4'b0101: result = {b, 16'h0000}; //LUI
      4'b0110: result = b >> a[4:0]; //SRLV
      4'b0011: begin // BGTZ
        if (a > 0 & a[31] ==! 1) // if a is gr8r than 0 and non negative
            result = 0;
        else
            result = 1;
        end
      4'b0111: result = {16'h0000, b[15:0]}; // LI (16-bit from the vault version)
    endcase

  assign zero = (result == 32'b0);
endmodule