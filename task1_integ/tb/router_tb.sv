class router_tb extends uvm_env;
    yapp_env env;

    channel_env c0;
    channel_env c1;
    channel_env c2;

    hbus_env h_b;

    clock_and_reset_env c_n_r_env;

`uvm_component_utils(router_tb)
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase( uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("env", "Build phase is being executed",UVM_HIGH)
        env=yapp_env::type_id::create("env", this);

        uvm_config_int::set(this, "C0", "channel_id", 0);
        uvm_config_int::set(this, "C1", "channel_id", 1);
        uvm_config_int::set(this, "C2", "channel_id", 2);
        uvm_config_int::set(this, "h_b", "num_masters", 1);
        uvm_config_int::set(this, "h_b", "num_slaves" , 0);

        c0=channel_env::type_id::create("C0",this);
        c1=channel_env::type_id::create("C1",this);
        c2=channel_env::type_id::create("C2",this);

        h_b=hbus_env::type_id::create("h_b",this);

        c_n_r_env =clock_and_reset_env::type_id::create("c_n_r_env",this);
        
    endfunction

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info(get_type_name(), "[TOP_ENVIRONMENT]:Running Simulation" , UVM_HIGH)
    endfunction

endclass 