# Lighter

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![example workflow](https://github.com/kanndil/Lighter/actions/workflows/main.yml/badge.svg)
[![code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)

An automatic clock gating utility. 



## Table of contents

* [Overview](https://github.com/kanndil/Lighter#overview)
* [File structure](https://github.com/kanndil/Lighter#file-structure)
* [How to use](https://github.com/kanndil/Lighter#how-to-use)
* [How it works](https://github.com/kanndil/Lighter#how-does-it-work)
* [Power reduction analysis](https://github.com/kanndil/Lighter#power-reduction-analysis)
* [Authors](https://github.com/kanndil/Lighter#authors)
* [Copyright and Licensing](https://github.com/kanndil/Lighter#copyright-and-licensing)


# Overview


Clock gating is a technique used to reduce the dynamic power by reducing the activation factor of the flip-flops in the design significantly, correspondingly reducing their switching frequency, by adding a clock gate cell at the input of each register.

The clock-gating problem is transformed into a graph problem with the help of Yosys RTLIL (register transfer level intermediate language), where the tool replaces all flipflops with enable inputs into clock-gated flipflops. 

<!--//include clkgate image-->

This is a technology generic automatic clock gating tool, that takes an RTL design and a technology specification Jason file, then auto creates and runs a Yosys synthesis script and a clock-gate map file. The tool produces, a clock-gated gate-level design along with power reduction reports. 



<!--// rephrase
This repo provides a script to be run by the Yosys software, and attached to it is a map file that is used to map all flipflops with enable inputs into clock-gated flipflops. An auto-testing python code is also implemented to autotest and analyze the dynamic power reduction of the provided design.-->


## File structure

* [designs](https://github.com/kanndil/Lighter/tree/main/designs) / conatains verilog designs for benchmarking
* [docs/](https://github.com/kanndil/Lighter/tree/main/docs) contains documentation
* [platform/](https://github.com/kanndil/Lighter/tree/main/platform/sky130) contains standard cell libraries 
* [report_power/](https://github.com/kanndil/Lighter/tree/main/report_power) contains power reporting python code (report_power.py) 
    * [stats/](https://github.com/kanndil/Lighter/tree/main/report_power/stats) contains full benchmarking results
* [src/](https://github.com/kanndil/Lighter/tree/main/src) contains clock gating Yosys plugin code
* [validation/](https://github.com/kanndil/Lighter/tree/main/validation) contains automatic validation python code for clock-gated designs

    
## Dependencies

    - Yosys     latest version
    - OpenSta   latest version

You can find their installation steps in dependencies.txt

[dependencies](https://github.com/youssefkandil/Dynamic_Power_Clock_Gating/blob/main/dependencies.txt)


# How to use

Generate the Yosys plugin using the following command:

    yosys-config --build cg_plugin.so clock_gating_plugin.cc


Add the flipflop clock gating command to your synthesis script:


    read_verilog lib/blackbox_clk_gates.v
    clock_gating lib/map_file.v


For example:

    read_verilog design
    read_verilog lib/blackbox_clk_gates.v
    hierarchy -check
    synth -top design
    dfflibmap -liberty lib/sky130_hd.lib 
    abc -D 1250 -liberty lib/sky130_hd.lib 
    splitnets
    opt_clean -purge
    opt;; 
    write_verilog -noattr -noexpr -nohex -nodec -defparam   design.gl.v


Run your Yosys synthesis script as follows:

    yosys -m cg_plugin.so -p your_script.ys

Or TCL synthesis script as follows:

    yosys -m cg_plugin.so -p your_script.tcl



# How it works

A detailed guide can be found [here](https://github.com/kanndil/Lighter/blob/main/docs/how_does_it_work.md)


# Power reduction analysis
|Design          |# Cells |# Clock Gates|Power reduction %      |Cells reduction %    |
|----------------|--------|-------------|-----------------------|---------------------|
|AHB_SRAM        |245     |7            |23.67%                 |25.71%               |
|blake2s         |14225   |16           |10.05%                 |-0.20%               |
|chacha          |12857   |26           |15.19%                 |-0.19%               |
|genericfir      |143703  |128          |4.17%                  |-0.98%               |
|i2c_master      |759     |21           |15.48%                 |10.41%               |
|jpeg_encoder    |63757   |388          |31.38%                 |11.83%               |
|ldpcenc         |19947   |28           |45.23%                 |6.19%                |
|NfiVe32_RF      |3362    |32           |31.26%                 |30.58%               |
|picorv32a       |14348   |85           |21.85%                 |12.02%               |
|PPU             |10156   |405          |22.81%                 |32.55%               |
|prv32_cpu       |2186    |10           |29.21%                 |23.97%               |
|rf_64x64        |13461   |64           |32.39%                 |31.97%               |
|sha512          |20240   |74           |30.59%                 |12.82%               |
|spi_master      |179     |8            |13.85%                 |18.99%               |
|y_quantizer     |8281    |16           |1.81%                  |1.92%                |
|zigzag          |3807    |65           |33.46%                 |58.21%               |

# Authors

* [Mohamed Shalan](https://github.com/shalan)
* [Youssef Kandil](https://github.com/kanndil)


# ⚖️ Copyright and Licensing

Copyright 2022 AUC Open Source Hardware Lab

Licensed under the Apache License, Version 2.0 (the "License"); 
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.