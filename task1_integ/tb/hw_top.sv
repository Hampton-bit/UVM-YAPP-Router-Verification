/*-----------------------------------------------------------------
File name     : hw_top.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif hardware top module for acceleration
              : Instantiates clock generator and YAPP interface only for testing - no DUT
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module hw_top;

  // Clock and reset signals
  logic [31:0]  clock_period;
  logic         run_clock;
  logic         clock;
  logic         reset;

  // YAPP Interface to the DUT
  yapp_if in0(clock, reset);

  // CLKGEN module generates clock
  clkgen clkgen (
                  .clock(clock),
                  .run_clock(run_clock),
                  .clock_period(clock_period)
  );



  channel_if C0_if(  .clock(clock), 
                     .reset(reset) 
                 );
  channel_if C1_if(  .clock(clock), 
                     .reset(reset) 
                   );
  channel_if C2_if(  .clock(clock), 
                     .reset(reset) 
                   );


  hbus_if h_b_if (    .clock(clock), 
                    .reset(reset)
               );

  clock_and_reset_if c_n_r_if (
                    .clock(clock),
                    .reset(reset),
                    .run_clock(run_clock), 
                    .clock_period(clock_period)
  );

  yapp_router dut(
    .reset(c_n_r_if.reset),
    .clock(c_n_r_if.clock),
    .error(),

    // YAPP interface
    .in_data(in0.in_data),
    .in_data_vld(in0.in_data_vld),
    .in_suspend(in0.in_suspend),

    // Output Channels
    //Channel 0
    .data_0(C0_if.data),
    .data_vld_0(C0_if.data_vld),
    .suspend_0(C0_if.suspend),
    //Channel 1
    .data_1(C1_if.data),
    .data_vld_1(C1_if.data_vld),
    .suspend_1(C1_if.suspend),
    //Channel 2
    .data_2(C2_if.data),
    .data_vld_2(C2_if.data_vld),
    .suspend_2(C2_if.suspend),

    // HBUS Interface 
    .haddr(h_b_if.haddr),
    .hdata(h_b_if.hdata_w),
    .hen(h_b_if.hen),
    .hwr_rd(h_b_if.hwr_rd));

    // initial begin
    //       clock_period = 10;  // 10ns clock period
    //       run_clock = 1;      // Enable clock generation
    // end

endmodule
