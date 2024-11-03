#!/bin/bash

# Script to delete the user account.
# Usage: delete_account.sh <config_file>

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <config_file>"
  echo "Example: $0 config.txt"
  exit 1
fi

CONFIG_FILE=$1

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

# Execute the curl request to delete the account
curl 'https://jbzd.com.pl/user/delete-account' \
  -X 'POST' \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.8' \
  -H 'content-length: 0' \
  -H "cookie: $COOKIE" \
  -H 'origin: https://jbzd.com.pl' \
  -H 'priority: u=1, i' \
  -H 'referer: https://jbzd.com.pl/uzytkownik/ustawienia' \
  -H 'sec-ch-ua: "Brave";v="125", "Chromium";v="125", "Not.A/Brand";v="24"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-gpc: 1' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36' \
  -H "x-csrf-token: $X-CSRF-TOKEN" \
  -H "x-xsrf-token: $X-XSRF-TOKEN"

echo "Account deletion request sent."
