#!/bin/bash

# Script to delete specified content on jbzd.com.pl
# Usage: bash delete-content.sh <config_file> <CONTENT_ID>

# Check if the user has provided the required arguments
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <config_file> <CONTENT_ID>"
  echo "Example: $0 config.txt 123456"
  exit 1
fi

CONFIG_FILE=$1
CONTENT_ID=$2

# Load the config file and extract tokens
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

# Execute the curl request to delete the content
RESPONSE=$(curl -s -X DELETE "https://jbzd.com.pl/content/$CONTENT_ID" \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.6' \
  -H "cookie: $COOKIE" \
  -H 'origin: https://jbzd.com.pl' \
  -H 'priority: u=1, i' \
  -H 'referer: https://jbzd.com.pl/oczekujace' \
  -H 'sec-ch-ua: "Brave";v="125", "Chromium";v="125", "Not.A/Brand";v="24"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36' \
  -H "x-csrf-token: $X_CSRF_TOKEN" \
  -H "x-xsrf-token: $X_XSRF_TOKEN")

# Check if the response is empty, indicating successful deletion
if [[ "$RESPONSE" == "[]" ]]; then
  echo "Content with ID $CONTENT_ID deleted successfully."
else
  echo "Failed to delete content. Response: $RESPONSE"
fi
