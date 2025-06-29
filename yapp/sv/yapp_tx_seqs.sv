class yapp_base_seq extends uvm_sequence #(yapp_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction
  rand yapp_packet req;

  task pre_body();
    uvm_phase phase;
    `uvm_info(get_type_name(),"You are in the sequence" , UVM_LOW)

    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_LOW)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : yapp_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5) begin
      `uvm_do(req)
     `uvm_info(get_type_name(), $sformatf("Sent packet:\n%s", req.sprint()), UVM_LOW)
     end 

  endtask
  
endclass : yapp_5_packets

class yapp_1_seq extends yapp_base_seq;
`uvm_object_utils(yapp_1_seq)
  function new(string name="yapp_1_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_1_packets sequence", UVM_LOW)
    `uvm_do_with(req, {addr==1;})
  endtask 

endclass 

class yapp_012_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_012_seq)
    function new(string name="yapp_012_seq");
      super.new(name);
    endfunction
    short_yapp_packet short_req;
    virtual task body();

      `uvm_info(get_type_name(), "Executing yapp_012_packets sequence", UVM_LOW)
      `uvm_do_with(req, {addr==0;})
      `uvm_do_with(req, {addr==1;})
      // `uvm_do_with(req, {addr==2;})
      `uvm_create(short_req)
       short_req.exclude_address.constraint_mode(0);
      if(!short_req.randomize() with {
          addr==2;
        }
      ) 
      begin 
        `uvm_error(get_type_name(), "randomization failed")
      end 
      `uvm_send(short_req)

    endtask 
  
endclass 

class yapp_111_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_111_seq)
    function new(string name="yapp_111_seq");
      super.new(name);
    endfunction
    yapp_1_seq seq1, seq2, seq3;
    virtual task body();
      `uvm_info(get_type_name(), "Executing yapp_111_packets sequence", UVM_LOW)
      `uvm_do(seq1)
      `uvm_do(seq2)
      `uvm_do(seq3)
    endtask 
  
endclass 


class yapp_repeat_addr_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_repeat_addr_seq)
    function new(string name="yapp_repeat_addr_seq");
      super.new(name);
    endfunction
  rand int addr_rand;
  constraint rand_c{
    addr_rand inside {0,1,2};
  }
  short_yapp_packet short_req;
    virtual task body();
      if(!this.randomize()) `uvm_error(get_type_name(), "The randomization of yapp_repeat failed")
      //addr_rand=$urandom_range(0,2);
      `uvm_info(get_type_name(), "Executing yapp_repeat_addr_seq sequence", UVM_LOW)

      `uvm_create(short_req)
       short_req.exclude_address.constraint_mode(0);
      if(!short_req.randomize() with {
            addr==addr_rand;
        }
      ) 
      begin 
        `uvm_error(get_type_name(), "randomization failed")
      end 
      `uvm_send(short_req)
///////////////////////////////////////////////////

      `uvm_create(short_req)
      short_req.exclude_address.constraint_mode(0);
      if(!short_req.randomize() with {
            addr==addr_rand;
        }
      ) 
      begin 
        `uvm_error(get_type_name(), "randomization failed")
      end 
      `uvm_send(short_req)

    endtask 
endclass 

class yapp_incr_payload_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_incr_payload_seq)
    function new(string name="yapp_incr_payload_seq");
      super.new(name);
    endfunction
  int addr;
    virtual task body();

      `uvm_info(get_type_name(), "Executing yapp_incr_payload_seq sequence", UVM_LOW)
  
      `uvm_create(req)
      if(!req.randomize() with {
        foreach (payload[i]) {
          // if(i==0) payload[i]==0;
          if(i<length) {
            payload[i]==i;
            
          }
        }
      }) begin 
        `uvm_error(get_type_name(), "randomization failed")
      end 
      req.set_parity();
      `uvm_send(req)
    endtask 
  
endclass 
    



class yapp_rnd_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_rnd_seq)
    function new(string name="yapp_rnd_seq");
      super.new(name);
    endfunction
    
    rand int count;
    int packet_count;



    constraint limit_count{
      count inside {[1:10]};
    }

    virtual task body();
      if(!this.randomize()) `uvm_error(get_type_name(), "randomization of yapp_rnd_seq failed")
      
      `uvm_info(get_type_name(), "Executing yapp_111_packets sequence", UVM_LOW)
      
      repeat(count) begin 
        `uvm_do(req)
        `uvm_info(get_type_name(), $sformatf("Packet is %0dth of %d",(packet_count+1), count),UVM_LOW )
        packet_count++;
      end 
    endtask 
     
endclass 

class six_yapp_seq extends yapp_base_seq;
  `uvm_object_utils(six_yapp_seq)
    function new(string name="six_yapp_seq");
      super.new(name);
    endfunction
    
    yapp_rnd_seq random_seq;
    virtual task body();
      // `uvm_do_with(random_seq, {random_seq.count<=6;})
      `uvm_create(random_seq)
      if(!random_seq.randomize() 
            with {
              count<=6;
            }
      )
      begin 
            `uvm_error(get_type_name(), "random_seq randomization failed")
      end 
      `uvm_send(random_seq)
    endtask 
     
endclass 

class all_channel_seq extends yapp_base_seq;
  `uvm_object_utils(all_channel_seq)
    function new(string name="all_channel_seq");
      super.new(name);
    endfunction
    int packet_count = 0;
    int bad_parity=0;


    virtual task body();

      for(int i=0; i<4; i++) begin 
        for(int l=1; l<23; l++) begin
          req=yapp_packet::type_id::create("all_channel_seq");
   
          req.payload=new[l];
          foreach(req.payload[j]) begin 
            req.payload[j]=$urandom_range(0, 255);
          end 
          req.length=l;
          req.addr=i;
          if(bad_parity<18 && req.addr==$urandom_range(0,3) ) begin 
            req.parity_type=BAD_PARITY;
            bad_parity++;
          end 
          req.set_parity();
          start_item(req); 

          finish_item(req);
          packet_count++;
          `uvm_info(get_type_name(), $sformatf("Sent packet  %0d", packet_count), UVM_LOW)
          `uvm_info(get_type_name(), $sformatf("Bad parity :  %0d ", bad_parity), UVM_LOW)

        end 
      end 
    endtask 
     
endclass 
  
class yapp_exhaustive_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_exhaustive_seq)
    function new(string name="yapp_exhaustive_seq");
      super.new(name);
    endfunction
    yapp_1_seq              seq1;
    yapp_012_seq            seq012;
    yapp_111_seq            seq111;
    yapp_repeat_addr_seq    seq_repeat_addr;
    yapp_incr_payload_seq   seq_incr_payload;
    yapp_rnd_seq            seq_random;
    six_yapp_seq            seq_random_6;
    virtual task body();
      `uvm_info(get_type_name(), "Executing yapp_111_packets sequence", UVM_LOW)
      `uvm_do(seq1)
      `uvm_do(seq012)
      `uvm_do(seq111)
      `uvm_do(seq_repeat_addr)
      `uvm_do(seq_incr_payload)
      `uvm_do(seq_random)
      `uvm_do(seq_random_6)
    endtask 
  
endclass 

  

