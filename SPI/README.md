# ⚙️ SPI

This directory contains the UVM-based implementation and verification of the SPI (Serial Peripheral Interface) protocol.

---

## Protocol Overview

SPI is a full-duplex, synchronous serial communication protocol commonly used to connect microcontrollers with peripherals such as sensors, memory, and displays.

### Key Concepts

- **Master-Slave** architecture
- **Full-Duplex** data transfer using `MOSI` and `MISO`
- Clock-driven synchronization via `SCLK`
- Device selection through chip-select (`CS` or `SS`)
- Configurable clock modes via `CPOL` and `CPHA`

| Signal | Direction         | Description                            |
|--------|-------------------|----------------------------------------|
| `MOSI` | Master → Slave    | Data from master to slave              |
| `MISO` | Slave → Master    | Data from slave to master              |
| `SCLK` | Master → All      | Clock signal driven by the master      |
| `CS`   | Master → Slave(s) | Slave select line                      |

---

### How It Works

1. **Master selects** a slave using the `CS` line.
2. **Master generates clock** via `SCLK`.
3. Data is simultaneously **shifted out** on `MOSI` and **read in** from `MISO`.
4. Communication continues as long as the `CS` line is active (low).

## ✅ Implementation Status

| Feature              | Description                                      | Status                                |
| -------------------- | ------------------------------------------------ | ------------------------------------- |
| `CPOL = 0, CPHA = 0` | Mode 0 (Clock idle low, sample on rising edge)   | ✅ Implemented                        |
| `CPOL = 0, CPHA = 1` | Mode 1 (Clock idle low, sample on falling edge)  | ✅ Implemented                        |
| `CPOL = 1, CPHA = 0` | Mode 2 (Clock idle high, sample on falling edge) | ✅ Implemented                        |
| `CPOL = 1, CPHA = 1` | Mode 3 (Clock idle high, sample on rising edge)  | ✅ Implemented                        |
| Word Length          | Configurable word size                           | ⚠️ Partial (some classes hardcoded) |
| Bit Order            | MSB First                                        | ✅ Implemented                        |
| Bit Order            | LSB First                                        | ❌ Not implemented                    |
| MISO Support         | Receive data from slave                          | ✅ Implemented                        |
| Clock Divider        | SPI clock divider                                | ✅ Implemented                        |
| Assertions Module    | Assertions for protocol behavior                 | not implemented yet                   |
| Coverage             | Functional coverage via covergroups              | Just for basic signals                |

---

## ⚙️ SPI Clock Modes (CPOL and CPHA)

SPI defines 4 clocking modes based on two configuration bits:

- `CPOL`: Clock Polarity (idle state of `SCLK`)
- `CPHA`: Clock Phase (which edge to sample data on)

| Mode | CPOL | CPHA | Clock Idle | Sampling Edge | Change Edge |
|------|------|------|-------------|----------------|---------------|
| 0    | 0    | 0    | Low         | Rising         | Falling       |
| 1    | 0    | 1    | Low         | Falling        | Rising        |
| 2    | 1    | 0    | High        | Falling        | Rising        |
| 3    | 1    | 1    | High        | Rising         | Falling       |

> ℹ️ Clock mode must match on both master and slave for reliable communication.

---

## 📂 Directory Structure

- `figs/` – Diagrams, evidences or illustrative figures  
- `rtl/` – RTL design files (SystemVerilog)  
- `scripts/` – scripts (makefile, cov file, srclists, etc.)  
- `tb/` – Placeholder for generic or legacy testbenches  
- `tb_slave/` – UVM testbench for SPI Slave  
  - `agent/` – UVM agent components: driver, monitor, sequencer  
  - `env/` – Environment-level components (env, scoreboard, coverage, refmod, etc)  
  - `if/` – SPI interface definitions  
  - `sequences/` – Sequence items and transaction generators  
  - `test/` – UVM test classes  
  - `top/` – Top-level testbench module (connects DUT + env)  
  - `spi_assertions.sv` – Assertion module  

---

> Keep this document updated as implementation evolves.
