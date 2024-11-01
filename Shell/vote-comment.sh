#!/bin/bash

# Vote value [1 = +] / [-1 = -]
# User can specify delay range like 3.5-5 to delay between 3.5 to 5s between each request
# User can specify comment id's from a file
# User can specify ignore file with comment id's to ignore

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "jq could not be found, please install it to use this script."
  exit 1
fi

# Check if the user has provided the required arguments
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <config_file> <comment_id_or_file> <vote_value> [delay_or_range] [--ignore filename.txt]"
  echo "Example: $0 config.txt 29767076 1"
  echo "Example with file, delay range, and ignore file: $0 config.txt ids.txt 1 3.5-5 --ignore ignore.txt"
  exit 1
fi

CONFIG_FILE=$1
COMMENT_ID_OR_FILE=$2
VOTE_VALUE=$3
DELAY=${4:-0}  # Default delay is 0 if not specified
IGNORE_FILE=""

# Check for --ignore flag and file
if [[ "$5" == "--ignore" && -n "$6" ]]; then
  IGNORE_FILE=$6
  if [ ! -f "$IGNORE_FILE" ]; then
    echo "Ignore file not found!"
    exit 1
  fi
fi

# Load the config file manually and map variables with `-` in the names
if [ -f "$CONFIG_FILE" ]; then
  COOKIE=$(grep '^COOKIE=' "$CONFIG_FILE" | cut -d'=' -f2-)
  X_CSRF_TOKEN=$(grep '^X-CSRF-TOKEN=' "$CONFIG_FILE" | cut -d'=' -f2-)
  X_XSRF_TOKEN=$(grep '^X-XSRF-TOKEN=' "$CONFIG_FILE" | cut -d'=' -f2-)
else
  echo "Config file not found!"
  exit 1
fi

# Ensure all tokens are set
if [ -z "$COOKIE" ] || [ -z "$X_CSRF_TOKEN" ] || [ -z "$X_XSRF_TOKEN" ]; then
  echo "Missing token(s) in the config file!"
  exit 1
fi

# Load ignore list into an array if ignore file is specified
declare -A IGNORE_IDS
if [ -n "$IGNORE_FILE" ]; then
  while IFS= read -r IGNORE_ID; do
    IGNORE_IDS["$IGNORE_ID"]=1
  done < "$IGNORE_FILE"
fi

# Function to send vote
vote_for_comment() {
  local COMMENT_ID=$1
  curl -s "https://jbzd.com.pl/comment/vote/$COMMENT_ID" \
    -H 'accept: application/json' \
    -H 'accept-language: en-US,en;q=0.9,pl-PL;q=0.8,pl;q=0.7' \
    -H 'cache-control: no-cache' \
    -H 'content-type: application/json;charset=UTF-8' \
    -H "cookie: $COOKIE" \
    -H 'dnt: 1' \
    -H 'origin: https://jbzd.com.pl' \
    -H 'pragma: no-cache' \
    -H 'priority: u=1, i' \
    -H 'sec-ch-ua: "Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "Linux"' \
    -H 'sec-fetch-dest: empty' \
    -H 'sec-fetch-mode: cors' \
    -H 'sec-fetch-site: same-origin' \
    -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36' \
    -H "x-csrf-token: $X_CSRF_TOKEN" \
    -H 'x-requested-with: XMLHttpRequest' \
    -H "x-xsrf-token: $X_XSRF_TOKEN" \
    --data-raw "{\"for\":$VOTE_VALUE}"
  
  echo "Voted $VOTE_VALUE for comment ID $COMMENT_ID"
  
  # Log the voted ID with vote value to the output file immediately
  echo "$COMMENT_ID-[$VOTE_VALUE]" >> "$VOTED_FILE"
}

# Function to calculate random delay within a range
random_delay() {
  local MIN_DELAY=$(echo "$1" | cut -d'-' -f1)
  local MAX_DELAY=$(echo "$1" | cut -d'-' -f2)
  awk -v min="$MIN_DELAY" -v max="$MAX_DELAY" 'BEGIN{srand(); print min+rand()*(max-min)}'
}

# If a file is specified, prepare the voted file
if [ -f "$COMMENT_ID_OR_FILE" ]; then
  VOTED_FILE="${COMMENT_ID_OR_FILE}_voted"
  > "$VOTED_FILE"  # Clear existing contents if the file already exists
  
  # Iterate over each line (comment ID)
  while IFS= read -r COMMENT_ID; do
    # Skip if COMMENT_ID is in the ignore list
    if [[ -n "${IGNORE_IDS[$COMMENT_ID]}" ]]; then
      echo "Skipping comment ID $COMMENT_ID (in ignore list)"
      continue
    fi
    
    vote_for_comment "$COMMENT_ID"
    
    # Check if delay is a range or single value
    if [[ "$DELAY" =~ ^[0-9]+(\.[0-9]+)?-[0-9]+(\.[0-9]+)?$ ]]; then
      SLEEP_TIME=$(random_delay "$DELAY")
    else
      SLEEP_TIME=$DELAY
    fi

    echo "Sleeping for $SLEEP_TIME seconds..."
    sleep "$SLEEP_TIME"
  done < "$COMMENT_ID_OR_FILE"
else
  # If it's a single ID, vote for it once
  VOTED_FILE="${COMMENT_ID_OR_FILE}_voted"
  
  # Skip if single COMMENT_ID is in the ignore list
  if [[ -n "${IGNORE_IDS[$COMMENT_ID_OR_FILE]}" ]]; then
    echo "Skipping comment ID $COMMENT_ID_OR_FILE (in ignore list)"
  else
    vote_for_comment "$COMMENT_ID_OR_FILE"
  fi
fi

echo "Voting complete. Voted IDs have been saved to $VOTED_FILE."
