# sv-configurable-updown-counter
Configurable up/down counter with enable and reset, accessible via APB interface.

## Installation (Ubuntu)

- You need iverilog and gtkwave installed to compile and view waveforms, respectively.

```bash
sudo apt update
sudo apt install iverilog gtkwave
git clone https://github.com/iglesias-daniel/sv-configurable-updown-counter
cd sv-configurable-updown-counter
```
## Usage 

- The counter module has 4 inputs and one output.
    - `clk`: Clock signal (input)
    - `en`: Enable signal (input), allows the counter to increment or decrement
    - `rst_n`: Synchronous reset signal (input), resets count to zero.
    - `dir`: Direction (input), `0` = up, `1` = down
    - `count`: Current counter value (output), width defined by `WIDTH` parameter
- The counter module can be controlled using an APB interface, with the following registers:

## 📄 APB Register Map

- You can modify the address with `ADDRESS` parameter on `counter_apb_wrapper`.

| Address Offset | Name        | Access | Description                        |
|----------------|-------------|--------|------------------------------------|
| `0x01`         | `EN`        | R/W    | Enable signal (bit 0 = enable)     |
| `0x05`         | `RST_N`     | R/W    | Synchronous reset (bit 0 = active) |
| `0x09`         | `DIR`       | R/W    | Direction: 0 = up, 1 = down        |
| `0x0D`         | `COUNT`     | R      | Current value of the counter       |




## Test counter.sv

- You can test the counter module individually with `counter_tb.sv` testbench using:

```makefile
make iverilog    # Compile generates .vvp file
make vpp         # Run simulation
make gtkwave     # View waveform in GTKWave
make clean       # Remove .vvp and .vcd files
make all         # Run both compilation and simulation

```

## Results GTKWave

- Result of the `counter_tb.sv` testbench:

![image](https://github.com/user-attachments/assets/e95049d1-6194-4113-a0c7-c8ffa9323c46)
