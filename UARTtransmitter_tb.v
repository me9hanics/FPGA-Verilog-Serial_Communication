`timescale 1ns / 1ps
module uarttest;
  // Inputs
  reg clk;
  reg rst;
  reg [3:0] bcd0;
  reg [3:0] bcd1;
  // Outputs
  wire tx_out;

  // Instantiate the Unit Under Test (UUT)
uart uut (
.clk(clk),
.rst(rst),
.bcd0(bcd0),
.bcd1(bcd1),
.tx_out(tx_out)
);
  
initial begin
  // Initialize Inputs
  clk = 1;
  rst = 1;
  bcd0 = 0;
  bcd1 = 0;
  // Wait 100 ns for global reset to finish
  #100;
  rst=0;
  #500
  bcd1=2;
  bcd0=0;
  #500
  bcd1=0;
  //bcd0=0;
  #500
  bcd1=1;
  bcd0=1;
  #500
  bcd1=0;
  bcd0=4;
end

always #1 clk = ~clk;

endmodule
