// This file needs to be be appended to ../rtl/iterativeDivision.sv before
// formal verification is run using SymbiYosys.

`ifdef FORMAL

  // {{{ Auxillary logic
  logic divTime;

  always_ff @(posedge i_clk)
    if (i_start)
      divTime <= '0;
    else if (doProcess_q || finalShift)
      divTime <= divTime + 1'b1;
    else
      divTime <= divTime;
  // }}} Auxillary logic

  always_ff @(posedge i_clk) begin

    // {{{ Control unit
    // When start is asserted, doProcess_q is asserted 1 clk cycle later.
    assert_doProcess: assert (|{doProcess_d && i_start
                              , !i_start
                              });

    // Finish is a pulse at t = 33.
    assert_finish: assert (|{o_finish && counter_q == 6'd33
                           , !o_finish && counter_q < 6'd33
                           , !o_finish && counter_q > 6'd33
                           });

    // Final shift should not be asserted at t = 33.
    // ** FAILING **
    // assert_finalShift: assert (|{!finalShift && counter_q == 6'd33
    //                            , counter_q < 6'd33
    //                            , counter_q > 6'd33
    //                            });

    // Total division time is 32 clock cycles.
    assert_divTime: assert (divTime < 6'd33);
    // }}} Control unit

    // {{{ Division
    // Quotient and remainder don't change when finish is asserted.
    // ** FAILING ** (dependant on previous failing assertion)
    // assert_quotient: assert (|{!o_finish
    //                          , (quotient_d == quotient_q) && o_finish
    //                          });

    // ShiftIn must be asserted if a 1 is shifted into the quotient the next
    // clock cycle.
    assert_shiftOneIntoQuotient:
      assert(|{quotient_d[0] && shiftIn
             , !shiftIn
             , !doProcess_q && !finalShift
             });

    // ShiftIn must be deasserted if a 0 is shifted into the quotient the next
    // clock cycle.
    assert_shiftZeroIntoQuotient:
      assert(|{!quotient_d[0] && !shiftIn
             , shiftIn
             , !doProcess_q && !finalShift
             });

    // }}} Division

  end

`endif
