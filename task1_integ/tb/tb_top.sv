module tb_top;
// import the UVM library
// include the UVM macros
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import yapp_pkg::*;

    import hbus_pkg::*;
    import clock_and_reset_pkg::*;
    import channel_pkg::*;


    `include "router_tb.sv"
    `include "router_test_lib.sv"
    // `include "hw_top_no_dut.sv" 

    
// import the YAPP package

    // yapp_packet yp1;
    // yapp_packet yp1_copy, yp1_clone;
// initial begin
//     for(int i=0; i<10; i++) begin 
//         process::self.srandom(1000);
//         yp1=yapp_packet::type_id::create($sformatf("seq%0d",i));
//         if(!yp1.randomize())
//         `uvm_fatal("Randomization Failed", $sformatf("sequence_item randomization failed",i) )
//         yp1.print();
//     end 

//     yp1_copy=yapp_packet::type_id::create("seq_copy");
//     yp1_copy.copy(yp1);
//     yp1_copy.print();
//     yp1_copy.print(uvm_default_table_printer);
//     yp1_copy.print(uvm_default_tree_printer);
//     yp1_copy.print(uvm_default_line_printer);

//     $cast(yp1_clone,yp1_copy.clone()); //without it is returning the uvm_object but it is not sure the yapp_packet is a uvm_object
//     yp1_clone.set_name("yp1_clone");
//     yp1_clone.print();
//     yp1_clone.print(uvm_default_table_printer);
//     yp1_clone.print(uvm_default_tree_printer);
//     yp1_clone.print(uvm_default_line_printer); 
//     //default argument for the print() function is the table format.

    


// // yapp_packet yp2;
// // yp2=yapp_packet::type_id::create("seq2", this);
// // yp1.copy()
// // generate 5 random packets and use the print method
// // to display the results

// // experiment with the copy, clone and compare UVM method
// end 
    hw_top h_top();
    initial begin 
        uvm_config_db#(virtual yapp_if)::set(null, "uvm_test_top.env_top.env.agent.*","vif", h_top.in0);
        //channel interface
        uvm_config_db#(virtual channel_if)::set(null, "uvm_test_top.env_top.C0.rx_agent.*","vif", h_top.C0_if);
        uvm_config_db#(virtual channel_if)::set(null, "uvm_test_top.env_top.C1.rx_agent.*","vif", h_top.C1_if);
        uvm_config_db#(virtual channel_if)::set(null, "uvm_test_top.env_top.C2.rx_agent.*","vif", h_top.C2_if);
        
        //hbus interface
        uvm_config_db#(virtual hbus_if)::set(null, "uvm_test_top.env_top.h_b.*","vif", h_top.h_b_if);
        //clock and reset interface
        uvm_config_db#(virtual clock_and_reset_if)::set(null, "uvm_test_top.env_top.c_n_r_env.agent.*","vif", h_top.c_n_r_if);
        
        run_test();
    end 
endmodule : tb_top
