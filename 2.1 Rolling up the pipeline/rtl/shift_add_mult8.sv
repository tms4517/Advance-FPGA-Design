`default_nettype none

module mult8
  ( input  var logic        i_clk

  , input  var logic [7:0]  i_a     // Multiplicand.
  , input  var logic [7:0]  i_b     // Multiplier.
  , input  var logic        i_start // Control to sample inputs.

  , output var logic [15:0] o_product // i_a * i_b
  , output var logic        o_done // Indicate if multiplication has completed.
  );

  logic [15:0] product_d, product_q;

  logic [15:0] shiftA_d, shiftA_q;
  logic [7:0] shiftB_q;

  logic [4:0] multCounter_q;

  logic addEn;

  assign o_product = product_q;

  // Multiplication completes after 8 clock cycles.
  assign o_done = (multCounter_q == 5'd8);

  assign addEn = shiftB_q[0] && !o_done;

  // Count the number of shift/adds.
  always_ff @(posedge i_clk)
    multCounter_q <= i_start ? '0 : (multCounter_q+1'b1);

  // Left shift at each clock cycle after input has been sampled.
  always_ff @(posedge i_clk)
    shiftA_q <= i_start ? i_a : {shiftA_q[14:0], 1'b0};

  // Right shift at each clock cycle after input has been sampled.
  always_ff @(posedge i_clk)
    shiftB_q <= i_start ? i_b : {1'b0, shiftB_q[7:1]};

  always_ff @(posedge i_clk)
    product_q <= product_d;

  always_comb
    if (i_start)
      product_d = '0;
    else
      product_d = addEn ? (product_q+shiftA_q) : product_q;

endmodule