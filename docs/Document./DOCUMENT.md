# Scan Insertion and ATPG-Based Testability Analysis of a 4-Bit Counter Using Fault

## 1. Introduction

As VLSI designs grow in complexity, testing internal nodes of sequential circuits becomes difficult due to limited controllability and observability. Design for Testability (DFT) techniques are introduced during the design phase to improve fault detection after fabrication.  

Scan-based testing is the most widely used DFT technique in industry, as it converts a sequential circuit into a set of combinational logic blocks during test mode, enabling efficient Automatic Test Pattern Generation (ATPG).

This work presents a complete scan-based DFT flow applied to a 4-bit synchronous counter using open-source tools. The flow includes RTL synthesis, automatic scan insertion, scan-chain cutting, ATPG, and fault coverage analysis using Yosys and the Fault tool.

---

## 2. Objectives

The objectives of this experiment are:

- To synthesize a sequential circuit using a standard cell library
- To map flip-flops to library DFF cells
- To insert scan chains automatically
- To prepare the design for ATPG by cutting scan feedback paths
- To generate test vectors and analyze stuck-at fault coverage

---

## 3. Tools and Libraries Used

- **Yosys Open Synthesis Suite** – RTL synthesis and technology mapping  
- **Fault** – Scan insertion, scan-chain cutting, ATPG, and fault simulation  
- **OSU035 Standard Cell Library** – Gate-level cell models  
- **Docker Environment** – Reproducible tool execution  

---

## 4. RTL Design Description

The circuit under test is a **4-bit synchronous up-counter** with an active-high reset. On every rising edge of the clock, the counter increments its value unless reset is asserted.

This RTL design represents the functional behavior before any DFT logic is inserted.

---

## 5. RTL Synthesis Using Yosys

### 5.1 Reading RTL and Library

The RTL design was read into Yosys using:

- `read_verilog counter_4bit.v`
- `read_liberty -lib osu035_stdcells.lib`


The OSU035 liberty file contains 39 standard cell definitions, including flip-flops with asynchronous reset support.

---

### 5.2 Flip-Flop Mapping (DFFLIBMAP)

The `dfflibmap` pass was used to map generic flip-flops to standard cell DFFs:

- `DFFNEG_X1` mapped to `$DFF_N`
- `DFFPOS_X1` mapped to `$DFF_P`
- `DFFSR` mapped to `$DFFSR_PNN`

After legalization, all four flip-flops in the counter were mapped to **DFFSR cells**, ensuring proper reset functionality.

This confirms correct sequential element mapping using the target library.

---

### 5.3 Optimization and Technology Mapping

The following passes were executed:

- `proc`, `opt`, `flatten`
- `techmap`
- `opt_clean`
- `opt_dff`

These passes optimized combinational logic, removed unused wires, and flattened the design hierarchy.

---

### 5.4 Design Statistics

The `stat` command reported the following for the synthesized design:

- **Total cells**: 11  
- **Flip-flops (DFFSR)**: 4  
- **Logic gates**: AND, NAND, NOT, XOR, XNOR  
- **Ports**: 3  
- **Port bits**: 6  

This confirms that the design consists of 4 sequential elements and minimal combinational logic.

---

### 5.5 Gate-Level Netlist Generation

The synthesized gate-level netlist was written using:
write_verilog counter_trial.v


This netlist serves as the input for scan insertion.

---

## 6. Scan Chain Insertion

### 6.1 Scan-Based DFT Concept

In scan-based testing, flip-flops are connected in a serial chain during test mode. This allows internal states to be shifted in and observed through scan ports, improving controllability and observability.

---

### 6.2 Automatic Scan Insertion Using Fault

Scan insertion was performed using:


During scan insertion, Fault performed the following:

- Replaced DFFs with scan-capable flip-flops
- Inserted internal and boundary scan cells
- Added scan control logic
- Resynthesized the design using Yosys

**Observed scan statistics:**
- Internal scan chain length: 4
- Boundary scan chain length: 4
- **Total scan chain length: 8**

The scan-inserted netlist was generated as `counter_scan1.v`.

---

## 7. Scan Chain Cutting

### 7.1 Purpose of Scan Cutting

Scan chains introduce feedback paths that interfere with ATPG algorithms. These feedback paths must be removed to enable fault simulation.

---

### 7.2 Scan Cutting Using Fault

Scan cutting was performed using:

fault cut counter_scan1.v -o counter_scan_cut.v


This step removes scan feedback loops while preserving scan behavior, producing an ATPG-ready netlist.

---

## 8. Automatic Test Pattern Generation (ATPG)

### 8.1 Fault Model

The ATPG process targets **single stuck-at faults**, including:
- Stuck-at-0 (SA0)
- Stuck-at-1 (SA1)

Faults are injected at:
- Gate outputs
- Sequential elements
- Primary inputs and outputs

---

### 8.2 ATPG Execution

ATPG and fault simulation were performed using:

fault counter_scan_cut.v -c osu035_stdcells.v --clock clk -o patterns.tv.json --output-covered coverage.yml


---

### 8.3 ATPG Results

From the Fault tool output:

- **Total fault sites**: 118  
- **Number of gates**: 31  
- **Number of ports**: 24  
- **Initial coverage**: 0.0%  
- **Final fault coverage**: **81.35593%**  
- **Simulation time**: ~0.81 seconds  

Generated outputs:
- `patterns.tv.json` – ATPG test vectors
- `counter_scan_cut.v.tv.svf` – SVF test pattern file
- `coverage.yml` – Fault coverage metadata

---

## 9. Test Compaction

The Fault tool performs internal test compaction to minimize redundant test vectors while maintaining coverage. This reduces test application time and tester memory requirements.

---

## 10. Fault Coverage Analysis

Fault coverage is defined as:

Fault Coverage = (Detected Faults / Total Faults) × 100


For the given design:

- Total faults: 118  
- Coverage achieved: **81.36%**

The uncovered faults are typically due to redundant or functionally untestable logic.

---

## 11. Results and Discussion

- Scan insertion significantly improves controllability and observability
- ATPG successfully generates compact test vectors
- High fault coverage demonstrates effective testability
- The flow closely resembles industrial DFT practices

---

## 12. Conclusion

This experiment demonstrates a complete scan-based DFT flow for a sequential circuit using open-source tools. Automatic scan insertion, scan cutting, and ATPG were successfully performed, achieving over **81% fault coverage**. The results validate the effectiveness of scan-based testing in improving circuit testability.

---

## 13. Repository Organization

The project repository is organized as follows:

- `src/` – RTL and scan-based designs  
- `synth/` – Synthesized and scan-inserted netlists  
- `atpg/` – Test vectors and coverage reports  
- `tb/` – Testbench files  
- `docs/` – Documentation  
- `report/` – Analysis and results  

---

## 14. Keywords

DFT, Scan Chain, ATPG, Fault Simulation, Fault Coverage, Test Compaction, Yosys, Fault Tool, VLSI Testing


