# SPI Protocol — Operating Modes (CPOL and CPHA)

The **Serial Peripheral Interface (SPI)** is a **synchronous** serial communication protocol, widely used for short-distance communication between microcontrollers and peripherals.

It is called **synchronous** because it uses a **shared clock signal (SCLK)** between the master and slave to synchronize data transfers.

---

## Overview

SPI offers **four operating modes**, defined by two clock settings:

- **CPOL (Clock Polarity)**: Determines the idle state of the clock.
- **CPHA (Clock Phase)**: Determines when data is sampled and changed.

These settings control how the clock behaves and when data is read or written.

---

## Understanding CPOL and CPHA

### 🔹 CPOL (Clock Polarity)

Defines the **idle (inactive)** state of the serial clock (SCLK):

- `CPOL = 0`: Clock idles **low (0V)**.
- `CPOL = 1`: Clock idles **high (Vcc)**.

### 🔹 CPHA (Clock Phase)

Defines **on which clock edge the data is sampled and on which it is changed**:

- `CPHA = 0`:  
  - Data is **sampled on the first edge** (rising edge if `CPOL=0`, falling edge if `CPOL=1`).
  - Data is **changed before or on the second edge**.

- `CPHA = 1`:  
  - Data is **sampled on the second edge**.
  - Data is **changed on the first edge**.

---

## 🔄 SPI Modes

Combining `CPOL` and `CPHA` gives **four SPI operating modes**:

### ✅ Mode 0: CPOL = 0, CPHA = 0

- Clock idles **low**.
- Data sampled on **rising edge**.
- Data changed on **falling edge**.

**Operation (MSB First):**

1. Clock starts low.
2. Master places the first bit (MSB) on MOSI.
3. Clock rises → Slave samples MOSI; Master samples MISO.
4. Clock falls → Master sets the next bit.
5. Repeat for 8 bits.
6. Clock returns to idle (low).

**Implementation status:** ✔️ Implemented

---

### ⬜ Mode 1: CPOL = 0, CPHA = 1

- Clock idles **low**.
- Data changed on **rising edge**.
- Data sampled on **falling edge**.

**Implementation status:** ⬜ Not implemented

---

### ⬜ Mode 2: CPOL = 1, CPHA = 0

- Clock idles **high**.
- Data changed on **rising edge**.
- Data sampled on **falling edge**.

**Implementation status:** ⬜ Not implemented

---

### ⬜ Mode 3: CPOL = 1, CPHA = 1

- Clock idles **high**.
- Data changed on **falling edge**.
- Data sampled on **rising edge**.

**Implementation status:** ⬜ Not implemented

---

## 📏 Bit Order

In addition to the clock mode, the **bit transmission order** must also be agreed upon:

- **MSB First (Most Significant Bit First)**: most significant bit sent first (**most common**).
- **LSB First (Least Significant Bit First)**: least significant bit sent first.

---

📚 **Reference Table:**

| Mode | CPOL | CPHA | Clock Idle | Sampling Edge | Change Edge |
|------|------|------|-------------|----------------|---------------|
| 0    | 0    | 0    | Low         | Rising         | Falling       |
| 1    | 0    | 1    | Low         | Falling        | Rising        |
| 2    | 1    | 0    | High        | Falling        | Rising        |
| 3    | 1    | 1    | High        | Rising         | Falling       |

---
