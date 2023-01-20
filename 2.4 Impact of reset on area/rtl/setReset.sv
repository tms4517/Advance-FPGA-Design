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

always_ff @(posedge i_clk, posedge i_arst)
  if (i_arst)
    dat_q <= '0;
  else
   dat_q <=  i_dat1 || i_dat2;

endmodule