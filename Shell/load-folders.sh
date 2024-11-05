#!/bin/bash

# Script to list folders in favorites on jbzd.com.pl
# Usage: bash list-favorite-folders.sh <config_file> [--short]

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "jq is not installed. Please install jq and try again."
  exit 1
fi

# Check if the user has provided the required argument
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <config_file> [--short]"
  exit 1
fi

CONFIG_FILE=$1
SHORT_OUTPUT=false

# Check for optional --short flag
if [[ "$2" == "--short" ]]; then
  SHORT_OUTPUT=true
fi

# Load the config file and extract tokens
if [ -f "$CONFIG_FILE" ]; then
  while IFS='=' read -r key value; do
    declare "$key"="$value"
  done < "$CONFIG_FILE"
else
  echo "Config file not found!"
  exit 1
fi

# Ensure all tokens are set
if [ -z "$COOKIE" ] || [ -z "$X-CSRF-TOKEN" ] || [ -z "$X-XSRF-TOKEN" ]; then
  echo "Missing token(s) in the config file!"
  exit 1
fi

# Output filenames
OUTPUT_FILE="${CONFIG_FILE%.txt}_folders.json"
SHORT_FILE="${CONFIG_FILE%.txt}_folders_short.json"

# Perform the curl request to list folders
RESPONSE=$(curl -s 'https://jbzd.com.pl/user/favorite/folder/listing?page=1&per_page=100' \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.9,pl-PL;q=0.8,pl;q=0.7' \
  -H 'cache-control: no-cache' \
  -H "cookie: $COOKIE" \
  -H 'referer: https://jbzd.com.pl/ulubione' \
  -H 'sec-ch-ua: "Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36' \
  -H "x-csrf-token: $X-CSRF-TOKEN" \
  -H "x-xsrf-token: $X-XSRF-TOKEN")

# Save the full response to JSON file
echo "$RESPONSE" | jq . > "$OUTPUT_FILE"
echo "Full folder listing saved to $OUTPUT_FILE."

# If --short flag is used, extract specific fields
if [ "$SHORT_OUTPUT" = true ]; then
  jq '{folders: [.folders[] | {id, name, item_count, created_at}]}' "$OUTPUT_FILE" > "$SHORT_FILE"
  echo "Short folder listing saved to $SHORT_FILE."
fi
