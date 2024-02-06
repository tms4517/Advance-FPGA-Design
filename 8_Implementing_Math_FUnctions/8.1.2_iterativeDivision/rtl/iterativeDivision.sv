// This module implements hardware division
// (quotient = dividend/divisor and remainder) using an iterative method.

`default_nettype none

module iterativeDivision
  #(parameter int unsigned DATA_W = 32)
  ( input  var logic i_clk

  , input  var logic [DATA_W-1:0] i_dividend
  , input  var logic [DATA_W-1:0] i_divisor

  , input  var logic i_start // Single pulse to start process.

  , output var logic [DATA_W-1:0] o_quotient
  , output var logic [DATA_W-1:0] o_remainder

  , output var logic o_finish // Single pulse to indicate end of process.
  );

  // {{{ Control unit
  logic [5:0] counter_q;

  always_ff @(posedge i_clk)
    if (i_start)
      counter_q <= '0;
    else
      counter_q <= counter_q + 1'b1;

  logic doProcess_d, doProcess_q;

  always_ff @(posedge i_clk)
    doProcess_q <= doProcess_d;

  always_comb
    if (i_start)
      doProcess_d = '1;
    else if (counter_q == 6'd31)
      doProcess_d = '0;
    else
      doProcess_d = doProcess_q;

  logic finalShift;

  always_ff @(posedge i_clk)
    finalShift <= doProcess_q;

  always_comb
    if (counter_q == 6'd33)
      o_finish = '1;
    else
      o_finish = '0;
  // }}} Control unit

  // {{{ Sample inputs
  logic [DATA_W-1:0] divisor_q;

  always_ff @(posedge i_clk)
    if (i_start)
      divisor_q <= i_divisor;
    else
      divisor_q <= divisor_q;

  logic [(2*DATA_W)-1:0] dividendRemainder_q, dividendRemainder_d;

  always_ff @(posedge i_clk)
    if (i_start)
      dividendRemainder_q <= {32'b0, i_dividend};
    else
      dividendRemainder_q <= dividendRemainder_d;
  // }}} Sample inputs

  // {{{ ALU
  logic [DATA_W-1:0] opA, opB;

  always_comb
    opA = dividendRemainder_q[(2*DATA_W)-1:DATA_W];

  always_comb
    opB = divisor_q;

  // Determine if partial dividend is greater than divisor.
  logic shiftIn;

  always_comb
    if ((opA > opB) || (opA == opB))
      shiftIn = '1;
    else
      shiftIn = '0;

  // Obtain partial remainder.
  logic [DATA_W-1:0] partialRemainder;

  always_comb
    partialRemainder = opA - opB;
  // }}} ALU

  // {{{ Shift Quotient
  // NOTE: The quotient has to be shifted left at the end of the process.
  logic [DATA_W-1:0] quotient_d, quotient_q;

  always_ff @(posedge i_clk)
    if (i_start)
      quotient_q <= '0;
    else
      quotient_q <= quotient_d;

  always_comb
    if ((doProcess_q || finalShift) && shiftIn)
      quotient_d = {quotient_q[DATA_W-2:0], 1'b1};
    else if ((doProcess_q || finalShift) && !shiftIn)
      quotient_d = quotient_q << 1;
    else
      quotient_d = quotient_q;

  always_comb
    o_quotient = quotient_q;
  // }}} Shift Quotient

  // {{{ Shift dividendRemainder register
  always_comb
    if (doProcess_q && !shiftIn)
      dividendRemainder_d = dividendRemainder_q << 1;
    else if (doProcess_q && shiftIn)
      dividendRemainder_d = {partialRemainder, dividendRemainder_q
                             [DATA_W-1:0]} << 1;
    else
      dividendRemainder_d = dividendRemainder_q;

  always_comb
    o_remainder = dividendRemainder_q[(2*DATA_W)-1:DATA_W];
  // }}} Shift dividendRemainder register

endmodule

`resetall
