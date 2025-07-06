// -----------------------------------------------------------------------------
// UVM Test
// -----------------------------------------------------------------------------
class spi_base_test extends uvm_test;
    `uvm_component_utils(spi_base_test)

    spi_env env;

    function new(string name = "spi_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = spi_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        spi_sequence seq_h;
        phase.raise_objection(this);
    
        seq_h = spi_sequence::type_id::create("seq_h");
        seq_h.start(env.seq);
    
        phase.drop_objection(this);
    endtask
    
endclass


