// -----------------------------------------------------------------------------
// UVM Driver - Sends SPI transactions to the DUT
// -----------------------------------------------------------------------------
class spi_driver#(parameter int WORD_LEN = 12) extends uvm_driver #(spi_seq_item#(WORD_LEN));
    `uvm_component_utils(spi_driver)

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
        spi_seq_item tr;

        wait (vif.rst_n == 1);
        repeat (5) @(posedge vif.clk);

        forever begin
            seq_item_port.get_next_item(tr);
            `uvm_info(get_type_name(), $sformatf("Sending transaction with mosi_data: 0x%0h", tr.mosi_data), UVM_MEDIUM)

            master_stimuli(tr);

            seq_item_port.item_done();
        end
    endtask
    
    task master_stimuli(spi_seq_item tr);
        // Local variables
        int bit_idx;
        logic [WORD_LEN-1:0] data; 
    
        // Extract mode
        logic cpol = tr.spi_mode[1];
        logic cpha = tr.spi_mode[0]; //00,01,10,11
        
        logic sclk_val;
        logic mosi_bit;
        int half_period = 5; // Half-period of SPI clock in simulation time units
        
        vif.cpol <= tr.spi_mode[1];
        vif.cpha <= tr.spi_mode[0];
    
        vif.data <= tr.mosi_data; // This line seems to be for monitor, not active driver signal control
    
        // Initialize signals to idle state
        vif.cs_n <= 1'b1;
        vif.sclk <= cpol;    // Set SCLK to idle level (CPOL)
        vif.mosi <= 1'b0;
        @(posedge vif.clk);  // Synchronize initial state with testbench clock
        
        // Activate CS to begin SPI transaction
        vif.cs_n <= 1'b0;
        @(posedge vif.clk);  // Wait one testbench clock cycle after CS_n goes low
        
        // Transmit each bit
        for (bit_idx = 0; bit_idx < WORD_LEN; bit_idx++) begin
            // Get bit to transmit (MSB first)
            mosi_bit = tr.mosi_data[WORD_LEN - 1 - bit_idx];
    
            if (cpha == 0) begin // CPHA = 0 (Mode 0 & 2): Sample on first edge, shift on second
                // 1. Setup MOSI while SCLK is in IDLE state (before active edge)
                vif.mosi <= mosi_bit; 
                @(posedge vif.clk)     // Wait for MOSI to stabilize and SCLK to remain IDLE for half_period
    
                // 2. Transition SCLK to its ACTIVE state (this is the sampling edge for the slave)
                vif.sclk <= ~cpol; 
                @(posedge vif.clk)     // Wait for the active half-cycle
    
                // 3. Transition SCLK back to its IDLE state (this is typically the shifting edge for the slave)
                vif.sclk <= cpol; 
                // No delay here, as the next bit cycle will start with MOSI setup after this
            end else begin // CPHA == 1 (Mode 1 & 3): Shift on first edge, sample on second
                // 1. Transition SCLK to its ACTIVE state AND change MOSI simultaneously
                // (This is the shifting edge for the slave)
                vif.sclk <= ~cpol; 
                vif.mosi <= mosi_bit; 
                @(posedge vif.clk)     // Wait for the active half-cycle
    
                // 2. Transition SCLK back to its IDLE state (this is the sampling edge for the slave)
                vif.sclk <= cpol; 
                @(posedge vif.clk);     // Wait for the idle half-cycle
            end
    
            // Abort transaction if cs_toggle is requested (for fault injection/specific scenarios)
            if (tr.cs_toggle && bit_idx == (WORD_LEN/2)) begin
                vif.cs_n <= 1'b1;
            end
        end
    
        // End transaction and return lines to idle
        vif.cs_n <= 1'b1;   // Deactivate Chip Select
        vif.mosi <= 1'b0;   // Set MOSI to default low
        vif.sclk <= cpol;   // Return SCLK to its idle state
        @(posedge vif.clk); // Synchronize transaction end with testbench clock
        repeat(3) @(posedge vif.clk); // Add some idle cycles for stability before next transaction
    endtask

endclass
