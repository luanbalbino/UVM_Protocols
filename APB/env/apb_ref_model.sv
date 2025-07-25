class apb_ref_model extends uvm_component;
  `uvm_component_utils(apb_ref_model)

  bit [31:0] regs[bit [31:0]];

  uvm_analysis_imp #(apb_trans, apb_ref_model) req_export;
  uvm_analysis_port #(apb_trans) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    req_export = new("req_export", this); 
    ap         = new("ap", this);
  endfunction

  virtual function void write(input apb_trans tr);
    `uvm_info("REFMOD", $sformatf("REFMOD: addr=0x%0h, write=%0b, current_stored=0x%0h", tr.PADDR, tr.PWRITE, regs.exists(tr.PADDR) ? regs[tr.PADDR] : '0), UVM_LOW)

    if (tr.PWRITE) begin
      regs[tr.PADDR] = tr.PWDATA;
    end else begin
      if (regs.exists(tr.PADDR))
        tr.PRDATA = regs[tr.PADDR];
      else
        tr.PRDATA = '0;
    end
 
    ap.write(tr);
  endfunction

endclass
