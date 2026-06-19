BOARD=tangnano1k
FAMILY=GW1NZ-1
DEVICE=GW1NZ-LV1QN48C6/I5
FILENAME=problema3

all: $(FILENAME).fs

# Synthesis
$(FILENAME).json: $(FILENAME).v
	yosys -p "read_verilog $(FILENAME).v; synth_gowin -top $(FILENAME) -json $(FILENAME).json"

# Place and Route
$(FILENAME)_pnr.json: $(FILENAME).json
	nextpnr-himbaechel --json $(FILENAME).json --write $(FILENAME)_pnr.json --freq 27 --device ${DEVICE} --vopt family=${FAMILY} --vopt cst=${BOARD}.cst

# Generate Bitstream
$(FILENAME).fs: $(FILENAME)_pnr.json
	gowin_pack -d ${FAMILY} -o $(FILENAME).fs $(FILENAME)_pnr.json

# Program Board
load: $(FILENAME).fs
	sudo openFPGALoader -b ${BOARD} $(FILENAME).fs -m

clean:
	rm -f *~ *.json *.fs
