#!/bin/bash

# Check if input file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Clear or create the output file
> jbzd_email.txt

# Process each line in the input file
while IFS= read -r line; do
    # Check if line contains both "jbzd.com.pl" and "@"
    if [[ "$line" == *"jbzd.com.pl"* && "$line" == *"@"* ]]; then
        # Extract everything after the first whitespace
        content=$(echo "$line" | sed 's/^[^ ]* //')
        # Append to output file
        echo "$content" >> jbzd_email.txt
    fi
done < "$1"

echo "Filtered lines saved to jbzd_email.txt."
