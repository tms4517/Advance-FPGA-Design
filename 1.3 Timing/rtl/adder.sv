`default_nettype none

module adder
  ( input  var logic       i_clk

  , input  var logic [7:0] i_a
  , input  var logic [7:0] i_b
  , input  var logic [7:0] i_c

  , output var logic [7:0] o_sum
  );

  logic [7:0] rA_q, rB_q, rC_q, sum_q;

  assign o_sum = sum_q;

  always_ff @(posedge i_clk)
    rA_q <= i_a;

  always_ff @(posedge i_clk)
    rB_q <= i_b;

  always_ff @(posedge i_clk)
    rC_q <= i_c;

  always_ff @(posedge i_clk)
    sum_q <= rA_q + rB_q + rC_q;

endmodule
