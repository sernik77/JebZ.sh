#!/bin/bash

# Check if an input file was provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Get the input file name from the command line argument
INPUT_FILE="$1"

# Define the size of the chunks (24MB)
SIZE="24m"

# Define the prefix for the output files
OUTPUT_PREFIX="part_"

# Split the file
split -b $SIZE --additional-suffix=.txt "$INPUT_FILE" "$OUTPUT_PREFIX"

echo "Splitting completed."
