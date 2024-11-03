#!/bin/bash

# Script to load private conversations with an optional --short flag for summarized data.
# Usage: load_conversations.sh <config_file> [--short]

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "Usage: $0 <config_file> [--short]"
  echo "Example: $0 config.txt --short"
  exit 1
fi

CONFIG_FILE=$1
SHORT=false

# Check if the --short flag is provided
if [ "$2" == "--short" ]; then
  SHORT=true
fi

OUTPUT_FILE="${CONFIG_FILE%.*}_conversations.json"

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

# Fetch conversations and process based on the --short flag
RESPONSE=$(curl -s 'https://jbzd.com.pl/private-message/thread/listing?page=1&per_page=100' \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.9,pl-PL;q=0.8,pl;q=0.7' \
  -H 'cache-control: no-cache' \
  -H "cookie: $COOKIE" \
  -H 'dnt: 1' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'referer: https://jbzd.com.pl/wiadomosci-prywatne' \
  -H 'sec-ch-ua: "Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36' \
  -H "x-csrf-token: $X-CSRF-TOKEN" \
  -H "x-xsrf-token: $X-XSRF-TOKEN")

if [ "$SHORT" = true ]; then
  echo "$RESPONSE" | jq '.threads.data[] | {
    hash,
    participant_1,
    participant_2,
    updated_at,
    created_at,
    participant1: { id: .participant1.id, name: .participant1.name },
    participant2: { id: .participant2.id, name: .participant2.name },
    last_message: { content: .last_message.content }
  }' > "$OUTPUT_FILE"
else
  echo "$RESPONSE" | jq '.' > "$OUTPUT_FILE"
fi

echo "Conversations saved to $OUTPUT_FILE"
