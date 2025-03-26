module uart_rx(
    #(parameter CLKS_PER_BIT)
    input i_clock,
    input i_Rx_serial,
    output o_Rx_DV,
    output [7:0] o_Rx_byte,
);
    parameter s_IDLE = 3'b000;
    parameter s_RX_START_BIT = 3'b001;
    parameter s_RX_DATA_BITS = 3'b010;
    parameter s_RX_STOP_BIT = 3'b011;
    parameter s_CLEAN_UP = 3'b100;

    reg r_Rx_DATA_p = 1'b1;
    reg r_Rx_Data = 1'b1;

    reg [7:0] r_Clock_Count = 0;
    reg [2:0] r_Bit_Index = 0;
    reg [7:0] r_Rx_Byte = 0;
    reg r_Rx_DV = 0;
    reg [2:0] r_SM_Main = 0;


    always@(posedge i_clock)begin
        r_Rx_DATA_p <= i_Rx_serial;
        r_Rx_Data <= r_Rx_DATA_p
    end
    

    //FSM logic 
    always@(posedge i_clock)begin
        case(r_SM_Main)
            S_IDLE: 
                begin
                    r_Rx_DV <= 1'b0;
                    r_Clock_Count <= 0;
                    r_Bit_Index <= 0;
                end 
                if(i_Rx_Data == 1'b0)begin
                    r_SM_Main <= s_RX_START_BIT;
                end else begin 
                    r_SM_Main <= s_IDLE;
                end 
            s_RX_START_BIT:
                begin
                    if(r_Clock_Count == (CLKS_PER_BIT - 1)/2)begin
                        if(i_Rx_Data == 1'b0)begin
                            r_Clock_Count <= 0;
                            r_SM_Main <= s_RX_DATA_BITS;
                        end 
                        else begin 
                            r_SM_Main <= s_IDLE;
                        end 
                    end else begin
                        r_Clock_Count <= 1 + r_Clock_Count;
                        r_SM_Main <= s_RX_START_BIT;
                    end 
                end 
            s_RX_DATA_BITS:
                begin
                    if(r_Clock_Count < CLKS_PER_BIT - 1)begin
                        r_SM_Main <= s_RX_DATA_BITS;
                        r_Clock_Count <= 1 + r_Clock_Count;
                    end 
                    else begin 
                        r_Clock_Count <= 0; //Because its the clock count per bit 
                        r_Rx_Byte[r_Bit_Index] <= i_Rx_Data; //If that cycle is done save the bit to the index in the byte listing
                        
                        if(r_Bit_Index < 7)begin
                            r_Bit_Index <= r_Bit_Index +1;
                            r_SM_Main <= s_RX_DATA_BITS;
                    end 




            
        endcase 

    end 

endmodule 