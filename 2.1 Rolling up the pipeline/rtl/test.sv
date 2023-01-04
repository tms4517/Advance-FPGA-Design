`default_nettype none

module test
  ( input  var logic        i_clk

  , input  var logic [7:0]  i_a
  , input  var logic        i_start

  , output var logic [7:0]  o_shift
  );

  logic [7:0] shiftA_q;

  assign o_shift = shiftA_q;

  // Left shift at each clock cycle after input has been sampled.
  always_ff @(posedge i_clk)
    if (i_start)
      shiftA_q <= i_a;
    else
      shiftA_q <= {shiftA_q[6:0], 1'b0};


endmodule