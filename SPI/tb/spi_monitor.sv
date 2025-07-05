// -----------------------------------------------------------------------------
// UVM Monitor - Observes SPI signals and generates transactions
// -----------------------------------------------------------------------------
class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)

    virtual spi_if vif;
    uvm_analysis_port #(spi_transaction) ap;

    function new(string name = "spi_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    task run_phase(uvm_phase phase);
        spi_transaction tr;
        `uvm_info(get_type_name(), $sformatf("@%0t: Monitor starting run_phase.", $time), UVM_MEDIUM)
        forever begin
            // Wait for the 'start' signal from the master to begin monitoring a new transaction
            `uvm_info(get_type_name(), $sformatf("@%0t: Waiting for START...", $time), UVM_MEDIUM)
            @(posedge vif.start);
            `uvm_info(get_type_name(), $sformatf("@%0t: Start detected, initiating transaction monitoring.", $time), UVM_LOW)

            tr = spi_transaction::type_id::create("tr", this);
            tr.data = vif.data_in; // Capture the data that the driver sent to the master

            // Wait for the 'done' signal from the master to indicate the end of the transmission
            `uvm_info(get_type_name(), $sformatf("@%0t: Before @(posedge vif.done), vif.done=%0b", $time, vif.done), UVM_MEDIUM)
            @(posedge vif.done);
            `uvm_info(get_type_name(), $sformatf("@%0t: Done detected, transaction completed.", $time), UVM_LOW)

            ap.write(tr); // Publish the complete transaction
            `uvm_info(get_type_name(), $sformatf("@%0t: Monitored transaction: Sent=0x%0h.", $time, tr.data), UVM_HIGH)
        end
    endtask
endclass