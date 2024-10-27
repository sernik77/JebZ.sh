#!/bin/bash

# $0 config.txt <UID> <blacklisted> <followed>
# Np: bash user-modify.sh config.txt <UID> true false

if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <config_file> <UID> <blacklisted:true|false> <followed:true|false>"
  exit 1
fi

CONFIG_FILE=$1
UID=$2
BLACKLISTED=$3
FOLLOWED=$4

# Load the config file
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
else
  echo "Config file not found!"
  exit 1
fi

# Ensure all tokens are set
if [ -z "$COOKIE" ] || [ -z "$X_CSRF_TOKEN" ] || [ -z "$X_XSRF_TOKEN" ]; then
  echo "Missing token(s) in the config file!"
  exit 1
fi

# Execute the curl request with the variables from the config file
curl "https://jbzd.com.pl/user/filter/user/$UID" \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.8' \
  -H 'content-type: application/json;charset=UTF-8' \
  -H "cookie: $COOKIE" \
  -H 'origin: https://jbzd.com.pl' \
  -H 'priority: u=1, i' \
  -H 'referer: https://jbzd.com.pl/oczekujace/3' \
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
  --data-raw "{\"blacklisted\":$BLACKLISTED,\"followed\":$FOLLOWED}"
