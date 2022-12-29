`default_nettype none

module randomLogic
  ( input  var logic       i_clk

  , input  var logic [7:0] i_a
  , input  var logic [7:0] i_b
  , input  var logic [7:0] i_c
  , input  var logic       i_cond1
  , input  var logic       i_cond2

  , output var logic [7:0] o_out
  );

  logic [7:0] out_d, out_q;
  logic condB;

  assign o_out = out_q;

  always_ff @(posedge i_clk)
    out_q <= out_d;

  assign condB = i_cond2 && !i_cond1;

  always_comb
    if (condB && (i_c < 8'd8))
      out_d = i_b;
    else if (i_cond1)
      out_d = i_a;
    else
      out_d = i_c;

endmodule
