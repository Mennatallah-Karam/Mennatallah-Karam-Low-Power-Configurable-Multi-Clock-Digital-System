module RST_SYNC #(parameter NUM_STAGES = 2)(
    input wire CLK,           
    input wire RST,          
    output wire SYNC_RST
);


   reg [NUM_STAGES - 1 : 0] FFs;
   assign SYNC_RST = FFs[NUM_STAGES - 1];
          

    always @(posedge CLK or negedge RST)
     begin
        if (!RST) 
         begin
            FFs <= 1'b0;        
         end 
        else
         begin
            FFs <= {FFs[NUM_STAGES - 2 : 0] , 1'b1};         
         end
     end
endmodule
