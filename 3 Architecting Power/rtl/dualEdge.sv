`default_nettype none

module dualEdge
  ( input  var logic i_clk

  , input  var logic i_data

  , output var logic o_data
  );

logic ff0_q;
logic ff1_q;
logic dataOut_q;

assign o_data = dataOut_q;

always_ff @(posedge i_clk)
  ff0_q <= i_data;

// Note: Yosys cannot synthesize DETFF.

always_ff @(posedge i_clk, negedge i_clk)
  ff1_q <= ff0_q;

always_ff @(posedge i_clk, negedge i_clk)
  dataOut_q <= ff1_q;

endmodule