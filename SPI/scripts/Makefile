# -----------------------------------------------------------------------------
# Common Variables
# -----------------------------------------------------------------------------
SRC = -f src.f
#SRC = -f src_slave.f


# Define GUI mode as disabled by default
gui ?= 0
assert ?= 0

ifeq ($(assert),1)
	SRC += ../tb/spi_assertions.sv
endif

SEED 	 = random
COV_FILE = cov.ccf
COV_OPT += -coverage all -covfile $(COV_FILE) -covoverwrite 
OPT = +UVM_NO_RELNOTES -uvm -64bit -access +rwc -timescale 1ns/1ps +UVM_VERBOSITY=UVM_LOW
TESTNAME = spi_full_test # spi_modes_test #spi_base_test spi_full_test

ifeq ($(assert),1)
    OPT += +define+ENABLE_ASSERTIONS
endif

# -----------------------------------------------------------------------------
# Usage: make run (batch mode) or make run gui=1 (GUI mode)
# -----------------------------------------------------------------------------
run:
ifeq ($(gui), 1)
	$(MAKE) run_xrun_gui
else
	$(MAKE) run_xrun
endif

# -----------------------------------------------------------------------------
# xrun (batch mode)
# -----------------------------------------------------------------------------
run_xrun: clean
	@echo "Starting simulation with Cadence xrun (batch mode)..."
	xrun  $(OPT) $(COV_OPT) $(SRC) -svseed $(SEED) +UVM_TESTNAME=$(TESTNAME)
	@echo "Simulation with Cadence xrun (batch mode) completed."

# -----------------------------------------------------------------------------
# xrun (GUI mode)
# -----------------------------------------------------------------------------
run_xrun_gui: clean
	@echo "Starting simulation with Cadence xrun (GUI mode)..."
	xrun  $(OPT) $(COV_OPT) -gui $(SRC) -svseed $(SEED) +UVM_TESTNAME=$(TESTNAME)
	@echo "Simulation with Cadence xrun (GUI mode) started."

# -----------------------------------------------------------------------------
# Target to clean generated files
# -----------------------------------------------------------------------------
clean:
	@echo "Cleaning generated files..."
	-rm -rf *.log *.wlf irun.key xcelium.d *.shm .simvision *.history *.key *.diag cov_work
	@echo "Cleaning completed."

.PHONY: all run run_xrun run_xrun_gui clean
