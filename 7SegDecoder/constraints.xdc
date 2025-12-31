###############################################################################
# Nexys A7-100T — 7-segment decoder
###############################################################################

########################
# 4-bit input: slide switches SW0–SW3
########################
set_property PACKAGE_PIN J15 [get_ports {bin[0]}]  ;# SW0
set_property PACKAGE_PIN L16 [get_ports {bin[1]}]  ;# SW1
set_property PACKAGE_PIN M13 [get_ports {bin[2]}]  ;# SW2
set_property PACKAGE_PIN R15 [get_ports {bin[3]}]  ;# SW3

set_property IOSTANDARD LVCMOS33 [get_ports {bin[*]}]

########################
# 7-segment segment lines (active-LOW)
# seg[6:0] = CA,CB,CC,CD,CE,CF,CG
# seg[7]   = DP
########################
set_property PACKAGE_PIN T10 [get_ports {seg[0]}]  ;# CA
set_property PACKAGE_PIN R10 [get_ports {seg[1]}]  ;# CB
set_property PACKAGE_PIN K16 [get_ports {seg[2]}]  ;# CC
set_property PACKAGE_PIN K13 [get_ports {seg[3]}]  ;# CD
set_property PACKAGE_PIN P15 [get_ports {seg[4]}]  ;# CE
set_property PACKAGE_PIN T11 [get_ports {seg[5]}]  ;# CF
set_property PACKAGE_PIN L18 [get_ports {seg[6]}]  ;# CG
set_property PACKAGE_PIN H15 [get_ports {seg[7]}]  ;# DP

set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]

########################
# 7-segment digit enables (AN0–AN7, active-LOW)
########################
set_property PACKAGE_PIN J17 [get_ports {pnp[0]}]  ;# AN0
set_property PACKAGE_PIN J18 [get_ports {pnp[1]}]  ;# AN1
set_property PACKAGE_PIN T9 [get_ports {pnp[2]}]  ;# AN2
set_property PACKAGE_PIN J14 [get_ports {pnp[3]}]  ;# AN3
set_property PACKAGE_PIN P14 [get_ports {pnp[4]}]  ;# AN4
set_property PACKAGE_PIN T14 [get_ports {pnp[5]}]  ;# AN5
set_property PACKAGE_PIN K2 [get_ports {pnp[6]}]  ;# AN6
set_property PACKAGE_PIN U13 [get_ports {pnp[7]}]  ;# AN7

set_property IOSTANDARD LVCMOS33 [get_ports {pnp[*]}]
