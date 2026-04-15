#!/bin/bash

# Directory paths
# Assuming the script is in the root of the dynamatic repository
DYNAMATIC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_DIR="$DYNAMATIC_DIR/integration-test"
OUT_BASE_DIR="$TESTS_DIR/out"

COMPILE_SCRIPT="$DYNAMATIC_DIR/tools/dynamatic/scripts/compile.sh"

if [ ! -f "$COMPILE_SCRIPT" ]; then
    echo "Error: compile.sh not found at $COMPILE_SCRIPT"
    exit 1
fi

echo "Starting compilation of integration tests..."
echo "Outputs will be saved in subdirectories under: $OUT_BASE_DIR"

# Iterate over all directories in integration-test
for TEST_DIR in "$TESTS_DIR"/*/; do
    # Remove trailing slash
    TEST_DIR=${TEST_DIR%/}
    TEST_NAME=$(basename "$TEST_DIR")
    
    # Skip the "out" directory
    if [ "$TEST_NAME" = "out" ]; then
        continue
    fi
    
    # Look for the kernel source file
    if [ -f "$TEST_DIR/$TEST_NAME.c" ]; then
        echo "============================================================"
        echo "Compiling test: $TEST_NAME"
        
        TEST_OUT_DIR="$OUT_BASE_DIR/$TEST_NAME"
        mkdir -p "$TEST_OUT_DIR"
        
        # Run the compilation script using simple buffer placement (1)
        # compile.sh <DYNAMATIC_DIR> <SRC_DIR> <OUTPUT_DIR> <KERNEL_NAME> <USE_SIMPLE_BUFFERS>
        "$COMPILE_SCRIPT" "$DYNAMATIC_DIR" "$TEST_DIR" "$TEST_OUT_DIR" "$TEST_NAME" 0
        
        if [ $? -eq 0 ]; then
            echo "Successfully compiled: $TEST_NAME"
        else
            echo "Compilation failed for: $TEST_NAME"
        fi
    fi
done

echo "============================================================"
echo "Finished processing integration tests."
