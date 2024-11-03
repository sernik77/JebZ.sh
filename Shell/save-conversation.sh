#!/bin/bash

# Script to load the contents of a specified private conversation with optional short output.
# Usage: load_conversation.sh <config_file> <hash> [--short]
# <hash>: The unique hash identifier for the conversation.
# --short: Optional flag to extract only "name" and "content" fields from the messages.

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <config_file> <hash> [--short]"
  echo "Example: $0 config.txt u0o4j2mrQZCMjpp1 --short"
  exit 1
fi

CONFIG_FILE=$1
HASH=$2
SHORT_OUTPUT=false

# Check for optional --short flag
if [ "$#" -eq 3 ] && [ "$3" == "--short" ]; then
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
OUTPUT_FILE="${CONFIG_FILE%.*}_conversation_${HASH}.json"

# Fetch conversation messages
RESPONSE=$(curl -s "https://jbzd.com.pl/private-message/message/listing/$HASH?page=1&per_page=100" \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.9,pl-PL;q=0.8,pl;q=0.7' \
  -H 'cache-control: no-cache' \
  -H "cookie: $COOKIE" \
  -H 'dnt: 1' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H "referer: https://jbzd.com.pl/wiadomosci-prywatne/rozmowa/$HASH" \
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
  echo "$RESPONSE" | jq '.messages.data[] | {name: .user.name, content: .content}' > "$OUTPUT_FILE"
else
  echo "$RESPONSE" | jq '.' > "$OUTPUT_FILE"
fi

echo "Conversation content saved to $OUTPUT_FILE"
