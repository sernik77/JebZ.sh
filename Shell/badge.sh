#!/bin/bash

# Check if the user has provided the required arguments
# bash badge.sh config.txt <Comment ID> <stone|silver|gold|wyp>
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <config_file> <CID> <badge_type>"
  echo "Badge types: stone, silver, gold, wyp"
  echo "Example: $0 config.txt 123 gold"
  exit 1
fi

CONFIG_FILE=$1
CID=$2
BADGE_TYPE=$3

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

# Validate badge type
if [[ "$BADGE_TYPE" != "stone" && "$BADGE_TYPE" != "silver" && "$BADGE_TYPE" != "gold" && "$BADGE_TYPE" != "wyp" ]]; then
  echo "Invalid badge type. Use one of: stone, silver, gold, wyp."
  exit 1
fi

# Execute the curl request with the variables from the config file
curl "https://jbzd.com.pl/badge/comment/give/$CID" \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'content-type: application/json;charset=UTF-8' \
  -H "cookie: $COOKIE" \
  -H 'origin: https://jbzd.com.pl' \
  -H 'priority: u=1, i' \
  -H 'referer: https://jbzd.com.pl/obr/3872883/uwu' \
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
  --data-raw "{\"type\":\"$BADGE_TYPE\"}"
