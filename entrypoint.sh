#!/bin/bash
set -e

# Configuration
BUILD_DIR="${BUILD_DIR:-build}"
OUTPUT_DIR="${OUTPUT_DIR:-/workspace/output}"

# If running interactively, start a shell
if [ -t 0 ] || [ "$1" = "shell" ]; then
  echo "Starting development shell..."
  echo "Available tools: cmake, ninja, git, vim, nano, htop, tree, python3, rust"
  exec bash
fi

echo "Building MLC-LLM..."

# Clean and create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Configure and build
cmake -B "$BUILD_DIR" -S . -G Ninja
cmake --build "$BUILD_DIR"

echo "Collecting artifacts..."
mkdir -p "$OUTPUT_DIR"

# Copy MLC-LLM modules
cp "$BUILD_DIR"/libmlc_llm.so "$BUILD_DIR"/libmlc_llm_module.so "$OUTPUT_DIR"/

# Copy TVM runtimes  
cp "$BUILD_DIR"/tvm/libtvm.so "$BUILD_DIR"/tvm/libtvm_runtime.so "$OUTPUT_DIR"/

echo "Build complete. Artifacts available in $OUTPUT_DIR:"
ls -l "$OUTPUT_DIR"
