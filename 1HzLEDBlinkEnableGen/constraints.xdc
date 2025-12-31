###############################################################################
# Nexys A7-100T - LED blink project
###############################################################################

########################
# 100 MHz system clock
########################
# On-board oscillator is 100 MHz
# Connected to FPGA pin E3
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -name clk100 -period 10.000 [get_ports clk]

########################
# CPU RESET button (BTNRES)
########################
# Active-LOW pushbutton
# High when idle, LOW when pressed
# Connected to FPGA pin C12
set_property PACKAGE_PIN C12 [get_ports reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports reset_n]

########################
# LED0 (LD0)
########################
# LED0 is active-HIGH
# Connected to FPGA pin H17
set_property PACKAGE_PIN H17 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]
