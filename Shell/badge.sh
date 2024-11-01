#!/bin/bash

# Check if the user has provided the required arguments
# Usage: bash badge.sh config.txt <Comment ID or file> <stone|silver|gold|wyp> [delay_or_range] [--ignore filename.txt]
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <config_file> <CID_or_file> <badge_type> [delay_or_range] [--ignore filename.txt]"
  echo "Badge types: stone, silver, gold, wyp"
  echo "Example: $0 config.txt 123 gold"
  echo "Example with file, delay range, and ignore file: $0 config.txt ids.txt gold 3-5 --ignore ignore.txt"
  exit 1
fi

CONFIG_FILE=$1
CID_OR_FILE=$2
BADGE_TYPE=$3
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

# Function to apply badge to a comment
apply_badge() {
  local COMMENT_ID=$1
  curl -s "https://jbzd.com.pl/badge/comment/give/$COMMENT_ID" \
    -H 'accept: application/json' \
    -H 'accept-language: en-US,en;q=0.9' \
    -H 'content-type: application/json;charset=UTF-8' \
    -H "cookie: $COOKIE" \
    -H 'origin: https://jbzd.com.pl' \
    -H 'priority: u=1, i' \
    -H 'sec-ch-ua: "Brave";v="125", "Chromium";v="125", "Not.A/Brand";v="24"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "Linux"' \
    -H 'sec-fetch-dest: empty' \
    -H 'sec-fetch-mode: cors' \
    -H 'sec-fetch-site: same-origin' \
    -H 'sec-gpc: 1' \
    -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36' \
    -H "x-csrf-token: $X_CSRF_TOKEN" \
    -H "x-xsrf-token: $X_XSRF_TOKEN" \
    --data-raw "{\"type\":\"$BADGE_TYPE\"}"
  
  echo "Applied badge '$BADGE_TYPE' to comment ID $COMMENT_ID"
  
  # Log the badge application immediately to the output file
  echo "$COMMENT_ID-[$BADGE_TYPE]" >> "$BADGED_FILE"
}

# Function to calculate random delay within a range
random_delay() {
  local MIN_DELAY=$(echo "$1" | cut -d'-' -f1)
  local MAX_DELAY=$(echo "$1" | cut -d'-' -f2)
  awk -v min="$MIN_DELAY" -v max="$MAX_DELAY" 'BEGIN{srand(); print min+rand()*(max-min)}'
}

# Prepare the badge log file
if [ -f "$CID_OR_FILE" ]; then
  BADGED_FILE="${CID_OR_FILE}_badged"
  >> "$BADGED_FILE"  # Clear existing contents if the file already exists

  # Iterate over each line (comment ID)
  while IFS= read -r COMMENT_ID; do
    # Skip if COMMENT_ID is in the ignore list
    if [[ -n "${IGNORE_IDS[$COMMENT_ID]}" ]]; then
      echo "Skipping comment ID $COMMENT_ID (in ignore list)"
      continue
    fi

    apply_badge "$COMMENT_ID"
    
    # Check if delay is a range or single value
    if [[ "$DELAY" =~ ^[0-9]+(\.[0-9]+)?-[0-9]+(\.[0-9]+)?$ ]]; then
      SLEEP_TIME=$(random_delay "$DELAY")
    else
      SLEEP_TIME=$DELAY
    fi

    echo "Sleeping for $SLEEP_TIME seconds..."
    sleep "$SLEEP_TIME"
  done < "$CID_OR_FILE"
else
  # If it's a single ID, apply the badge once
  BADGED_FILE="${CID_OR_FILE}_badged"
  
  # Skip if single COMMENT_ID is in the ignore list
  if [[ -n "${IGNORE_IDS[$CID_OR_FILE]}" ]]; then
    echo "Skipping comment ID $CID_OR_FILE (in ignore list)"
  else
    apply_badge "$CID_OR_FILE"
  fi
fi

echo "Badge application complete. Badged IDs have been saved to $BADGED_FILE."
