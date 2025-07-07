class spi_monitor_in extends uvm_monitor;
    `uvm_component_utils(spi_monitor_in)

    virtual spi_if vif;

    uvm_analysis_port #(spi_transaction) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual spi_if)::get(this, "", "spi_vif", vif))
            `uvm_fatal("NOVIF", "Could not get virtual interface 'spi_vif'")
    endfunction

    task run_phase(uvm_phase phase);
        spi_transaction tr;

        forever begin
            @(posedge vif.start);

            tr = spi_transaction::type_id::create("tr", this);

            tr.data = vif.data_in;

            `uvm_info("MON_IN", $sformatf("Captured input: %0h", tr.data), UVM_MEDIUM)

            ap.write(tr);
        end
    endtask
endclass
