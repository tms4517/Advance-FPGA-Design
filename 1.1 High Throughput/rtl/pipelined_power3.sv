`default_nettype none

module power3
  ( input  var logic i_clk

  , input  var logic [7:0] i_x

  , output var logic [7:0] o_xPower
  );

  logic [7:0] xPower1_q, x2_q, xPower2_q, xPower3_q;

  assign o_xPower = xPower3_q;

  // Pipeline stage 1.
  always_ff @(posedge i_clk)
    xPower1_q <= i_x;

  // X delayed by 2 clock cycles.
  always_ff @(posedge i_clk)
    x2_q <= xPower1_q;

  // Pipeline stage 2.
  always_ff @(posedge i_clk)
    xPower2_q <= xPower1_q*xPower1_q;

  // Pipeline stage 3.
  always_ff @(posedge i_clk)
    xPower3_q <= xPower2_q*x2_q;

endmodule


