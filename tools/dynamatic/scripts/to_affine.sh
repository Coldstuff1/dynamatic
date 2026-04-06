#!/bin/bash

source "$1"/tools/dynamatic/scripts/utils.sh

# ============================================================================ #
# Variable definitions
# ============================================================================ #

# Script arguments
if [ "$#" -lt 4 ]; then
    echo "Usage: $0 <DYNAMATIC_DIR> <SRC_DIR> <OUTPUT_DIR> <KERNEL_NAME> [FUNC_NAME]"
    exit 1
fi

DYNAMATIC_DIR=$1
SRC_DIR=$2
OUTPUT_DIR=$3
KERNEL_NAME=$4
FUNC_NAME=${5:-$KERNEL_NAME}

# Binaries used during compilation
POLYGEIST_PATH="$DYNAMATIC_DIR/polygeist/llvm-project/clang/lib/Headers/"
POLYGEIST_CLANG_BIN="$DYNAMATIC_DIR/bin/cgeist"
CIRCT_OPT_BIN="$DYNAMATIC_DIR/bin/circt-opt"
DYNAMATIC_OPT_BIN="$DYNAMATIC_DIR/bin/dynamatic-opt"

# Generated directories/files
COMP_DIR="$OUTPUT_DIR/comp"
F_AFFINE="$COMP_DIR/affine.mlir"
F_AFFINE_MEM="$COMP_DIR/affine_mem.mlir"
OUTPUT_SV_DIR="$OUTPUT_DIR/sv"

# ============================================================================ #
# Compilation flow
# ============================================================================ #

# Reset output directory
rm -rf "$COMP_DIR" "$OUTPUT_SV_DIR" && mkdir -p "$COMP_DIR" "$OUTPUT_SV_DIR"

# source -> affine level
"$POLYGEIST_CLANG_BIN" "$SRC_DIR/$KERNEL_NAME.c" -I \
  "$POLYGEIST_PATH/llvm-project/clang/lib/Headers/" --function="$FUNC_NAME" \
  -S -O3 --memref-fullrank \
  > "$F_AFFINE" 2>/dev/null
exit_on_fail "Failed to compile source to affine" "Compiled source to affine"
