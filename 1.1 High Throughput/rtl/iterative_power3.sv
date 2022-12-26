`default_nettype none

module power3
  ( input  var logic i_clk

  , input  var logic [7:0] i_x
  , input  var logic       i_start

  , output var logic [7:0] o_xPower
  , output var logic       o_finished
  );

  logic [7:0] xPower_q;
  logic [1:0] nCount_q;

  logic finished;

  assign o_finished = finished;
  assign finished = (nCount_q == 0);

  assign o_xPower = xPower_q;

  always_ff @(posedge i_clk)
    if (i_start)
      nCount_q <= 2'd2;
    else
      nCount_q <= !finished ? nCount_q-1 : nCount_q;

  always_ff @(posedge i_clk)
    if (i_start)
      xPower_q <= i_x;
    else
      xPower_q <= !finished ? xPower_q*i_x : xPower_q;

endmodule


