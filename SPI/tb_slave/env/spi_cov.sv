// -----------------------------------------------------------------------------
// UVM Coverage
// -----------------------------------------------------------------------------
class spi_cov#(parameter int WORD_LEN = 12) extends uvm_subscriber #(spi_seq_item);
   
    `uvm_component_utils(spi_cov)

    event new_transaction_received;
    int unsigned transaction_count = 0;

    virtual spi_if #(WORD_LEN) vif;

    covergroup spi_master_cg;
        option.per_instance = 1; 
        option.name = "Slave Covergroup";

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
         
    function void write(spi_seq_item t);
        spi_seq_item req;
        
        req = spi_seq_item#(.WORD_LEN(WORD_LEN))::type_id::create("req", this);
        
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
