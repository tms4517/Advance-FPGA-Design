`default_nettype none

module setReset
  ( input  var logic i_clk
  , input  var logic i_arst

  , input  var logic i_dat1
  , input  var logic i_dat2

  , output var logic o_dat
  );

  logic dat_q;

  assign o_dat = dat_q;

  always_ff @(posedge i_clk or negedge i_arst)
    if (!i_arst)
      dat_q <= '0;
    else
      dat_q <=  i_dat1 || i_dat2;

// If an arst is not required, synthesis tools can choose a FF with a synchronous
// set to implement the same function with no logic elements as shown below.

// always_ff @(posedge i_clk)
//   if (i_dat1)
//     dat_q <= '1;
//   else
//     dat_q <= i_dat2;

endmodule