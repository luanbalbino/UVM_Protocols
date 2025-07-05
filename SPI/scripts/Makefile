# -----------------------------------------------------------------------------
# Common Variables
# -----------------------------------------------------------------------------
SRC = ../rtl/spi_master_simple.sv \
      ../rtl/spi_slave_simple.sv \
      ../tb/top.sv \
      ../tb/spi_if.sv \
      ../tb/spi_transaction.sv \
      ../tb/spi_driver.sv \
      ../tb/spi_monitor.sv \
      ../tb/spi_sequence.sv \
      ../tb/spi_sequencer.sv \
      ../tb/spi_env.sv \
      ../tb/spi_test.sv

# Define GUI mode as disabled by default
gui ?= 0

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
	xrun -uvm -64bit -access +rwc -timescale 1ns/1ps -incdir tb $(SRC)
	@echo "Simulation with Cadence xrun (batch mode) completed."

# -----------------------------------------------------------------------------
# xrun (GUI mode)
# -----------------------------------------------------------------------------
run_xrun_gui: clean
	@echo "Starting simulation with Cadence xrun (GUI mode)..."
	xrun -uvm -64bit -access +rwc -timescale 1ns/1ps -incdir tb -gui $(SRC)
	@echo "Simulation with Cadence xrun (GUI mode) started."

# -----------------------------------------------------------------------------
# Target to clean generated files
# -----------------------------------------------------------------------------
clean:
	@echo "Cleaning generated files..."
	-rm -rf *.log *.wlf irun.key xcelium.d *.shm .simvision *.history *.key
	@echo "Cleaning completed."

.PHONY: all run run_xrun run_xrun_gui clean
