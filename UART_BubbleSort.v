
module UART(
    input i_CLOCK,
    input i_Rx_Serial,
    output o_Tx_Serial
);
    wire [7:0]r_Rx_Byte;
    wire r_Rx_DV;
    reg [7:0] recieved_data [7:0];
    reg [2:0] byte_index = 0;
    wire [7:0] i_Tx_Byte;
    wire r_Tx_DV;
    wire r_Tx_Active;
    wire r_Tx_Done;


    uart_rx #() uart_reciever(
        .i_clock(i_CLOCK),
        .i_Rx_serial(i_Rx_Serial),
        .o_Rx_DV(r_Rx_DV),
        .o_Rx_byte(r_Rx_Byte)
    );

    uart_tx #()uart_transmitter(
        .i_Clock(i_CLOCK),
        .i_Tx_DV(r_Rx_DV),
        .i_Tx_Byte(i_Tx_Byte),
        .o_Tx_Active(r_Tx_Active),
        .o_Tx_Bit(o_Tx_Serial),
        o_Tx_Done(r_Tx_Done)
    );
    always@(posedge i_CLOCK)begin
        if(r_Rx_DV == 1)begin
            recieved_data[byte_index] <= r_Rx_Byte;
            byte_index <= byte_index + 1;
        

            if(byte_index == 8)begin
                bubble_sort(recieved_data);
                transmit_data(recieved_data);
            end 
        end 
    end 


    task bubble_sort(input[7:0] data[7:0]);
        integer i, j;
        reg[7:0] temp;
        begin
            for(i = 0; i < 7; i = i + 1)begin
                for(j = 0; j < 7 - i; j + 1)begin
                    if( data[j] > data[j+1])begin
                        temp = data[j];
                        data[j] = data[j+1];
                        data[j+1] = temp;
                    end 
                end 
            end 
        end 
    endtask 

    task transmit_data(input[7:0] data[7:0]);
        integer k;
        begin
        for(k = 0; k < 8; k = k + 1)begin
            i_Tx_Byte = data[k]
            i_Tx_DV = 1;
            wait(o_Tx_Done == 1);
            i_Tx_DV = 0;
            end 
        end 
    endtask 

    

    

endmodule;