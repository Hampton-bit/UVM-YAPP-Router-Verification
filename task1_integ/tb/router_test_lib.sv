class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    router_tb env_top;
    function new( string name , uvm_component parent);
        super.new(name, parent);
    endfunction 

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
         uvm_config_wrapper::set(this, 
         "env_top.env.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_5_packets::get_type());
        
        `uvm_info("test", "build phase of the test is being executed", UVM_LOW)
        
        
        env_top=router_tb::type_id::create("env_top", this);

        uvm_config_int::set(this, "*", "recording_details", 1);
    endfunction 

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction 

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info(get_type_name(), "[TEST]:Running Simulation" , UVM_HIGH)
    endfunction

    uvm_objection obj;
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        obj = phase.get_objection();
        obj.set_drain_time(this, 200ns);
        // phase.raise_objection(this, "test starting");
        // // Allow time for sequences to execute
        // #10000ns;
        // phase.drop_objection(this, "test_ending");
    endtask 

    function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        check_config_usage();
    endfunction

endclass

// class short_packet_test extends base_test;

//     `uvm_component_utils(short_packet_test)

//     function new(string name, uvm_component parent);
//         super.new(name, parent);
//     endfunction

//     virtual function void build_phase( uvm_phase phase);
//         super.build_phase(phase);

        

//         set_type_override_by_type(
//                                 yapp_packet::get_type(),
//                                 short_yapp_packet::get_type()
//         );
//         factory.print();
//     endfunction 
    

// endclass

// class  set_config_test extends base_test;
//     `uvm_component_utils( set_config_test)

//     function new( string name , uvm_component parent);
//         super.new(name, parent);
//     endfunction 

//     virtual function void build_phase( uvm_phase phase);
        
//         // uvm_config_wrapper::set(this, 
//         // "env_top.env.agent.sequencer.run_phase",
//         //                        "default_sequence",
//         //                        yapp_5_packets::get_type());
//         `uvm_info("test", "build phase of the test is being executed", UVM_LOW)
//         uvm_config_int::set(this,"env_top.env.agent", "is_active", UVM_PASSIVE);
        
//         set_type_override_by_type(
//                                 yapp_packet::get_type(),
//                                 short_yapp_packet::get_type()
//         );

//         super.build_phase(phase);

//         // uvm_config_int::set(this, "*", "recording_details", 1);

//         factory.print();
//     endfunction 
// endclass 

// class incr_payload_test extends base_test;
//     `uvm_component_utils(incr_payload_test)
    
//     function new(string name, uvm_component parent);
//         super.new(name, parent);
//     endfunction

//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         uvm_config_wrapper::set(this, "env_top.env.agent.sequencer.run_phase",
//                                 "default_sequence", 
//                                 yapp_incr_payload_seq::get_type() );
//         set_type_override_by_type(      yapp_packet::get_type(), 
//                                   short_yapp_packet::get_type());

//     endfunction

// endclass 

// class yapp_012_test extends base_test;
//     `uvm_component_utils(yapp_012_test)
    
//     function new(string name, uvm_component parent);
//         super.new(name, parent);
//     endfunction

//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         uvm_config_wrapper::set(this, "env_top.env.agent.sequencer.run_phase",
//                                 "default_sequence", 
//                                 yapp_012_seq::get_type() );
//         set_type_override_by_type(        yapp_packet::get_type(), 
//                                     short_yapp_packet::get_type()  );

//     endfunction

// endclass 


// class yapp_111_test extends base_test;
//     `uvm_component_utils(yapp_111_test)
    
//     function new(string name, uvm_component parent);
//         super.new(name, parent);
//     endfunction

//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         uvm_config_wrapper::set(this, "env_top.env.agent.sequencer.run_phase",
//                                 "default_sequence", 
//                                 yapp_111_seq::get_type() );
//         set_type_override_by_type(      yapp_packet::get_type(), 
//                                   short_yapp_packet::get_type());

//     endfunction

// endclass 


// class exhaustive_seq_test extends base_test;
//     `uvm_component_utils(exhaustive_seq_test)
        
//         function new(string name, uvm_component parent);
//             super.new(name, parent);
//         endfunction
    
//         function void build_phase(uvm_phase phase);
//             super.build_phase(phase);
//             uvm_config_wrapper::set(this, "env_top.env.agent.sequencer.run_phase",
//                                     "default_sequence", 
//                                     yapp_exhaustive_seq::get_type() );
//             set_type_override_by_type(      yapp_packet::get_type(), 
//                                       short_yapp_packet::get_type());
    
//         endfunction
    
// endclass 


class simple_test extends base_test;
    `uvm_component_utils(simple_test)
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //default packet to run in yapp uvc
            set_type_override_by_type(      yapp_packet::get_type(), 
                                      short_yapp_packet::get_type());
            //yapp uvc
            uvm_config_wrapper::set(this, "env_top.env.agent.sequencer.run_phase",
                                    "default_sequence", 
                                           yapp_012_seq::get_type()        );

            //channel uvc's default sequence
            uvm_config_wrapper::set(this, "env_top.C?.rx_agent.sequencer.run_phase",
                                      "default_sequence", 
                                   channel_rx_resp_seq::get_type()        ); 
            //clock and reset uvc 
            uvm_config_wrapper::set(this, "env_top.c_n_r_env.agent.sequencer.run_phase",
                                      "default_sequence", 
                                        clk10_rst5_seq::get_type()        );               
    
        endfunction
    
endclass 

class test_uvc_integration extends base_test;
    `uvm_component_utils(test_uvc_integration)
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //default packet to run in yapp uvc
            set_type_override_by_type(      yapp_packet::get_type(), 
                                      short_yapp_packet::get_type());
            //yapp uvc
            uvm_config_wrapper::set(this, "env_top.env.agent.sequencer.run_phase",
                                    "default_sequence", 
                                       all_channel_seq::get_type()        );

            //channel uvc's default sequence
            uvm_config_wrapper::set(this, "env_top.C?.rx_agent.sequencer.run_phase",
                                      "default_sequence", 
                                   channel_rx_resp_seq::get_type()        ); 
            //clock and reset uvc 
            uvm_config_wrapper::set(this, "env_top.c_n_r_env.agent.sequencer.run_phase",
                                      "default_sequence", 
                                        clk10_rst5_seq::get_type()        ); 
            //hbus uvc    
            uvm_config_wrapper::set(this, "env_top.h_b.masters[?].sequencer.run_phase",
                                      "default_sequence", 
                                 hbus_small_packet_seq::get_type()        );                       
    
        endfunction
    
endclass 