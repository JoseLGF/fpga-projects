# fpga-code
All my source files for FPGA

## Project description

All my developments for FPGA projects are located here.

## Folder Structure
It is basically divided in two sections:
- Components: This folder contains a library of reusable VHDL components.
- Projects: All other folders in the repo are FPGA projects, working with vivado.

## Building the projects
Every component in the Components library, as well as some of the latest
projects are built in such a way that they can be built automatically by a CI 
System such as Jenkins.

## Tools
The project uses mostly the following tools:
- GHDL: This is used mostly for simulating vhdl files in the components library.
- GtkWave: Optional. This tool can be used to visualize the waveforms generated
by ghdl.
- Vivado 2018: Used for creating FPGA projects with Xilinx boards.
- KCPSM6: This is not used to build the project, but is used to convert assembly
files into ROM/RAM components for picoblaze projects.
- ISE 14.7 Needed in order to reprogram a picoblaze controller running on an
active design.

## Setup
1. Install GHDL and add it to path
2. Install GtkWave and add it to path.
3. Install Vivado 2018 and ensure it is added to path.
4. In order to reprogram the picoblaze via USB-jtag, install Xilinx ISE 14.7.