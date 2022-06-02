
A UART transmitter in Verilog, using Xilinx ISE, simulated by Chipscope Integrated Logic Analyzer, then tested it with an FPGA, in the university laboratory.

Testbench simulation: 
(Changed bd's value from 833 to 2 to make the simulation more visible. This way, one bit in the simulation corresponds for 6ns time interval.)

![v1](https://user-images.githubusercontent.com/82604073/171662391-60a02ebc-1a57-461f-be18-429d01baee96.png)

The first change of bits comes at 112ns, when the first start bit appears (here the output is 00h). 

![v2](https://user-images.githubusercontent.com/82604073/171662404-29dc31ec-de10-47c2-82a9-5d9e9ac2f8b1.png)

Here, we've sent the character "2".

At 916ns, a stop bit comes. At 922ns, comes a start bit, after that, every 6ns, we can read the 7-bit data: 0100110, which from LSB to MSB corresponds to 32h, which is the ASCII value for "2", thus the transmission was correct. After this comes a stopbit in the end.
