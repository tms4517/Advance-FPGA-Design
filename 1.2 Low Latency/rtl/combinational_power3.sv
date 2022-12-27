`default_nettype none

module power3
  ( input  var logic [7:0] i_x

  , output var logic [7:0] o_xPower
  );

  logic [7:0] xPower1, x2, xPower2, xPower3;

  assign o_xPower = xPower3;

  always_comb xPower1 = i_x;

  always_comb xPower2 = xPower1*xPower1;

  always_comb xPower3 = xPower2*xPower1;

endmodule


