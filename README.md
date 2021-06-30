# xohw21-Darwin-public
Team number: xohw21-222
Project name: Genomic co-processor for long read assembly FPGA
Date: 30/06/2021
Version of uploaded archive:1

University name: Politecnico di Milano
Supervisor name: Marco Domenico Santambrogio
Supervisor e-mail: marco.santambrogio@polimi.it
Participant: Marina Marti
Email: marina1.marti@mail.polimi.it
Participant: Alberto Zeni
Email: alberto.zeni@polimi.it


Board used: Xilinx Alveo U280
Vitis Version: 2020.2

# Project Organization
The RTL folder contains the RTL code
RTL/binary_container_1.xclbin contains the bitstream
The report of the development of the project is in REPORT_xohw21
host.cpp contains the host

# Project Description
Genomics data is transforming medicine and our understanding of life in fundamental ways; however, it is far outpacing Moore's Law. Third-generation sequencing technologies produce 100X longer reads than second generation technologies and reveal a much broader mutation spectrum of disease and evolution. However, these technologies incur prohibitively high computational costs. In order to enable the vast potential of exponentially growing genomics data, domain specific acceleration provides one of the few remaining approaches to continue to scale compute performance and efficiency, since general-purpose architectures are struggling to handle
the huge amount of data needed for genome alignment. The aim of this project is to implement a genomic-coprocessor targeting HPC FPGAs starting from the Darwin FPGA co-processor. In this scenario, the final objective is the simulation and implementation of the algorithms described by Darwin using Alveo boards, exploiting High Bandwidth Memory (HBM) to increase its performance.

# Usage
The repo already includes a host and a bitstream for the Alveo U280. Before executing the project be sure so source XRT.

# Execution
./host path_to_bitstream
The project has been written to run on the Xilinx Alveo U280. It has an executable called host and a bitstream file for the Alveo U280 called binary_container_1.xclbin.

# Link to YouTube Video
https://www.youtube.com/watch?v=P2iyTYlKXX0&t=8s
