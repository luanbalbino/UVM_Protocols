# -----------------------------------------------------------------------------
# Common Variables
# -----------------------------------------------------------------------------
SRC = ../rtl/spi_master_simple.sv \
      ../rtl/spi_slave_simple.sv \
      ../tb/top.sv \
      ../tb/if/spi_if.sv \
      ../tb/spi_transaction.sv \
      ../tb/env/spi_driver.sv \
      ../tb/env/spi_monitor.sv \
	  ../tb/env/spi_agent.sv \
      ../tb/sequences/spi_sequence.sv \
	  ../tb/sequences/spi_read_sequence.sv \
      ../tb/spi_sequencer.sv \
	  ../tb/spi_cov.sv \
	  ../tb/scb/spi_scb.sv \
      ../tb/env/spi_env.sv \
	  ../tb/test/spi_base_test.sv \
	  ../tb/test/spi_master_read_test.sv

#../tb/spi_test_lib.sv 
#../tb/spi_virtual_seq.sv \

ifeq ($(assert),1)
	SRC += ../tb/spi_assertions.sv
endif

# Define GUI mode as disabled by default
gui ?= 0
assert ?= 0
SEQ ?= basic_transfer_seq

SEED 	 = random
COV_FILE = cov.ccf
COV_OPT += -coverage all -covfile $(COV_FILE) -covoverwrite 
OPT = +UVM_NO_RELNOTES -uvm -64bit -access +rwc -timescale 1ns/1ps  +UVM_VERBOSITY=UVM_LOW
TESTNAME = spi_base_test

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
	-rm -rf *.log *.wlf irun.key xcelium.d *.shm .simvision *.history *.key *.diag 
	@echo "Cleaning completed."

.PHONY: all run run_xrun run_xrun_gui clean
