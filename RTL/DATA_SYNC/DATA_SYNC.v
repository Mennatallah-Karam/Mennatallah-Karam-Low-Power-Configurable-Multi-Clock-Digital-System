module DataSynchronizer #(parameter BUS_WIDTH = 8 , parameter NUM_STAGES = 2)(
    input  wire [BUS_WIDTH-1:0] Unsync_bus, 
    input  wire bus_enable,                 
    input  wire CLK,                      
    input  wire RST,                        
    output reg  [BUS_WIDTH-1:0] sync_bus,   
    output reg  enable_pulse                
);


    wire  [BUS_WIDTH-1:0] sync_bus_c;
    reg   [NUM_STAGES - 1 : 0] sync_enable_FF;
    reg   sync_enable_F3;
    wire   enable_pulse_c;

    always @(posedge CLK or negedge RST)
     begin
        if (!RST) 
         begin
            sync_enable_FF <= 'b0;
         end 
        else 
         begin
            sync_enable_FF <= {sync_enable_FF [NUM_STAGES - 2 : 0] ,bus_enable};    
         end
    end

    always @(posedge CLK or negedge RST)
     begin
        if (!RST) 
            sync_enable_F3 <= 'b0;
        else
            sync_enable_F3 <= sync_enable_FF [NUM_STAGES - 1];  
     end

    assign enable_pulse_c = sync_enable_FF [NUM_STAGES - 1] & !sync_enable_F3;  

    always @(posedge CLK or negedge RST)
     begin
        if (!RST)
            enable_pulse <= 1'b0;  
        else
            enable_pulse <= enable_pulse_c;  
     end

    assign sync_bus_c = enable_pulse_c ? Unsync_bus : sync_bus; 

    always @(posedge CLK or negedge RST) 
     begin
        if (!RST) 
            sync_bus <= 0;
        else  
            sync_bus <= sync_bus_c;   
    end

endmodule

