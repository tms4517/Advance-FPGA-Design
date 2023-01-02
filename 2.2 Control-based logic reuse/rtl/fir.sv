// This module implements a low-pass FIR filter represented  by the equation:
// Y = A*X[0] + B*X[1] + C*X[2]

`default_nettype none

module fir
  ( input  var logic       i_clk

  , input  var logic [7:0] i_x
  , input  var logic       i_dataValid // X is valid.

  , input  var logic [7:0] i_a
  , input  var logic [7:0] i_b
  , input  var logic [7:0] i_c

  , output var logic [7:0] o_y
  , output var logic       o_done // Y is valid.
  );

  logic [7:0] x0_q;
  logic [7:0] x1_q;
  logic [7:0] x2_q;

  logic [1:0] counter_q;
  logic [7:0] coefficient;
  logic [7:0] sample;

  logic [7:0] sum;
  logic [7:0] mult;
  logic [7:0] y_q;

  assign o_y = y_q;

  // {{{ Delayed samples of dataIn

  // Register the input.
  always_ff @(posedge i_clk)
    x0_q <= i_dataValid ? i_x : '0;

  // 1 clk-cycle delayed version of x0.
  always_ff @(posedge i_clk)
    x1_q <= x0_q;

  // 2 clk-cycle delayed version of x0.
  always_ff @(posedge i_clk)
    x2_q <= x1_q;

  // }}} Delayed samples of dataIn

  // {{{ Decode coefficient and delayed sample
  // Select the correct coefficient and delayed sample depending on the clock cycle.

  // Count the number of clock cycles
  always_ff @(posedge i_clk)
    counter_q <= i_dataValid ? '0 : counter_q+1;

  // Select the correct coefficient.
  always_comb
    case (counter_q)
      2'd0:
        coefficient = i_a;
      2'd1:
        coefficient = i_b;
      2'd2:
        coefficient = i_c;
      default:
        coefficient = '0;
    endcase

  // Select the correct sample.
  always_comb
    case (counter_q)
      2'd0:
        sample = x0_q;
      2'd1:
        sample = x1_q;
      2'd2:
        sample = x2_q;
      default:
        sample = '0;
    endcase

  // }}} Decode coefficient and delayed sample

  // {{{ Multiply and accumulate

  always_comb mult = coefficient*sample;

  always_comb sum = mult + y_q;

  // Store the result.
  always_ff @(posedge i_clk)
    if (i_dataValid)
      y_q <= '0;
    else
      y_q <= y_q + sum;

  // }}} Multiply and accumulate

  // Equation is complete.
  always_comb
    if (counter_q == 2'd3)
      o_done = '1;
    else
      o_done = '0;
endmodule
