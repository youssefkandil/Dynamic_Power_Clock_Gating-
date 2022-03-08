
yosys -import
set design PPU
puts "in tcl $design"
read_verilog $design/$design.v
hierarchy -check -top $design
synth -top $design
opt;; 
memory_collect
memory_map
opt;; 

dfflibmap -liberty sky130_hd.lib 
abc -D 1250 -liberty sky130_hd.lib 
splitnets
opt_clean -purge
hilomap -hicell sky130_fd_sc_hd__conb_1 HI -locell sky130_fd_sc_hd__conb_1 LO
splitnets
opt_clean -purge
insbuf -buf sky130_fd_sc_hd__buf_2 A X
dffinit
opt;; 
write_verilog -noattr -noexpr -nohex -nodec -defparam   $design/before_gl.v
            