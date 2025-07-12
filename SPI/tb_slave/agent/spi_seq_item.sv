class spi_seq_item #(parameter int WORD_LEN = 12) extends uvm_sequence_item;
    `uvm_object_utils(spi_seq_item#(WORD_LEN))
    
    rand bit [7:0] mosi_data;       // Dados que o master vai enviar pro slave
    rand bit [7:0] miso_expected;   // Valor esperado do slave no MISO
    rand bit [7:0] slave_tx_data;   // Valor que o slave deve transmitir (via shift_tx)
    rand bit       cs_toggle;       // Simula um drop do CS no meio da transação
    rand bit [1:0] spi_mode;        // CPOL/CPHA codificados juntos: 00, 01, 10, 11
    
    constraint mode_c { spi_mode inside {2'b00, 2'b01, 2'b10, 2'b11}; }
    
    function new(string name = "spi_seq_item");
      super.new(name);
    endfunction
    
    
    
    
endclass
      