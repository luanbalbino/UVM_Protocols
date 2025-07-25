class apb_monitor extends uvm_monitor;
    `uvm_component_utils(apb_monitor)
    
    apb_trans trans;
    virtual apb_if.MONITOR vif;
    uvm_analysis_port#(apb_trans) dut_read_ap;
    uvm_analysis_port#(apb_trans) refmod_ap;

    function new(string name = "apb_monitor", uvm_component parent = null);
        super.new(name, parent);
        dut_read_ap = new("dut_read_ap", this);
        refmod_ap = new("refmod_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual apb_if.MONITOR)::get(this, "", "vif", vif)) begin
            `uvm_fatal("WRITE MONITOR", "Failed to get vif from config DB")
        end
    endfunction

	// I need to review this part...
    task run_phase(uvm_phase phase);
        apb_trans trans;
        forever begin
            wait (vif.PRESETn === 1'b1);
    
            @(posedge vif.PCLK);
            wait (vif.PSEL === 1'b1 && vif.PENABLE === 1'b0);
    
            trans = apb_trans::type_id::create("trans");
    
            trans.PRESETn = vif.PRESETn;
            trans.PSEL    = vif.PSEL;
            trans.PWRITE  = vif.PWRITE;
            trans.PADDR   = vif.PADDR;
            trans.PWDATA  = vif.PWDATA;
            trans.PSTRB   = vif.PSTRB;
            trans.PENABLE = vif.PENABLE;
    
            if (trans.PWRITE)
                `uvm_info("WRITE MONITOR", $sformatf("Detected Write Setup: ADDR=0x%0h, DATA=0x%0h", trans.PADDR, trans.PWDATA), UVM_LOW)
            else
                `uvm_info("READ MONITOR", $sformatf("Detected Read Setup: ADDR=0x%0h", trans.PADDR), UVM_LOW)
    
            wait (vif.PENABLE === 1'b1);
            @(posedge vif.PCLK);
    
            wait (vif.PREADY === 1'b1);
            @(posedge vif.PCLK);
    
            trans.PREADY  = vif.PREADY;
            trans.PSLVERR = vif.PSLVERR;
            trans.PRDATA  = vif.PRDATA;
    
            if (trans.PWRITE)
                `uvm_info("MONITOR", $sformatf("Completed WRITE TX: ADDR=0x%0h, PWDATA=0x%0h, READY=%0d", trans.PADDR, trans.PWDATA, trans.PREADY), UVM_LOW)
            else
                `uvm_info("MONITOR", $sformatf("Completed READ TX: ADDR=0x%0h, PRDATA=0x%0h, READY=%0d", trans.PADDR, trans.PRDATA, trans.PREADY), UVM_LOW)
            
            refmod_ap.write(trans);
    
            if (!trans.PWRITE) begin
                apb_trans tr = apb_trans::type_id::create("tr");
                tr.copy(trans);
                dut_read_ap.write(tr);
            end
        end
    endtask
    

endclass
