// -----------------------------------------------------------------------------
// UVM Test
// -----------------------------------------------------------------------------
class spi_base_test extends uvm_test;
    `uvm_component_utils(spi_base_test)

    localparam WORD_LEN = 12;
    spi_env#(WORD_LEN) env;

    function new(string name = "spi_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = spi_env#(.WORD_LEN(WORD_LEN))::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
    
        `uvm_info(get_type_name(), "TEST BASE CLASS.. DOING NOTHING FOR NOW", UVM_NONE)
    
        phase.drop_objection(this);
    endtask
    
endclass


