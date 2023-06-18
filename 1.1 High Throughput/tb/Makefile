MODULE=iterative_power3
MODULE_PATH=/home/tej/Advance-FPGA-Design/1.1_High_Throughput/rtl

.PHONY: sim
sim: waveform.vcd

.PHONY: verilate
verilate: .stamp.verilate

.PHONY: build
build: obj_dir/Viterative_power3

.PHONY: waves
waves: waveform.vcd
	@echo
	@echo "### WAVES ###"
	gtkwave waveform.vcd

waveform.vcd: ./obj_dir/V$(MODULE)
	@echo
	@echo "### SIMULATING ###"
	@./obj_dir/V$(MODULE) +verilator+rand+reset+2

./obj_dir/V$(MODULE): .stamp.verilate
	@echo
	@echo "### BUILDING SIM ###"
	make -C obj_dir -f V$(MODULE).mk V$(MODULE)

.stamp.verilate: $(MODULE_PATH)/$(MODULE).sv tb_$(MODULE).cpp
	@echo
	@echo "### VERILATING ###"
	verilator -Wall --trace --x-assign unique --x-initial unique -cc $(MODULE_PATH)/$(MODULE).sv --exe tb_$(MODULE).cpp
	@touch .stamp.verilate

.PHONY: lint
lint: $(MODULE_PATH)/$(MODULE).sv
	verilator --lint-only $(MODULE_PATH)/$(MODULE).sv

.PHONY: clean
clean:
	rm -rf .stamp.*;
	rm -rf ./obj_dir
	rm -rf waveform.vcd
