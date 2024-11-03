#!/bin/bash

# Script to send a vote with value 1 to specified content.
# Usage: bash vote-content.sh <config_file> <CONTENT_ID>

# Check if the user has provided the required arguments
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <config_file> <CONTENT_ID>"
  echo "Example: $0 config.txt 123456"
  exit 1
fi

CONFIG_FILE=$1
CONTENT_ID=$2

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

# Execute the curl request to send the vote
RESPONSE=$(curl -s "https://jbzd.com.pl/content/vote/$CONTENT_ID" \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.9,pl-PL;q=0.8,pl;q=0.7' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json;charset=UTF-8' \
  -H "cookie: $COOKIE" \
  -H 'dnt: 1' \
  -H 'origin: https://jbzd.com.pl' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'referer: https://jbzd.com.pl/oczekujace' \
  -H 'sec-ch-ua: "Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36' \
  -H "x-csrf-token: $X_CSRF_TOKEN" \
  -H "x-xsrf-token: $X_XSRF_TOKEN" \
  --data-raw '{"for":1}')

# Output the response
if [[ "$RESPONSE" == *"success"* ]]; then
  echo "Vote of 1 sent successfully for content ID $CONTENT_ID."
else
  echo "Failed to send vote. Response: $RESPONSE"
fi
