# Dynamatic Usage Guide

This document provides a comprehensive usage guide for the Dynamatic high-level synthesis compiler, based on an analysis of its repository structure, documentation, and internal scripts.

## Overview

Dynamatic takes C/C++ code (specifically a "kernel" function) and compiles it into a synchronous dynamically-scheduled circuit (elastic circuit) using the MLIR compiler infrastructure.

The compilation process is a multi-stage pipeline:
1. **Source to Affine:** Polygeist ([cgeist](file:///home/coldstuff1/school/COMP-764/dynamatic/bin/cgeist)) is used to convert C/C++ source code into the MLIR Affine dialect.
2. **Affine to SCF:** The Affine dialect is lowered to the Structured Control Flow (SCF) dialect via memory analysis and preprocessing using [dynamatic-opt](file:///home/coldstuff1/school/COMP-764/dynamatic/bin/dynamatic-opt).
3. **SCF to CF:** SCF is lowered to the Control Flow (CF) dialect.
4. **CF Transformations:** Standard and Dynamatic-specific transformations are applied at the CF level.
5. **CF to Handshake:** CF dialect is lowered to the Handshake dialect representing the dataflow circuit.
6. **Handshake Transformations:** Transformations are applied to optimize the Handshake circuit.
7. **Buffer Placement:** Buffers are placed into the circuit to support dynamic scheduling. This can be "smart" (using profiling data extracted from running the C code) or "simple".
8. **Export:** The final layout is exported as an MLIR file and a `.dot` file via [export-dot](file:///home/coldstuff1/school/COMP-764/dynamatic/bin/export-dot) which can be turned into a `.png` for visualization.

## Primary Tools

Following a successful build, the `bin/` directory contains several essential tools:
- **[cgeist](file:///home/coldstuff1/school/COMP-764/dynamatic/bin/cgeist)**: Polygeist frontend for C/C++ to MLIR conversion.
- **[dynamatic-opt](file:///home/coldstuff1/school/COMP-764/dynamatic/bin/dynamatic-opt)**: The core MLIR optimizer with Dynamatic-specific passes (e.g., `--lower-scf-to-cf`, `--handshake-place-buffers`).
- **[export-dot](file:///home/coldstuff1/school/COMP-764/dynamatic/bin/export-dot)**: Converts MLIR Handshake dialect into Graphviz DOT format.
- **[exp-frequency-profiler](file:///home/coldstuff1/school/COMP-764/dynamatic/bin/exp-frequency-profiler)**: Extracts CF-level profiling information for smart buffer placement.
- **[hls-verifier](file:///home/coldstuff1/school/COMP-764/dynamatic/bin/hls-verifier)**: Used internally for verification/testing.

## Running the Compilation Flow

The most straightforward way to run the full HLS compilation flow from C code to a circuit representation is by using the provided [compile.sh](file:///home/coldstuff1/school/COMP-764/dynamatic/tools/dynamatic/scripts/compile.sh) script, which orchestrates the calls to [cgeist](file:///home/coldstuff1/school/COMP-764/dynamatic/bin/cgeist), [dynamatic-opt](file:///home/coldstuff1/school/COMP-764/dynamatic/bin/dynamatic-opt), and [export-dot](file:///home/coldstuff1/school/COMP-764/dynamatic/bin/export-dot).

### Script Location
[tools/dynamatic/scripts/compile.sh](file:///home/coldstuff1/school/COMP-764/dynamatic/tools/dynamatic/scripts/compile.sh)

### Usage
```bash
./tools/dynamatic/scripts/compile.sh <DYNAMATIC_DIR> <SRC_DIR> <OUTPUT_DIR> <KERNEL_NAME> <USE_SIMPLE_BUFFERS>
```

#### Arguments
1. **`<DYNAMATIC_DIR>`**: Absolute or relative path to the root of the Dynamatic repository.
2. **`<SRC_DIR>`**: Directory containing your C/C++ source file.
3. **`<OUTPUT_DIR>`**: Directory where compilation artifacts (e.g., intermediate `.mlir` files, `.dot`, `.png`) will be stored.
4. **`<KERNEL_NAME>`**: The name of the top-level C function to compile. The script expects the source file to be named `<KERNEL_NAME>.c` inside `SRC_DIR`.
5. **`<USE_SIMPLE_BUFFERS>`**: An integer flag (e.g., `0` or `1`). If set to `0`, smart buffer placement (requiring a profiler run) is used. If non-zero, simple buffer placement is used.

### Output Files
After a successful compilation, you can find the intermediate MLIR dialects and final output in the `OUTPUT_DIR/comp` directory:
- `std_dyn_transformed.mlir`: The optimized MLIR Control Flow representation.
- `handshake_export.mlir`: The final optimized Handshake representation of the circuit.
- `visual.dot` / `visual.png`: Visual representations of the generated elastic circuit.

## Example

Assuming you are in the Dynamatic root directory and you have a kernel named `vector_add` in a file `examples/vector_add.c`:

```bash
mkdir -p out
./tools/dynamatic/scripts/compile.sh $(pwd) ./examples ./out vector_add 1
```

This will run the simple buffer placement flow, generating a `.png` circuit image in `./out/comp/visual.png`.

## CIRCT-HIR Usage Guide

This repository contains an MLIR dialect (`hir`) designed to lower High-Level Synthesis (HLS) operations and constructs to statically scheduled circuits. Eventually, it emits SystemVerilog.

### Compilation Flow (MLIR to SystemVerilog)

The primary tool for interacting with the HIR dialect is `circt-opt`, which you build as part of the `circt` submodule or find symlinked in `bin/`.

A typical compilation flow from an input MLIR file (containing `affine` or `hir` dialect operations) down to SystemVerilog uses the following command structure:

```bash
./bin/circt-opt \
    -affine-to-hir \
    -hir-opt \
    -hir-simplify \
    -hir-to-hw \
    -export-split-verilog='dir-name=output_sv_dir' \
    input.mlir > run.log
```

#### Passes Explained:
1. **`-affine-to-hir`**: Converts standard `affine` loop structures and memory accesses into native HIR operations.
2. **`-hir-opt`**: Applies various HIR-level optimizations.
3. **`-hir-simplify`**: Cleans up and simplifies the HIR intermediate representation.
4. **`-hir-to-hw`**: Lowers the HIR dialect into CIRCT's `hw` (hardware) and `sv` (SystemVerilog) dialects.
5. **`-export-split-verilog`**: Generates the final SystemVerilog source files and splits them by module into the specified directory (`output_sv_dir`).

### Python Cosimulation Framework

The repository includes Python-based cosimulation tools to verify the generated hardware circuits against a golden Python model or testbench. There are multiple environments available in the `tools/` directory (e.g., `cosim-python` and `cosim-cocotb`).

#### Example using Cocotb (`tools/cosim-cocotb`)
1. **Testbenches**: You can find ready-to-use Python testbenches in files like `tools/cosim-cocotb/test_gesummv.py`.
2. **Configuration**: The `tests/test.toml` defines the test environment configuration, pointing to the MLIR file, testbench file, and include directories.
3. **Execution**: The cosimulation flow will automatically invoke Verilator on the generated SystemVerilog and link it with the Python testbench for robust functional verification.

### Vivado Project Generation Flow

The repository has custom CMake functions (e.g., in `cmake/tclFunctions.cmake`) that automate Vivado IP creation and project generation. When you invoke a synthesis target like `gesummv_prj`:
1. It processes the corresponding original C++ functional files using **Vitis HLS**.
2. It compiles the MLIR equivalents through the CIRCT-HIR pipeline to generate RTL.
3. It integrates everything into a unified Vivado block design (`.xpr`).

To configure your own benchmark or workflow within this setup, you can add custom targets inside `benchmarks/<benchmark_name>/CMakeLists.txt` using the wrapper functions `add_sv_target`, `add_verilator_target`, and `add_vivado_project_target`.
