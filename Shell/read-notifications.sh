#!/bin/bash

# Script to load notifications with optional short output.
# Usage: load_notifications.sh <config_file> [--short]
# --short: Optional flag to extract short version.

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <config_file> [--short]"
  echo "Example: $0 config.txt --short"
  exit 1
fi

CONFIG_FILE=$1
SHORT_OUTPUT=false

# Check for optional --short flag
if [ "$#" -eq 2 ] && [ "$2" == "--short" ]; then
  SHORT_OUTPUT=true
fi

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

# Define output file
OUTPUT_FILE="${CONFIG_FILE%.*}_notifications.json"

# Fetch notifications
RESPONSE=$(curl -s 'https://jbzd.com.pl/user/notification/listing?page=1&per_page=100' \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.9,pl-PL;q=0.8,pl;q=0.7' \
  -H 'cache-control: no-cache' \
  -H "cookie: $COOKIE" \
  -H 'dnt: 1' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'referer: https://jbzd.com.pl/wiadomosci-prywatne/rozmowa/s9VcaQJhp1Mskutj' \
  -H 'sec-ch-ua: "Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36' \
  -H "x-csrf-token: $X-CSRF-TOKEN" \
  -H "x-xsrf-token: $X-XSRF-TOKEN")

# Process the response based on the --short flag
if [ "$SHORT_OUTPUT" = true ]; then
  echo "$RESPONSE" | jq '.notifications.data[] | {message: .message, route: .route, created_at: .created_at, updated_at: .updated_at, message_parsed: .message_parsed, route_parsed: .route_parsed, params: {badge: .params.badge, name: .params.name, title: .params.title, username: .params.username}}' > "$OUTPUT_FILE"
else
  echo "$RESPONSE" | jq '.' > "$OUTPUT_FILE"
fi

echo "Notifications saved to $OUTPUT_FILE"
