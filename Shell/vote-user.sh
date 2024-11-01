#!/bin/bash

# Check if the user has provided the required arguments
# Usage: bash user_vote.sh config.txt <USER_ID_or_file> [delay_range]
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <config_file> <USER_ID_or_file> [delay_range]"
  echo "Example: $0 config.txt 12345"
  echo "Example with file and delay range: $0 config.txt uid.txt 2-4"
  exit 1
fi

CONFIG_FILE=$1
USER_ID_OR_FILE=$2
DELAY_RANGE=${3:-0}  # Default delay is 0 if not specified
VOTE_VALUE=1  # Fixed upvote value

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

# Function to send an upvote request for a single user
vote_for_user() {
  local USER_ID=$1
  curl -s "https://jbzd.com.pl/user/vote/$USER_ID" \
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
    --data-raw "{\"for\":$VOTE_VALUE}"

  echo "Upvote for user ID $USER_ID completed."
  
  # Log the voted ID immediately to the output file
  echo "$USER_ID-[upvote]" >> "$VOTED_FILE"
}

# Function to calculate random delay within a specified range
random_delay() {
  local MIN_DELAY=$(echo "$1" | cut -d'-' -f1)
  local MAX_DELAY=$(echo "$1" | cut -d'-' -f2)
  awk -v min="$MIN_DELAY" -v max="$MAX_DELAY" 'BEGIN{srand(); print min+rand()*(max-min)}'
}

# Prepare the voted log file
if [ -f "$USER_ID_OR_FILE" ]; then
  VOTED_FILE="${USER_ID_OR_FILE}_voted"
  > "$VOTED_FILE"  # Clear existing contents if the file already exists

  # Iterate over each user ID in the file
  while IFS= read -r USER_ID; do
    vote_for_user "$USER_ID"
    
    # Determine delay time
    if [[ "$DELAY_RANGE" =~ ^[0-9]+(\.[0-9]+)?-[0-9]+(\.[0-9]+)?$ ]]; then
      SLEEP_TIME=$(random_delay "$DELAY_RANGE")
    else
      SLEEP_TIME=$DELAY_RANGE
    fi

    echo "Sleeping for $SLEEP_TIME seconds..."
    sleep "$SLEEP_TIME"
  done < "$USER_ID_OR_FILE"
else
  # If it's a single ID, vote for it once
  VOTED_FILE="${USER_ID_OR_FILE}_voted"
  vote_for_user "$USER_ID_OR_FILE"
fi

echo "Voting complete. Voted IDs have been saved to $VOTED_FILE."
