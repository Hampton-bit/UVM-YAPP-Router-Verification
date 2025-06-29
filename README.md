
# UVM YAPP Router Verification - Integrating Multiple UVCs

A comprehensive Universal Verification Methodology (UVM) testbench for verifying a YAPP (Yet Another Packet Protocol) Router design. This project demonstrates integration of multiple UVCs (Universal Verification Components) including HBUS, Channel, Clock & Reset, and YAPP protocol verification environments.

## Lab Objective

The main objectives of this lab are:
- To connect and configure the HBUS UVC, Clock and Reset UVC, and three output Channel UVCs
- Demonstrate integration of multiple verification IP components
- Validate packet routing functionality with comprehensive coverage

## Project Structure

```

├── .gitignore
├── task1\_integ/
│   ├── tb/
│   │   ├── router\_tb.sv
│   │   ├── router\_test\_lib.sv
│   │   ├── tb\_top.sv
│   │   ├── hw\_top.sv
│   │   └── run.f
│   └── sv/
├── router\_rtl/
│   └── yapp\_router.sv
├── yapp/
│   └── sv/
│       ├── yapp\_pkg.sv
│       ├── yapp\_if.sv
│       └── yapp\_tx\_seqs.sv
├── hbus/
│   └── sv/
│       ├── hbus\_pkg.sv
│       ├── hbus\_if.sv
│       └── hbus\_master\_seqs.sv
├── channel/
│   └── sv/
│       ├── channel\_pkg.sv
│       ├── channel\_if.sv
│       └── channel\_rx\_seqs.sv
└── clock\_and\_reset/
└── sv/
├── clock\_and\_reset\_pkg.sv
├── clock\_and\_reset\_if.sv
└── clk10\_rst5\_seq.sv

````

## Key UVC Components

### 1. YAPP UVC (Input)
- **Purpose**: Generates YAPP protocol packets for router input
- **Configuration**: 
  - Packet types: Short packets via `set_type_override`
  - Default sequence: `yapp_012_seq`
  - Custom sequence: Multi-channel packet generation (addresses 0-3)
- **Features**: 
  - Incrementing payload sizes (1-22 bytes)
  - 20% bad parity distribution
  - 88 total packets for comprehensive testing

### 2. Channel UVC (3 Output Instances)
- **Purpose**: Monitors and responds to routed packets
- **Configuration**: 
  - Channel 0: `channel_id = 0`
  - Channel 1: `channel_id = 1` 
  - Channel 2: `channel_id = 2`
- **Default Sequence**: `channel_rx_resp_seq`

### 3. HBUS UVC (Register Interface)
- **Purpose**: Router configuration and control
- **Configuration**:
  - Masters: 1 (`num_masters = 1`)
  - Slaves: 0 (`num_slaves = 0`)
- **Key Registers**:
  - `maxpktsize` (0x1000): Maximum packet size limit
  - `router_en` (0x1001): Router enable control

### 4. Clock and Reset UVC
- **Purpose**: System clock and reset generation
- **Default Sequence**: `clk10_rst5_seq`
- **Features**: Eliminates manual reset generation

## Test Environment

### Available Test Classes

#### `base_test`
- Basic UVM test infrastructure
- All UVCs instantiated but no default sequences

#### `simple_test`
- **YAPP**: Short packets with `yapp_012_seq`
- **Channels**: All use `channel_rx_resp_seq`
- **Clock/Reset**: `clk10_rst5_seq`
- **HBUS**: No default sequence defined

#### `test_uvc_integration`
- **YAPP**: Custom multi-channel sequence (addresses 0-3)
- **HBUS**: Router configuration sequence
  - Sets `maxpktsize = 20`
  - Enables router (`router_en = 1`)
- **Validation Points**:
  - Proper packet addressing to channels
  - Error assertion on bad parity
  - Packet dropping for oversized packets
  - Illegal address handling (address 3)

## Getting Started

### Prerequisites
- SystemVerilog simulator (Cadence Xcelium recommended)
- UVM library (included with simulator)

### Setup Instructions

1. Clone the repository:
```bash
git clone https://github.com/Hampton-bit/UVM-YAPP-Router-Verification.git
cd UVM-YAPP-Router-Verification
````

2. Navigate to integration testbench:

```bash
cd task1_integ/tb
```

3. Compile and run:

```bash
# Run base test
xrun -f run.f +UVM_TESTNAME=base_test

# Run simple test with GUI
xrun -f run.f +UVM_TESTNAME=simple_test -gui

# Run integration test
xrun -f run.f +UVM_TESTNAME=test_uvc_integration
```

### File List (run.f) Structure

```tcl
+incdir+../../yapp/sv
+incdir+../../hbus/sv  
+incdir+../../channel/sv
+incdir+../../clock_and_reset/sv

../../yapp/sv/yapp_pkg.sv
../../hbus/sv/hbus_pkg.sv
../../channel/sv/channel_pkg.sv
../../clock_and_reset/sv/clock_and_reset_pkg.sv

../../yapp/sv/yapp_if.sv
../../hbus/sv/hbus_if.sv
../../channel/sv/channel_if.sv
../../clock_and_reset/sv/clock_and_reset_if.sv

tb_top.sv
hw_top.sv
router_tb.sv
router_test_lib.sv
```

## Configuration Database Usage

### UVC Configuration Examples

```systemverilog
// Channel UVC Configuration
uvm_config_int::set(this, "chan0", "channel_id", 0);
uvm_config_int::set(this, "chan1", "channel_id", 1);
uvm_config_int::set(this, "chan2", "channel_id", 2);

// HBUS UVC Configuration  
uvm_config_int::set(this, "hbus", "num_masters", 1);
uvm_config_int::set(this, "hbus", "num_slaves", 0);

// Virtual Interface Configuration
uvm_config_db#(virtual yapp_if)::set(null, "uvm_test_top.*", "vif", hw_top.yapp_if_i);
uvm_config_db#(virtual hbus_if)::set(null, "uvm_test_top.*", "vif", hw_top.hbus_if_i);
```

## Verification Features

### Transaction Recording

* YAPP monitor transactions
* Channel monitor transactions
* HBUS register transactions
* Waveform analysis support

### Coverage Points

* Packet size distribution (1-22 bytes)
* Address coverage (0-3, including illegal)
* Parity error scenarios (20% bad parity)
* Router configuration states

### Validation Checks

* Correct packet routing to channels
* Error signal assertion on bad parity
* Packet dropping for oversized packets
* Illegal address handling
* Router enable/disable functionality
* Maximum packet size enforcement

## Integration Architecture

```
UVM Test Top
├── Router Testbench (router_tb)
│   ├── YAPP UVC (Input)
│   ├── Channel UVC 0 (Output)
│   ├── Channel UVC 1 (Output) 
│   ├── Channel UVC 2 (Output)
│   ├── HBUS UVC (Register Interface)
│   └── Clock & Reset UVC
└── Hardware Top (hw_top)
    ├── YAPP Router DUT
    ├── Clock Generator
    └── Interface Instances
```

## Lab Deliverables

As per NCDC Lab Manual requirements:

* Multiple UVC integration
* Configuration database usage
* Interface connection methodology
* Test library development
* Transaction recording and analysis
* Comprehensive verification scenarios

## Learning Outcomes

This demonstrates:

* Multiple UVC Integration
* Configuration Management using `uvm_config_db`
* Interface Methodology
* Sequence Coordination across UVCs
* Transaction Analysis



## Contributors

* M. Hamza Naeem 


