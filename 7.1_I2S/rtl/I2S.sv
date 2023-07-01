`default_nettype none

module I2S
  ( input  var logic i_sck // Continuous serial clock.
  , input  var logic i_ws  // Word select.
  , input  var logic i_sd  // Source-synchronous serial data.

  , output var logic [23:0] o_dataL // Unsynchronised left-channel data.
  , output var logic [23:0] o_dataR // Unsynchronised right-channel data.
  );

  // {{{ Left-right channel detect.

    // Detect the rising and falling edges of i_ws.

    logic ws_q;
    logic wsRisingEdge, wsFallingEdge;
    logic leftChannel, rightChannel;

    always_ff @(posedge i_sck)
      ws_q <= i_ws;

    always_comb wsRisingEdge  = !ws_q && i_ws;
    always_comb wsFallingEdge = ws_q && !i_ws;

    always_comb leftChannel  = wsFallingEdge;
    always_comb rightChannel = wsRisingEdge;

    // Store current channel.

    logic leftChannel_q, rightChannel_q;

    always_ff @(posedge i_sck)
      leftChannel_q <= leftChannel;

    always_ff @(posedge i_sck)
      rightChannel_q <= rightChannel;

  // }}} Left-right channel detect.

  // {{{ Track the number of serial data bits received.

    // Count down from 16.
    // Note: MSB delayed by 1 clk from i_sck change.

    logic [4:0] bitCounter_q;
    logic dataCapture;

    always_ff @(posedge i_sck)
      if(wsRisingEdge || wsFallingEdge)
        bitCounter_q <= 5'd16;
      else
        bitCounter_q <= bitCounter_q - 1'b1;

    always_comb dataCapture = (bitCounter_q != 0);

  // {{{ Track the number of serial data bits received.

  // {{{ Capture serial-data using a shift register.

    logic sd_q;
    logic [23:0] sdWord; // Note: Data word size can be 16 bits to 24 bits.

    always_ff @(posedge i_sck)
      sd_q <= i_sd;

    always_ff @(posedge i_sck)
      sdWord <= {sdWord[22:0], sd_q};

  // }}} Capture serial-data using a shift register.

  // {{{ Load captured words into separate registers.

    logic [23:0] dataR_q, dataL_q;

    always_ff @(posedge i_sck)
      if (leftChannel_q)
        dataR_q <= {sdWord[15:0], 8'b0};
      else
        dataR_q <= dataR_q;

    always_ff @(posedge i_sck)
      if (rightChannel_q)
        dataL_q <= {sdWord[15:0], 8'b0};
      else
        dataL_q <= dataR_q;

    always_comb o_dataL = dataL_q;
    always_comb o_dataR = dataR_q;

  // {{{ Load captured words into separate registers.

endmodule

`resetall
