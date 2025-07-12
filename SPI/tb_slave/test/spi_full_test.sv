class spi_full_test#(parameter int WORD_LEN = 12) extends spi_base_test;
    `uvm_component_param_utils(spi_full_test#(WORD_LEN))

    function new(string name = "spi_full_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        spi_virtual_sequence seq1;
        phase.raise_objection(this);

        seq1 = spi_virtual_sequence#(.WORD_LEN(WORD_LEN))::type_id::create("seq1");
        seq1.start(env.spi_v_seq);
        
        phase.drop_objection(this);
    endtask
endclass