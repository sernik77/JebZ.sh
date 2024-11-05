#!/bin/bash

# Script to create a folder in favorites on jbzd.com.pl
# Usage: bash create-favorite-folder.sh <config_file> <FOLDER_NAME>

# Check if the user has provided the required arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <config_file> <FOLDER_NAME>"
  exit 1
fi

CONFIG_FILE=$1
FOLDER_NAME=$2

# Load the config file and extract tokens, handling variable names with hyphens
if [ -f "$CONFIG_FILE" ]; then
  while IFS='=' read -r key value; do
    declare "$key"="$value"
  done < "$CONFIG_FILE"
else
  echo "Config file not found!"
  exit 1
fi

# Ensure all tokens are set
if [ -z "$COOKIE" ] || [ -z "$X-CSRF-TOKEN" ] || [ -z "$X-XSRF-TOKEN" ]; then
  echo "Missing token(s) in the config file!"
  exit 1
fi

# Prepare the JSON data for folder creation
DATA=$(jq -n --arg name "$FOLDER_NAME" '{name: $name}')

# Send the request to create the folder
RESPONSE=$(curl -s 'https://jbzd.com.pl/user/favorite/folder/create' \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.9,pl-PL;q=0.8,pl;q=0.7' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json;charset=UTF-8' \
  -H "cookie: $COOKIE" \
  -H 'origin: https://jbzd.com.pl' \
  -H 'referer: https://jbzd.com.pl/ulubione' \
  -H 'sec-ch-ua: "Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36' \
  -H "x-csrf-token: $X-CSRF-TOKEN" \
  -H "x-xsrf-token: $X-XSRF-TOKEN" \
  --data-raw "$DATA")

# Check the response
if [[ "$RESPONSE" == *'"status":"success"'* ]]; then
  echo "Folder '$FOLDER_NAME' created successfully."
else
  echo "Failed to create folder. Response: $RESPONSE"
fi
