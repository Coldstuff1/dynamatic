#!/bin/bash

# Directory paths
# Assuming the script is in the root of the dynamatic repository
DYNAMATIC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_DIR="$DYNAMATIC_DIR/integration-test"
OUT_BASE_DIR="$TESTS_DIR/out"

WRITE_HDL_SCRIPT="$DYNAMATIC_DIR/tools/dynamatic/scripts/write-hdl.sh"

if [ ! -f "$WRITE_HDL_SCRIPT" ]; then
    echo "Error: write-hdl.sh not found at $WRITE_HDL_SCRIPT"
    exit 1
fi

echo "Starting HDL generation for integration tests..."
echo "Outputs will be in the comp directory under: $OUT_BASE_DIR/<test_name>"

# Iterate over all directories in integration-test
for TEST_DIR in "$TESTS_DIR"/*/; do
    # Remove trailing slash
    TEST_DIR=${TEST_DIR%/}
    TEST_NAME=$(basename "$TEST_DIR")
    
    # Skip the "out" directory
    if [ "$TEST_NAME" = "out" ]; then
        continue
    fi
    
    # Check if the kernel output directory and dot file exist
    TEST_OUT_DIR="$OUT_BASE_DIR/$TEST_NAME"
    COMP_DIR="$TEST_OUT_DIR/comp"
    
    if [ -f "$COMP_DIR/$TEST_NAME.dot" ]; then
        echo "============================================================"
        echo "Generating VHDL for test: $TEST_NAME"
        
        # Run the write-hdl script
        # write-hdl.sh <DYNAMATIC_DIR> <OUTPUT_DIR> <KERNEL_NAME>
        "$WRITE_HDL_SCRIPT" "$DYNAMATIC_DIR" "$TEST_OUT_DIR" "$TEST_NAME"
        
        if [ $? -eq 0 ]; then
            echo "Successfully generated VHDL for: $TEST_NAME"
        else
            echo "VHDL generation failed for: $TEST_NAME"
        fi
    else
        echo "Skipping $TEST_NAME: DOT file not found in $COMP_DIR"
    fi
done

echo "============================================================"
echo "Finished VHDL generation for integration tests."
