`default_nettype none

module fir
  ( input  var logic       i_clk

  , input  var logic [7:0] i_a
  , input  var logic [7:0] i_b
  , input  var logic [7:0] i_c
  , input  var logic [7:0] i_x

  , input  var logic       validSample

  , output var logic [7:0] o_y
  );

  logic [7:0] x1_q, x2_q, y_q;

  assign o_y = y_q;

  always_ff @(posedge i_clk)
    x1_q <= validSample ? i_x : x1_q;

  always_ff @(posedge i_clk)
    x2_q <= validSample ? x1_q : x2_q;

  always_ff @(posedge i_clk)
    y_q <= validSample ? (i_a*i_x)+(i_b*x1_q)+(i_c*x2_q) : y_q;

endmodule


