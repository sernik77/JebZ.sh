#!/bin/bash

# bash load-comments.sh config.txt <UID> <pages to fetch> [--id]
# add [--id] to additionally extract just comment id's

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "jq could not be found, please install it to use this script."
  exit 1
fi

# Check if the user has provided the required arguments
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <config_file> <USER_ID> <pages_to_fetch> [--id]"
  echo "Example: $0 config.txt 123 5 --id"
  exit 1
fi

CONFIG_FILE=$1
USER_ID=$2
PAGES=$3
OUTPUT_FILE="${USER_ID}.json"
ONLY_IDS=false

# Check for optional --id flag
if [[ "$4" == "--id" ]]; then
  ONLY_IDS=true
fi

# Load the config file manually and map variables with `-` in the names
if [ -f "$CONFIG_FILE" ]; then
  COOKIE=$(grep '^COOKIE=' "$CONFIG_FILE" | cut -d'=' -f2-)
  X-CSRF-TOKEN=$(grep '^X-CSRF-TOKEN=' "$CONFIG_FILE" | cut -d'=' -f2-)
  X-XSRF-TOKEN=$(grep '^X-XSRF-TOKEN=' "$CONFIG_FILE" | cut -d'=' -f2-)
else
  echo "Config file not found!"
  exit 1
fi

# Ensure all tokens are set
if [ -z "$COOKIE" ] || [ -z "$X-CSRF-TOKEN" ] || [ -z "$X-XSRF-TOKEN" ]; then
  echo "Missing token(s) in the config file!"
  exit 1
fi

# Clear or create the output file
> "$OUTPUT_FILE"

# Loop through the pages and fetch each one
for (( PAGE=1; PAGE<=PAGES; PAGE++ ))
do
  echo "Fetching page $PAGE of $PAGES..."
  
  # Perform the curl request for each page and capture the response
  RESPONSE=$(curl -s "https://jbzd.com.pl/comment/user/listing/$USER_ID?page=$PAGE&per_page=100&sort=newest" \
    -H 'accept: application/json' \
    -H 'accept-language: en-US,en;q=0.9' \
    -H "cookie: $COOKIE" \
    -H 'priority: u=1, i' \
    -H "referer: https://jbzd.com.pl/uzytkownik/templeos/komentarze" \
    -H 'sec-ch-ua: "Brave";v="125", "Chromium";v="125", "Not.A/Brand";v="24"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "Linux"' \
    -H 'sec-fetch-dest: empty' \
    -H 'sec-fetch-mode: cors' \
    -H 'sec-fetch-site: same-origin' \
    -H 'sec-gpc: 1' \
    -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36' \
    -H "x-csrf-token: $X-CSRF-TOKEN" \
    -H 'x-requested-with: XMLHttpRequest' \
    -H "x-xsrf-token: $X-XSRF-TOKEN")
  
  # Check if the response contains an empty message
  if [[ "$RESPONSE" == *'"message":""'* ]]; then
    echo "Page $PAGE returned an empty response. Stopping."
    break
  else
    # Append the response to the output file
    echo "$RESPONSE" | jq . >> "$OUTPUT_FILE"
    echo "Page $PAGE fetched and appended to $OUTPUT_FILE"
  fi
done

# If --id flag is used, extract the comment IDs from "commentable_url"
if [ "$ONLY_IDS" = true ]; then
  ID_OUTPUT_FILE="${USER_ID}_ids.txt"
  > "$ID_OUTPUT_FILE"
  
  grep -o '"commentable_url": "https://jbzd.com.pl/comment/redirect/[0-9]*"' "$OUTPUT_FILE" | \
  sed -E 's/.*\/([0-9]+)"/\1/' >> "$ID_OUTPUT_FILE"
  
  echo "Extracted IDs have been saved to $ID_OUTPUT_FILE"
fi

echo "All pages fetched and saved to $OUTPUT_FILE."
