PROJ=uart_tx

all: ${PROJ}.bit

%.json: %.sv
	~/yosys/yosys -p "read_verilog -sv $< uart_tx.sv; synth_ecp5 -top uart_tx -json $@" $<

%_out.config: %.json
	~/nextpnr/build/nextpnr-ecp5 --json $< --textcfg $@ --lpf ulx3s_v20.lpf --12k --package CABGA381

%.bit: %_out.config
	ecppack $< $@

clean:
	rm *.bit *.svf *_out.config *.json

prog: ${PROJ}.bit
	~/openFPGALoader/build/openFPGALoader -b ulx3s $<

.PHONY: all clean prog
