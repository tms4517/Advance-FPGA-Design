`default_nettype none

module setReset
  ( input  var logic i_clk

  , input  var logic i_dat1
  , input  var logic i_dat2
  , input  var logic i_dat3

  , output var logic o_dat
  );

logic dat_q;

assign o_dat = dat_q;

// Implements the logic function: o_Dat = !i_dat3 & (i_dat1 || i_dat2)
always_ff @(posedge i_clk)
  if (i_dat3)
    dat_q <= '0;
  else if (i_dat1)
    dat_q <=  1'b1;
  else
    dat_q <=  i_dat2;

endmodule