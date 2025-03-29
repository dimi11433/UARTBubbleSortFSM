module uart_tx(
    #(parameter CLKS_PER_BIT)
    input i_Clock,
    input i_Tx_DV,
    input [7:0] i_Tx_Byte,
    output o_Tx_Active,
    output reg o_Tx_Bit,
    output o_Tx_Done
);

    parameter s_IDLE = 3'b000;
    parameter s_TX_START_BIT = 3'b001;
    parameter s_TX_DATA_BITS = 3'b010;
    parameter s_TX_STOP_BIT = 3'b011;
    parameter s_CLEAN_UP = 3'b100;
    


endmodule 