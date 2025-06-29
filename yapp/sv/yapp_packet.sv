// Define your enumerated type(s) here
typedef enum bit{GOOD_PARITY, BAD_PARITY} parity_type_e;

class yapp_packet extends uvm_sequence_item;
    rand bit [5:0] length;
    rand bit [1:0] addr;
    rand bit [7:0] payload[];
    rand bit [7:0] parity;
    rand parity_type_e parity_type;


    rand int packet_delay;

    `uvm_object_utils_begin(yapp_packet)
      `uvm_field_int(addr, UVM_ALL_ON)
      `uvm_field_int(length, UVM_ALL_ON)
      `uvm_field_enum(parity_type_e, parity_type, UVM_ALL_ON)
      `uvm_field_array_int(payload, UVM_ALL_ON)
      `uvm_field_int(parity, UVM_ALL_ON)
      `uvm_field_int(packet_delay, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "yapp_packet");
      super.new(name);
    endfunction 

    function bit [7:0] calc_parity();
      bit [7:0] parity;
      for(int i=0; i<payload.size(); i++) begin 
        parity^=payload[i];
      end
        parity ^={length, addr};
      return parity;
    endfunction

    function void set_parity();
      if(parity_type==GOOD_PARITY) begin 
        parity=calc_parity();
      end 
      else if(parity_type==BAD_PARITY) begin 
        parity=$urandom_range(0,255);
      end 
    endfunction

    function post_randomize();
      set_parity();
      length =payload.size();
    endfunction

    constraint valid_addresses {
      addr  inside {0,1,2};
    }

    // constraint packet_length{
    //   payload.size()inside {[1:63]};
    // }

    constraint parity_type_constraint{
      parity_type dist { GOOD_PARITY:=5, BAD_PARITY:=1 };
    }
    
    constraint packet_delay_constraint{
      packet_delay inside{ [1:20]};
    }

endclass: yapp_packet

class short_yapp_packet extends yapp_packet;
`uvm_object_utils(short_yapp_packet)

    function new(string name="short_yapp_packet");
      super.new(name);
    endfunction 

    constraint packet_length{
      payload.size() inside {[1:14]};
    }

    constraint exclude_address {
      addr!=2;
    }

    function post_randomize();
      set_parity();
      length =payload.size();
    endfunction

endclass 
//yapp_packet p1=new("p1");