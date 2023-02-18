`default_nettype none

module decisionTree
  ( input  var logic       i_clk

  , input  var logic [3:0] i_in
  , input  var logic [3:0] i_ctrl

  , output var logic       o_rout
  );

  logic rout_d, rout_q;

  always_comb o_rout = rout_q;

  // DFF: .ck(i_clk),
  //      .q(rout_q)
  //      .d(rout_d),
  always_ff @(posedge i_clk)
    rout_q <= rout_d;

  // Decision tree.
  always_comb
    if (i_ctrl[0])
      rout_d = i_in[0];
    else if (i_ctrl[1])
      rout_d = i_in[1];
    else if (i_ctrl[2])
      rout_d = i_in[2];
    else if (i_ctrl[3])
      rout_d = i_in[3];
    else
      rout_d = rout_q;

endmodule
