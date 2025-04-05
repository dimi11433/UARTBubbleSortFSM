`timescale 1ns/10ps
`include "uart_Receiver.v"
`include "uart_Transmitter.v"

module uart_tb();

    // Testbench uses a 10 MHz clock
    // Want to interface to 115200 baud UART
    // 10000000 / 115200 = 87 Clocks Per Bit.

    parameter c_Clock_Cycle_Time = 100;
    parameter c_CLKS_PER_BIT = 87;
    parameter c_Bit_Period = 8600; // 1/ baud rate is 1/115200 8.68 micro seconds 

    reg r_Clock = 0;
    reg r_Rx_Serial = 1;
    wire [7:0] w_Rx_Byte;
    reg r_Tx_DV = 0;
    wire w_Tx_Done;
    reg [7:0] r_Tx_Byte = 0;

    





endmodule 