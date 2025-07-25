interface apb_if(
    input bit PCLK, 
    input bit PRESETn
);
    logic PSEL;
    logic PENABLE;
    logic PWRITE;       
    logic [0:3] PSTRB;  
    logic [31:0] PADDR; 
    
    logic [31:0] PWDATA; 
    logic [31:0] PRDATA;
    
    logic PREADY;       
    logic PSLVERR;      
    
    modport MASTER (
        input PCLK,   
        input PRESETn,
        
        output PSEL,
        output PENABLE,
        output PWRITE,
        output PSTRB,
        output PADDR,
        output PWDATA,

        input PRDATA,
        input PREADY,
        input PSLVERR
    );

    modport SLAVE (
        // Inputs to the slave
        input PSEL,
        input PENABLE,
        input PWRITE,
        input PSTRB,
        input PADDR,
        input PWDATA,
        
        // Outputs from the slave
        output PRDATA,
        output PREADY,
        output PSLVERR
    );

    // Modport for a MONITOR (reads all signals)
    modport MONITOR (
        input PSEL,
        input PENABLE,
        input PWRITE,
        input PSTRB,
        input PADDR,
        input PWDATA,
        input PRDATA,
        input PREADY,
        input PSLVERR,
        input PCLK,
        input PRESETn
    );

endinterface: apb_if