// -----------------------------------------------------------------------------
// UVM Driver - Sends SPI transactions to the DUT
// -----------------------------------------------------------------------------
class spi_driver extends uvm_driver #(spi_transaction);
    `uvm_component_utils(spi_driver)

    virtual spi_if vif;

    function new(string name = "spi_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        // Add an initial delay to ensure the DUT's reset is released
        // The reset in top.sv is released at #100ns.
        // We wait a bit longer to ensure the DUT is in IDLE.
        `uvm_info("DRIVER", $sformatf("@%0t: Driver starting run_phase.", $time), UVM_MEDIUM)
        @(posedge vif.clk); // Wait for the first clock edge
        while (vif.rst_n == 1'b0) begin
            `uvm_info("DRIVER", $sformatf("@%0t: Waiting for rst_n to be released (rst_n=%0b).", $time, vif.rst_n), UVM_MEDIUM)
            @(posedge vif.clk); // Wait for rst_n to go high
        end
        repeat(5) @(posedge vif.clk); // Wait a few clock cycles for stabilization after reset
        `uvm_info("DRIVER", $sformatf("@%0t: rst_n released, DUT stabilized.", $time), UVM_MEDIUM)


        forever begin
            spi_transaction tr;
            `uvm_info("DRIVER", $sformatf("@%0t: Waiting for next sequence item...", $time), UVM_MEDIUM)
            seq_item_port.get_next_item(tr);
            `uvm_info("DRIVER", $sformatf("@%0t: Item received from sequence: 0x%0h", $time, tr.data), UVM_MEDIUM)


            // Apply data to the DUT
            // The DUT expects data_in to be valid when start is pulsed
            vif.data_in <= tr.data;
            vif.start <= 1'b1; // Assert start
            `uvm_info("DRIVER", $sformatf("@%0t: Sending data 0x%0h, asserting START", $time, tr.data), UVM_MEDIUM)

            @(posedge vif.clk); // Wait one cycle for the DUT to register start
            vif.start <= 1'b0; // Deassert start
            `uvm_info("DRIVER", $sformatf("@%0t: START deasserted. Waiting for DONE...", $time), UVM_MEDIUM)


            // Wait for the 'done' signal from the DUT to know that the transmission has finished
            // Added debug for vif.done value
            `uvm_info("DRIVER", $sformatf("@%0t: Before @(posedge vif.done), vif.done=%0b", $time, vif.done), UVM_DEBUG)
            @(posedge vif.done);
            @(posedge vif.clk);
            `uvm_info("DRIVER", $sformatf("@%0t: Transmission completed for 0x%0h (DONE detected).", $time, tr.data), UVM_MEDIUM)

            seq_item_port.item_done();
            `uvm_info("DRIVER", $sformatf("@%0t: Item 0x%0h completed (item_done called).", $time, tr.data), UVM_MEDIUM)
        end
    endtask
endclass
