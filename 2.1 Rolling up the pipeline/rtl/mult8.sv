`default_nettype none

module mult8
  ( input  var logic i_clk

  , input  var logic [7:0] i_a
  , input  var logic [7:0] i_b

  , output var logic [7:0] o_product
  );

  logic [15:0] prod16_q;

  assign o_product = prod16_q[15:8];

  always_ff @(posedge i_clk)
    prod16_q <= i_a * i_b;

endmodule


