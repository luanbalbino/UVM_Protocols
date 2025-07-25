class apb_write_read_sequence extends uvm_sequence#(apb_trans);
    `uvm_object_utils(apb_write_read_sequence)
  
    int addr;
  
    function new(string name = "apb_write_read_sequence");
      super.new(name);
    endfunction
  
    virtual task body();

      apb_trans tr; 
      int current_addr; 
      logic [31:0] write_data_1 = 32'hBEBACAFE;
      logic [31:0] write_data_2 = 32'hCAFECAFE;
  
      // Write transaction
      tr = apb_trans::type_id::create("write_trans");
      addr = $urandom_range(0, 31);
      tr.PADDR   = addr;
      tr.PWRITE  = 1'b1;
      tr.PSEL    = 1'b1;
      tr.PWDATA  = 32'hBEBACAFE;
      // PENABLE left to driver
      `uvm_info(get_type_name(), $sformatf("WRITE SEQ: addr=0x%0h, data=0x%0h", addr, 32'hBEBACAFE), UVM_LOW)

      start_item(tr);
      finish_item(tr);
  
      // Read transaction (same addr)
      tr = apb_trans::type_id::create("read_trans");
      tr.PADDR  = addr;
      tr.PWRITE = 1'b0;
      tr.PSEL   = 1'b1;
      // PENABLE left to driver
      `uvm_info(get_type_name(), $sformatf("READ SEQ: addr=0x%0h", addr), UVM_LOW)
      start_item(tr);
      finish_item(tr);

      // Write transaction
      tr = apb_trans::type_id::create("write_trans");
      addr = $urandom_range(0, 31); 
      tr.PADDR    = addr;
      tr.PWRITE   = 1'b1;
      tr.PSEL     = 1'b1;
      tr.PWDATA   = 32'hCAFECAFE; 
      `uvm_info(get_type_name(), $sformatf("WRITE SEQ: addr=0x%0h, data=0x%0h", addr, 32'hCAFECAFE), UVM_LOW)
      

      start_item(tr);
      finish_item(tr);
  
      // Read transaction (same addr)
      tr = apb_trans::type_id::create("read_trans");
      tr.PADDR  = addr;
      tr.PWRITE = 1'b0;
      tr.PSEL   = 1'b1;
      // PENABLE left to driver
      `uvm_info(get_type_name(), $sformatf("READ SEQ: addr=0x%0h", addr), UVM_LOW)
      start_item(tr);
      finish_item(tr);
    endtask
  endclass
  