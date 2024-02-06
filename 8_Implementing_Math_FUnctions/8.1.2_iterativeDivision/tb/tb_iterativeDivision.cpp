#include <cmath>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <stdlib.h>
#include <vector>

#include "ViterativeDivision.h" // Verilated DUT.
#include <verilated.h>         // Common verilator routines.
#include <verilated_vcd_c.h>   // Write waverforms to a VCD file.

#define MAX_SIM_TIME 200 // Number of clk edges.
#define VERIF_START_TIME 5

// Number of clk cycles before start should be reasserted.
const int assertStart = 50;

vluint64_t sim_time = 0;
vluint64_t posedge_cnt = 0;

// Assert start after every 35 clk cycles.
void toggleStart(ViterativeDivision *dut) {
  dut->i_start = 0;

  if ((posedge_cnt % assertStart == 0) && (posedge_cnt > 5)) {
    dut->i_start = 1;
  }
}

void driveOperands(ViterativeDivision *dut){
  dut->i_dividend = 0;
  dut->i_divisor  = 0;

  if ((posedge_cnt % assertStart == 0) && (posedge_cnt > 5)) {
    dut->i_dividend = 44;
    dut->i_divisor  = 3;
  }
}

int main(int argc, char **argv, char **env) {
  srand(time(NULL));
  Verilated::commandArgs(argc, argv);
  ViterativeDivision *dut = new ViterativeDivision; // Instantiate DUT.

  // {{{ Set-up waveform dumping.

  Verilated::traceEverOn(true);
  VerilatedVcdC *m_trace = new VerilatedVcdC;
  dut->trace(m_trace, 5);
  m_trace->open("waveform.vcd");

  // }}} Set-up waveform dumping.

  while (sim_time < MAX_SIM_TIME) {

    dut->i_clk ^= 1; // Toggle clk to create pos and neg edge.

    dut->eval(); // Evaluate all the signals in the DUT on each clock edge.

    if (dut->i_clk == 1) {
      posedge_cnt++;

      toggleStart(dut);
      driveOperands(dut);
    }

    // Write all the traced signal values into the waveform dump file.
    m_trace->dump(sim_time);
    sim_time++;
  }

  m_trace->close();
  delete dut;
  exit(EXIT_SUCCESS);
}
