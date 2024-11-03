#!/bin/bash

# Script to perform a search query on jbzd.com.pl
# Usage: search_query.sh <config_file> <TYPE> <PHRASE>
# <config_file>: Contains COOKIE, X-XSRF-TOKEN, and X-CSRF-TOKEN.
# <TYPE>: Either 'tags', 'users', 'content-media', or 'all' (to search all three types).
# <PHRASE>: The search phrase/query.
# The script saves the output to <PHRASE>_search.txt (appends if file exists).

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <config_file> <TYPE> <PHRASE>"
  echo "Example: $0 config.txt tags 'funny memes'"
  exit 1
fi

CONFIG_FILE=$1
TYPE=$2
PHRASE=$3
OUTPUT_FILE="${PHRASE}_search.txt"

# Load the config file
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
else
  echo "Config file not found!"
  exit 1
fi

# Ensure all tokens are set
if [ -z "$COOKIE" ] || [ -z "$X-CSRF-TOKEN" ] || [ -z "$X-XSRF-TOKEN" ]; then
  echo "Missing token(s) in the config file!"
  exit 1
fi

# Define the search function
perform_search() {
  local search_type=$1
  echo "Performing search for '$PHRASE' in $search_type..."
  
  curl "https://jbzd.com.pl/search/$search_type?page=1&per_page=12&phrase=$PHRASE" \
    -H 'accept: application/json' \
    -H 'accept-language: en-US,en;q=0.6' \
    -H "cookie: $COOKIE" \
    -H 'priority: u=1, i' \
    -H "referer: https://jbzd.com.pl/wyszukaj/wszystko?phrase=$PHRASE" \
    -H 'sec-ch-ua: "Brave";v="125", "Chromium";v="125", "Not.A/Brand";v="24"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "Linux"' \
    -H 'sec-fetch-dest: empty' \
    -H 'sec-fetch-mode: cors' \
    -H 'sec-fetch-site: same-origin' \
    -H 'sec-gpc: 1' \
    -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36' \
    -H "x-csrf-token: $X-CSRF-TOKEN" \
    -H "x-xsrf-token: $X-XSRF-TOKEN" \
    >> "$OUTPUT_FILE"
  
  echo -e "\nSearch results for '$PHRASE' in $search_type appended to $OUTPUT_FILE"
}

# Perform search based on TYPE input
case "$TYPE" in
  "tags"|"users"|"content-media")
    perform_search "$TYPE"
    ;;
  "all")
    perform_search "tags"
    perform_search "users"
    perform_search "content-media"
    ;;
  *)
    echo "Invalid TYPE. Use 'tags', 'users', 'content-media', or 'all'."
    exit 1
    ;;
esac

echo "Search completed."
