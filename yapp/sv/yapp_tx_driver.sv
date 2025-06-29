class yapp_tx_driver extends uvm_driver #(yapp_packet);
    `uvm_component_utils(yapp_tx_driver)

    virtual yapp_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction 
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"You are in the driver" , UVM_LOW)

    endfunction

    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(!uvm_config_db #(virtual interface yapp_if)::get(this, "", "vif",vif))
        `uvm_fatal(get_type_name(), "virtual interface getting failed in monitor")
    endfunction  

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info(get_type_name(), "[DRIVER]:Running Simulation" , UVM_HIGH)
    endfunction

    // task run_phase(uvm_phase phase);
    //     super.run_phase(phase);
    //     forever begin 
    //         `uvm_info(get_type_name(),"You are in the driver run phase" , UVM_LOW)

    //         seq_item_port.get_next_item(req);
    //         `uvm_info(get_type_name(),"You are in the driver run phase inside asking for seq" , UVM_LOW)
    //         send_to_dut(req);  // Call send_to_dut to process the packet
    //         seq_item_port.item_done();

    //     end 

    // endtask


     // Declare this property to count packets sent
    int num_sent;

    // UVM run_phase
    task run_phase(uvm_phase phase);
      fork
        get_and_drive();
        reset_signals();
      join
    endtask : run_phase

    // Gets packets from the sequencer and passes them to the driver. 
    task get_and_drive();
        @(posedge vif.reset);
        @(negedge vif.reset);
        `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
        forever begin
        // Get new item from the sequencer
            seq_item_port.get_next_item(req);
            
            `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", req.sprint()), UVM_HIGH)
       
        // concurrent blocks for packet driving and transaction recording
        fork
          // send packet
          begin
            // for acceleration efficiency, write unsynthesizable dynamic payload array directly into 
            // interface static payload array
            foreach (req.payload[i])
              vif.payload_mem[i] = req.payload[i];
            // send rest of YAPP packet via individual arguments
            vif.send_to_dut(req.length, req.addr, req.parity, req.packet_delay);
          end
          // trigger transaction at start of packet (trigger signal from interface)
          @(posedge vif.drvstart) void'(begin_tr(req, "Driver_YAPP_Packet"));
        join

        // End transaction recording
        end_tr(req);
        num_sent++;
        // Communicate item done to the sequencer
        seq_item_port.item_done();
        end
    endtask : get_and_drive

  // Reset all TX signals
    task reset_signals();
      forever 
          vif.yapp_reset();
    endtask : reset_signals

    task send_to_dut(yapp_packet req);
        `uvm_info(get_type_name(), $sformatf("Packet is \n %s",req.sprint()), UVM_LOW)
        #10ns;
    endtask 



endclass 