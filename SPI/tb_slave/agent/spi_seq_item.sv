class spi_seq_item #(parameter int WORD_LEN = 12) extends uvm_sequence_item;
	`uvm_object_param_utils(spi_seq_item#(WORD_LEN))
		
	rand bit [WORD_LEN-1:0] mosi_data;       // Data that the master will send to the slave
	rand bit [WORD_LEN-1:0] miso_expected;   // Expected value from the slave on MISO
	rand bit [WORD_LEN-1:0] received_data;   // Value the slave should transmit (via shift_tx)
	rand bit       cs_toggle;                // Simulates a CS drop in the middle of the transaction
	rand bit [1:0] spi_mode;                 // CPOL/CPHA encoded together: 00, 01, 10, 11
		
	constraint mode_c { spi_mode inside {2'b00, 2'b01, 2'b10, 2'b11}; }
	
	function new(string name = "spi_seq_item");
		super.new(name);
	endfunction
		
endclass
