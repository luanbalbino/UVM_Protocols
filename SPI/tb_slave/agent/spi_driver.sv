// -----------------------------------------------------------------------------
// UVM Driver - Sends SPI transactions to the DUT
// -----------------------------------------------------------------------------
class spi_driver#(parameter int WORD_LEN = 12) extends uvm_driver #(spi_seq_item#(WORD_LEN));
    `uvm_component_utils(spi_driver#(WORD_LEN))

    virtual spi_if #(WORD_LEN) vif; // Virtual interface to access SPI signals

    function new(string name = "spi_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual spi_if#(WORD_LEN))::get(this, "", "spi_vif", vif)) begin
            `uvm_fatal(get_type_name(), "Virtual interface 'vif' not set for driver!")
        end
    endfunction

    task run_phase(uvm_phase phase);
        spi_seq_item#(WORD_LEN) tr;

        wait (vif.rst_n == 1);
        @(posedge vif.clk);

        forever begin
            seq_item_port.get_next_item(tr);
            `uvm_info(get_type_name(), $sformatf("Sending transaction with mosi_data: 0x%0h", tr.mosi_data), UVM_MEDIUM)

            master_stimuli(tr);

            seq_item_port.item_done();
        end
    endtask
    
    task master_stimuli(spi_seq_item#(WORD_LEN) tr);
        // Local variables
        int bit_idx;

        logic [WORD_LEN-1:0] mosi_data; 
    
        // Extract mode
        logic cpol = tr.spi_mode[1];
        logic cpha = tr.spi_mode[0];
        
        logic sclk_val;
        logic mosi_bit;
        
        vif.cpol <= tr.spi_mode[1];
        vif.cpha <= tr.spi_mode[0];
    
        vif.mosi_data <= tr.mosi_data; // Just to track signal
    
        // Initialize signals to idle state
        vif.cs_n <= 1'b1;
        vif.sclk <= cpol;    // Set SCLK to idle level (CPOL)
        vif.mosi <= 1'b0;
        @(posedge vif.clk); 
        
        // Activate CS to begin SPI transaction
        vif.cs_n <= 1'b0;
        @(posedge vif.clk); 
        
        // Transmit each bit
        for (bit_idx = 0; bit_idx < WORD_LEN; bit_idx++) begin
            mosi_bit = tr.mosi_data[WORD_LEN - 1 - bit_idx];
    
            if (cpha == 0) begin // CPHA = 0 (Mode 0 & 2) -> Sample on first edge, shift on second
                vif.mosi <= mosi_bit; 
                @(posedge vif.clk) 
    
                vif.sclk <= ~cpol; 
                @(posedge vif.clk)    
    
                vif.sclk <= cpol; 

            end else begin // CPHA == 1 (Mode 1 & 3) -> Shift on first edge, sample on second
                vif.sclk <= ~cpol; 
                vif.mosi <= mosi_bit; 
                @(posedge vif.clk)    
    
                vif.sclk <= cpol; 
                @(posedge vif.clk);    
            end
    
            // Abort transaction if cs_toggle is requested (for fault injection/specific scenarios)
            if (tr.cs_toggle && bit_idx == (WORD_LEN/2)) begin
                vif.cs_n <= 1'b1;
                `uvm_info(get_type_name(), $sformatf("Transaction aborted because cs toogle"), UVM_MEDIUM)
                break; 
            end
        end
    
        vif.cs_n <= 1'b1;   
        vif.mosi <= 1'b0; 
        vif.sclk <= cpol;   
        @(posedge vif.clk); 
        repeat(3) @(posedge vif.clk); // Some idle cycles for stability before next transaction
    endtask

endclass
