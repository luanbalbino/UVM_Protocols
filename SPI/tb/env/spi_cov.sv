// -----------------------------------------------------------------------------
// UVM Coverage
// -----------------------------------------------------------------------------
class spi_cov extends uvm_subscriber #(spi_transaction);
    `uvm_component_utils(spi_cov)

    event new_transaction_received;
    int unsigned transaction_count = 0;

    virtual spi_if vif;

    covergroup spi_master_cg;
        option.per_instance = 1; 
        option.name = "Master Covergroup";

        // just tracking that start signal goes to 1
        start_cp: coverpoint vif.start {
            bins start_on = {1};
        }

        // different data_in values
        data_in_cp: coverpoint vif.data_in {
            bins zero = {8'h00};
            bins all_ones = {8'hFF};
            bins alternating_01 = {8'hAA};
            bins alternating_10 = {8'h55};
            bins random_data = default;
        }

        done_cp: coverpoint vif.done {
            bins done_on = {1}; 
        }

        reset_cp: coverpoint vif.rst_n {
            bins deasserted = {1};
            bins asserted = {0};
        }

        transactions_cp: coverpoint transaction_count {
            bins one = {1};
            bins few = {[2:4]};
            bins many = {[5:10]};
        }

        start_data_cross: cross start_cp, data_in_cp;
        start_done_cross: cross start_cp, done_cp;

    endgroup: spi_master_cg

    function new(string name = "spi_cov", uvm_component parent = null);
        super.new(name, parent);
        spi_master_cg = new();
    endfunction

    task run_phase(uvm_phase phase);
        forever  begin
          fork  
            begin 
              @new_transaction_received;
              spi_master_cg.sample();
            end
          join
        end
      endtask: run_phase
         
    function void write(spi_transaction t);
        spi_transaction req;
        req = spi_transaction::type_id::create("req", this);
        req.copy(t);

        transaction_count++;
        ->new_transaction_received;
    endfunction: write

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
    
        $display("\n==================================================================");
        $display("                         METRICS REPORT                          ");
        $display("==================================================================");
        $display("Coverage: %0.2f%% | Total transactions: %0d", spi_master_cg.get_coverage(), transaction_count);
        $display("==================================================================\n");
    endfunction

endclass
