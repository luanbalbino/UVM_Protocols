# -----------------------------------------------------------------------------
# Common
# -----------------------------------------------------------------------------
SRC = -f src_files.f
OPT = -uvm -64bit -access +rwc +UVM_VERBOSITY=UVM_MEDIUM -timescale 1ns/1ps +UVM_NO_RELNOTES
SEED = random
TESTNAME = apb_simple_write_read_test #options: apb_simple_write_read_test #apb_simple_read_test #apb_base_test apb_simple_write_test

# -----------------------------------------------------------------------------
# Target
# -----------------------------------------------------------------------------
run:
ifeq ($(gui),1)
	xrun $(OPT) -gui $(SRC) -svseed $(SEED) +UVM_TESTNAME=$(TESTNAME)
else
	xrun $(OPT) $(SRC) -svseed $(SEED) +UVM_TESTNAME=$(TESTNAME)
endif

# -----------------------------------------------------------------------------
# Clean
# -----------------------------------------------------------------------------
clean:
	rm -rf *.log *.shm xcelium.d .simvision irun.key *.history *.key *.diag *.vcd *.dump 

.PHONY: run clean
