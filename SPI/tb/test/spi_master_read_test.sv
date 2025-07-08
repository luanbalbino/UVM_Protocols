class spi_master_read_test extends spi_base_test;
    `uvm_component_utils(spi_master_read_test) 

    // Construtor
    function new(string name = "spi_master_read_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    virtual task run_phase(uvm_phase phase);
        spi_read_sequence read_seq;

        phase.raise_objection(this);

        read_seq = spi_read_sequence::type_id::create("read_seq");

        if (env.spi_v_seq != null) begin
            read_seq.start(env.spi_v_seq);
            `uvm_info(get_full_name(), "spi_read_sequence started.", UVM_LOW)
        end else begin
            `uvm_error(get_full_name(), "Sequencer handle is null. Cannot start sequence.")
        end

        phase.drop_objection(this);
    endtask

endclass