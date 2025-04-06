`timescale 1ns/10ps
//`include "uart_Receiver.v"
//`include "uart_Transmitter.v"

module uart_tb();

    // Testbench uses a 10 MHz clock
    // Want to interface to 115200 baud UART
    // 10000000 / 115200 = 87 Clocks Per Bit.

    parameter c_Clock_Cycle_Time = 64;
    //parameter c_CLKS_PER_BIT = 87;
    parameter c_Bit_Period = 3648; // 1/ baud rate is 1/115200 8.68 micro seconds 

    reg r_Clock = 0;
    reg r_Rx_Serial = 1;
    wire [7:0] w_Rx_Byte;
    reg r_Tx_DV = 0;
    wire w_Tx_Done;
    reg [7:0] r_Tx_Byte = 0;

    uart_rx uart_RX_tb
    (
        .i_clock(r_Clock),
        .i_Rx_serial(r_Rx_Serial),
        .o_Rx_DV(),
        .o_Rx_byte(w_Rx_Byte)
    );

    uart_tx uart_TX_tb
    (
        .i_Clock(r_Clock),
        .i_Tx_DV(r_Tx_DV),
        .i_Tx_Byte(r_Tx_Byte),
        .o_Tx_Active(),
        .o_Tx_Bit(),
        .o_Tx_Done(w_Tx_Done)
    );

    task UART_WRITE_BYTE;
        input [7:0] i_Data;
        integer i;
        begin

            //Send Start Data
            r_Rx_Serial <= 1'b0;
            #(c_Bit_Period)
            //#1000;
            //Send data bits
            for(i = 0; i < 8; i = i + 1)
                begin
                    r_Rx_Serial <= i_Data[i];
                    #(c_Bit_Period);
                end
            
            //Send stop bit
            r_Rx_Serial <= 1'b1;
            #(c_Bit_Period);
        end 
    endtask 

    always
        #(c_Clock_Cycle_Time/2) r_Clock <= !r_Clock;
    
    initial 
    begin 
        @(posedge r_Clock);
        @(posedge r_Clock);
        r_Tx_DV = 1'b1;
        r_Tx_Byte = 8'hAB;
        @(posedge r_Clock);
        r_Tx_DV = 1'b0;
        @(posedge w_Tx_Done);

        @(posedge r_Clock);
        UART_WRITE_BYTE(8'h3F);
        @(posedge r_Clock);

        if(w_Rx_Byte == 8'h3F)begin
            $display ("Test Passed - Correct Byte Recieved");
        end 
        else begin
            $display("Test Failed- Incorrect Byte Recieved");
        end 
 end 
endmodule 
