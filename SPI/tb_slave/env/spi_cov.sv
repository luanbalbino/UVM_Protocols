// -----------------------------------------------------------------------------
// UVM Coverage
// -----------------------------------------------------------------------------
class spi_cov#(parameter int WORD_LEN = 12) extends uvm_subscriber #(spi_seq_item#(WORD_LEN));
	 
	`uvm_component_utils(spi_cov #(WORD_LEN))

	event new_transaction_received;
	int unsigned transaction_count = 0;

	logic [1:0] spi_mode; 
	logic [WORD_LEN-1:0] mosi_data; 
    logic [WORD_LEN-1:0] miso_expected; 
	logic cs_toggle; 

	covergroup spi_master_cg;
		option.per_instance = 1; 
		option.name = "Slave Covergroup";
		cp_mosi_data : coverpoint mosi_data { 
			bins all_values[] = {[0 : 2**WORD_LEN - 1]}; //maybe it's too much, but this is only an example
		}
			cp_miso_expected : coverpoint miso_expected {
				bins all_values[] = {[0 : 2**WORD_LEN - 1]};
		}
			cp_spi_mode : coverpoint spi_mode {
				bins mode_00 = {2'b00};
				bins mode_01 = {2'b01};
				bins mode_10 = {2'b10};
				bins mode_11 = {2'b11};
		}
			cp_cs_toggle : coverpoint cs_toggle {
				bins dropped = {1'b1};
				bins not_dropped = {1'b0};
		}
		cross_mode_cs : cross cp_spi_mode, cp_cs_toggle;
	endgroup: spi_master_cg

	function new(string name = "spi_cov", uvm_component parent = null);
			super.new(name, parent);
			spi_master_cg = new();
	endfunction

	task run_phase(uvm_phase phase);
		forever  begin
			@new_transaction_received;
			spi_master_cg.sample();
		end
	endtask: run_phase
				 
	function void write(spi_seq_item#(WORD_LEN) t);
		spi_mode      = t.spi_mode; 
		mosi_data     = t.mosi_data; 
		miso_expected = t.miso_expected; 
		cs_toggle     = t.cs_toggle; 

		transaction_count++;
		->new_transaction_received;
	endfunction: write

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
	
		$display("\n==================================================================");
		$display("                         METRICS REPORT                          ");
		$display("==================================================================");
		$display("Total transactions: %0d", transaction_count);
		$display("Overall Coverage: %0.2f%%", spi_master_cg.get_coverage());
	
		$display("\nCoverpoint MOSI Data Coverage: %0.2f%%",
			spi_master_cg.cp_mosi_data.get_coverage());
	
		$display("Coverpoint MISO Expected Coverage: %0.2f%%",
			spi_master_cg.cp_miso_expected.get_coverage());
	
		$display("Coverpoint SPI Mode Coverage: %0.2f%%",
			spi_master_cg.cp_spi_mode.get_coverage());
	
		$display("Coverpoint CS Toggle Coverage: %0.2f%%",
			spi_master_cg.cp_cs_toggle.get_coverage());
			
		$display("Cross Mode_CS Coverage: %0.2f%%", spi_master_cg.cross_mode_cs.get_coverage());	
		$display("==================================================================\n");
	endfunction
	
endclass
