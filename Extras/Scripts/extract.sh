#!/bin/bash

# Path to the database file you want to search through.
# Make sure to replace 'database.txt' with the actual path to your database file.
DATABASE_FILE="db.txt"

# Path to the output file where matching lines will be saved.
OUTPUT_FILE="sadol.txt"

# Check if the database file exists.
if [[ ! -f "$DATABASE_FILE" ]]; then
    echo "The database file $DATABASE_FILE does not exist. Please check the file path."
    exit 1
fi

# Use grep to search for lines containing 'jbzd' in any combination of cases,
# and append those lines to jbzd.txt. The -i option makes the search case-insensitive.
grep -i "sadistic.pl" "$DATABASE_FILE" >> "$OUTPUT_FILE"

echo "The matching lines have been copied to $OUTPUT_FILE."
