# Load RUCKUS library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Load Source Code
if { $::env(VIVADO_VERSION) >= 2016.4 } {

   loadSource -lib surf -dir  "$::DIR_PATH/rtl"

   # Load IP Code
   # loadIpCore -lib surf -path "$::DIR_PATH/ip/SemCore.xci"
   loadSource -lib surf -path "$::DIR_PATH/ip/SemCore.dcp"

} else {
   puts "\n\nWARNING: $::DIR_PATH requires Vivado 2016.4 (or later)\n\n"
}   
   