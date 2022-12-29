`default_nettype none

module adder
  ( input  var logic       i_clk

  , input  var logic [7:0] i_a
  , input  var logic [7:0] i_b
  , input  var logic [7:0] i_c

  , output var logic [7:0] o_sum
  );

  logic [7:0] rABSum_q, rC_q, sum_q;

  assign o_sum = sum_q;

  always_ff @(posedge i_clk)
    rABSum_q <= i_a + i_b;

  always_ff @(posedge i_clk)
    rC_q <= i_c;

  always_ff @(posedge i_clk)
    sum_q <= rABSum_q + rC_q;

endmodule
