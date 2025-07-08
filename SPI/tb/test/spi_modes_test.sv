// -----------------------------------------------------------------------------
// SPI Test - Testa todos os modos CPOL/CPHA
// -----------------------------------------------------------------------------
`ifndef SPI_MODES_TEST_SV
`define SPI_MODES_TEST_SV

class spi_modes_test extends spi_base_test;
    `uvm_component_utils(spi_modes_test)

    function new(string name = "spi_modes_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        spi_modes_sequence seq1;
        phase.raise_objection(this);
        seq1 = spi_modes_sequence::type_id::create("seq1");
        seq1.start(env.spi_v_seq);
        phase.drop_objection(this);
    endtask
endclass

`endif
