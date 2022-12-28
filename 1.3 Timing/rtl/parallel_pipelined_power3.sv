`default_nettype none

module power3
  ( input  var logic i_clk

  , input  var logic [7:0] i_x

  , output var logic [7:0] o_xPower
  );

  // Product registers.
  logic [7:0] xPower1_q, x2_q;

  logic [7:0] xPower2;

  // Partial product registers.
  logic [3:0] xPower2_ppAA_q, xPower2_ppAB_q, xPower2_ppBB_q;
  logic [3:0] xPower3_ppAA_q, xPower3_ppAB_q, xPower3_ppBB_q;

  // Nibbles for partial products (A is MS nibble, B is LS nibble).
  logic [3:0] xPower1_A, xPower1_B;
  logic [3:0] xPower2_A, xPower2_B;
  logic [3:0] x2_A, x2_B;
  logic [3:0] xPower3_A, xPower3_B;

  // {{{ Pipeline stage 1.

  always_ff @(posedge i_clk)
    xPower1_q <= i_x;

  assign xPower1_A = xPower1_q[7:4];
  assign xPower1_B = xPower1_q[3:0];

  // }}} Pipeline stage 1.

  // X delayed by 2 clock cycles.
  always_ff @(posedge i_clk)
    x2_q <= xPower1_q;

  assign x2_A = x2_q[7:4];
  assign x2_B = x2_q[3:0];

  // {{{ Pipeline stage 2.

  always_ff @(posedge i_clk)
    xPower2_ppAA_q <= xPower1_A*xPower1_A;

  always_ff @(posedge i_clk)
    xPower2_ppAB_q <= xPower1_A*xPower1_B;

  always_ff @(posedge i_clk)
    xPower2_ppBB_q <= xPower1_B*xPower1_B;

  // Recombine products.
  assign xPower2 = (xPower2_ppAA_q << 8) + (xPower2_ppAB_q << 4) + xPower2_ppBB_q;

  assign xPower2_A = xPower2[7:4];
  assign xPower2_B = xPower2[3:0];

  // }}} Pipeline stage 2.

  // {{{ Pipeline stage 3.

  always_ff @(posedge i_clk)
    xPower3_ppAA_q <= xPower2_A*xPower2_A;

  always_ff @(posedge i_clk)
    xPower3_ppAB_q <= xPower2_A*xPower2_B;

  always_ff @(posedge i_clk)
    xPower3_ppBB_q <= xPower2_B*xPower2_B;

  // Recombine products.
  assign o_xPower = (xPower3_ppAA_q << 8) + (xPower3_ppAB_q << 4) + xPower3_ppBB_q;

  // }}} Pipeline stage 3.

endmodule


