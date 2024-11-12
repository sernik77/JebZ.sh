#!/bin/bash

# Check if exactly two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <word> <file>"
    exit 1
fi

word=$1
file=$2

# Use sed to remove lines containing the specified word (case-insensitive)
sed -i "/$word/Id" "$file"

echo "Lines containing the word '$word' have been removed from $file."
