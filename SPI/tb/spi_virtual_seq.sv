class spi_virtual_seq extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(spi_virtual_seq)

    // Virtual sequencer handle if needed in the future
    spi_sequencer v_seqr;

    function new(string name = "spi_virtual_seq");
        super.new(name);
    endfunction

    task body();
        uvm_sequence_base seq;

        if (!uvm_config_db#(uvm_object_wrapper)::get(null, get_full_name(), "selected_test_sequence", seq)) begin
            `uvm_fatal("VSEQ", "No sequence specified via +UVM_TEST_SEQ=<sequence_name>")
        end

        `uvm_info("VSEQ", $sformatf("Running test sequence: %s", seq.get_type_name()), UVM_MEDIUM)

        // Clone and execute the selected sequence
        seq = seq.clone();
        void'(seq.randomize());
        seq.start(v_seqr, this);
    endtask
endclass