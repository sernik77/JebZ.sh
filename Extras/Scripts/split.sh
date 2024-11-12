#!/bin/bash

# Usage check
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "File not found: $input_file"
    exit 2
fi

# Temporary directory for initial sorting
temp_dir="temp_sorting"
mkdir -p "$temp_dir"

# Base directory for final output
base_dir="output"
mkdir -p "$base_dir"

# Process each line in the input file
while IFS=' ' read -r url credentials; do
    if [[ $url =~ ^https?:// ]]; then
        # Extract domain and create a safe filename
        domain=$(echo "$url" | awk -F[/:] '{print $4}')
        safe_domain=${domain//\//_}
        # Append credentials to the temporary file for this domain
        echo "$credentials" >> "${temp_dir}/${safe_domain}.txt"
    fi
done < "$input_file"

# Function to distribute files across folders with a limit
distribute_files() {
    local folder_counter=1
    local file_counter=0
    local max_files_per_folder=2000

    for file in "$temp_dir"/*; do
        # Check if we need a new folder
        if [ "$file_counter" -ge "$max_files_per_folder" ]; then
            ((folder_counter++))
            file_counter=0
        fi

        # Ensure the destination directory exists
        mkdir -p "${base_dir}/${folder_counter}"
        # Move the file to the current folder
        mv "$file" "${base_dir}/${folder_counter}/"
        ((file_counter++))
    done
}

# Distribute files across folders
distribute_files

# Clean up the temporary directory
rm -rf "$temp_dir"

echo "Processing complete."
