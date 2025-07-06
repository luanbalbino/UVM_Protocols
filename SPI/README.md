# ⚙️ SPI – Implementation Status
---

## 📌 Status/TBD

| Feature             | Description                                        | Status         |
|---------------------|----------------------------------------------------|----------------|
| `CPOL = 0, CPHA = 0`| SPI Mode 0 (Clock idle low, sample on rising edge) | ✅ Implemented |
| `CPOL = 0, CPHA = 1`| SPI Mode 1 (Clock idle low, sample on falling edge)| ⬜ Implemented (not working yet)|
| `CPOL = 1, CPHA = 0`| SPI Mode 2 (Clock idle high, sample on falling edge)| ✅ Implemented |
| `CPOL = 1, CPHA = 1`| SPI Mode 3 (Clock idle high, sample on rising edge)| ⬜ Implemented (not working yet)|
| Word Length         | Configurable word size (e.g., 16 bits, 32 bits)    | ⬜ Implemented (need adjust variable size in some classes)|
| Bit Order           | MSB First                                          | ✅ Implemented |
| Bit Order           | LSB First                                          | ⬜ Not implemented |
| MISO Support        | Receive data from slave                            | ✅ Implemented |
| Clock Divider       | Configurable SPI clock divider                     | ✅ Implemented |
| Sequences           | inclusion of more sequences to test the functional | TBD |
| Assertions module   | Adding assertions to functional behavior | TBD |
| coverage    | Improve covergroups | TBD |

---

