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
        spi_virtual_sequence seq_h;
        phase.raise_objection(this);
    
        seq_h = spi_virtual_sequence#(.WORD_LEN(WORD_LEN))::type_id::create("seq_h");
        seq_h.start(env.spi_v_seq);
    
        phase.drop_objection(this);
    endtask
    
endclass


