class spi_monitor #(parameter int WORD_LEN = 12) extends uvm_monitor;
    `uvm_component_utils(spi_monitor#(WORD_LEN))

    virtual spi_if #(WORD_LEN) vif;
    uvm_analysis_port #(spi_seq_item #(WORD_LEN)) ap;

    function new(string name = "spi_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual spi_if #(WORD_LEN))::get(this, "", "spi_vif", vif)) begin
            `uvm_fatal(get_type_name(), "Virtual interface 'spi_vif' not set for monitor!");
        end
    endfunction

    task run_phase(uvm_phase phase);
        spi_seq_item #(WORD_LEN) tr;
        bit [WORD_LEN-1:0] rx_data, tx_data;
        int bit_cnt;
        bit last_cs_n, last_sclk;
        bit cpol, cpha;
        bit sample_edge;

        wait (vif.rst_n == 1);
        @(posedge vif.clk);

        forever begin
            do @(posedge vif.clk); while (vif.cs_n == 1);

            tr = spi_seq_item #(WORD_LEN)::type_id::create("tr", this);
            rx_data = 0;
            tx_data = 0;
            bit_cnt = 0;

            cpol = vif.cpol;
            cpha = vif.cpha;
            last_sclk = vif.sclk;

            `uvm_info(get_type_name(), $sformatf("Transaction - CPOL: %0b, CPHA: %0b", cpol, cpha), UVM_MEDIUM)

            while (vif.cs_n == 0 && bit_cnt < WORD_LEN) begin
                @(posedge vif.clk);
                sample_edge = (cpha == 0) ? (vif.sclk !== last_sclk && vif.sclk == ~cpol)   // CPHA=0
                                          : (vif.sclk !== last_sclk && vif.sclk == cpol);   // CPHA=1

                if (sample_edge) begin
                    rx_data = {rx_data[WORD_LEN-2:0], vif.mosi};
                    tx_data = {tx_data[WORD_LEN-2:0], vif.miso};
                    `uvm_info(get_type_name(), $sformatf("Bit[%0d] captured: MOSI=%0b, MISO=%0b", bit_cnt, vif.mosi, vif.miso), UVM_DEBUG);
                    bit_cnt++;
                end

                last_sclk = vif.sclk;
            end

            tr.mosi_data     = rx_data;
            tr.miso_expected = tx_data; 
            tr.spi_mode      = {cpol, cpha};

            `uvm_info(get_type_name(), $sformatf("Full transaction - MOSI: 0x%0h, MISO: 0x%0h", rx_data, tx_data), UVM_MEDIUM)

            ap.write(tr);
        end
    endtask

endclass
