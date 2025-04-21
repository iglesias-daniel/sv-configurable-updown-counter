
SRC_DIR = src
TB_DIR = tb
BUILD_DIR = build

all: iverilog vvp
all_apb: iverilog_apb vvp_apb

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

iverilog: $(BUILD_DIR)
	iverilog -g2012 -o $(BUILD_DIR)/counter_tb.vvp $(SRC_DIR)/counter.sv $(TB_DIR)/counter_tb.sv

vvp:
	vvp $(BUILD_DIR)/counter_tb.vvp

gtkwave:
	gtkwave $(BUILD_DIR)/counter_tb.vcd

iverilog_apb: $(BUILD_DIR)
	iverilog -g2012 -o $(BUILD_DIR)/counter_apb_tb.vvp $(SRC_DIR)/counter_apb_wrapper.sv $(SRC_DIR)/counter.sv $(TB_DIR)/counter_apb_tb.sv

vvp_apb:
	vvp $(BUILD_DIR)/counter_apb_tb.vvp

gtkwave_apb:
	gtkwave $(BUILD_DIR)/counter_apb_tb.vcd

clean:
	rm -rf $(BUILD_DIR)/*.vvp $(BUILD_DIR)/*.vcd