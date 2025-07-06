class spi_scb extends uvm_component;

    `uvm_component_utils(spi_scb)

    virtual spi_if vif;

    function new(string name = "spi_scb", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual spi_if)::get(this, "", "spi_vif", vif))
            `uvm_fatal("NOVIF", "Could not get virtual interface 'spi_vif' from config_db.")
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            // Wait for a transaction to complete (done == 1)
            @(posedge vif.done);
    
            // Wait 1 clock cycle to ensure received_slave is updated
            @(posedge vif.clk);
    
            `uvm_info("SCOREBOARD", $sformatf("Master sent 0x%02h, Slave received 0x%02h",
                                              vif.data_in, vif.received_slave), UVM_MEDIUM)
    
            if (vif.data_in !== vif.received_slave) begin
                `uvm_error("SCOREBOARD", $sformatf("ERROR! Data received by slave (%h) does not match sent data (%h)",
                                                   vif.received_slave, vif.data_in))
            end else begin
                `uvm_info("SCOREBOARD", "Transaction OK!", UVM_LOW)
            end
        end
    endtask   

endclass
