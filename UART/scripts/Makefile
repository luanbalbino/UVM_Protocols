# -----------------------------------------------------------------------------
# Common
# -----------------------------------------------------------------------------
SRC = -f files_uart.f
OPT = -uvm -64bit -access +rwc +UVM_VERBOSITY=UVM_LOW -timescale 1ns/1ps +UVM_NO_RELNOTES
SEED = random
TESTNAME = test

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
	rm -rf *.log *.shm xcelium.d .simvision irun.key *.history *.key *.diag *.vcd

.PHONY: run clean
