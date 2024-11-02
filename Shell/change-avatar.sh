#!/bin/bash

# Script to change avatar by uploading an image file.
# Usage: change_avatar.sh <config_file> <USER_ID> <path_to_image>
# <USER_ID>: User ID to specify in the request.
# <path_to_image>: Path to the image file to use as the new avatar.

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <config_file> <USER_ID> <path_to_image>"
  echo "Example: $0 config.txt 1226352 /path/to/avatar.png"
  exit 1
fi

CONFIG_FILE=$1
USER_ID=$2
IMAGE_PATH=$3

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

# Check if image file exists
if [ ! -f "$IMAGE_PATH" ]; then
  echo "Image file not found!"
  exit 1
fi

# Convert the image to Base64
IMAGE_BASE64=$(base64 -w 0 "$IMAGE_PATH")

# Execute the curl request with the variables from the config file
curl "https://jbzd.com.pl/user/change-avatar/$USER_ID" \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json;charset=UTF-8' \
  -H "cookie: $COOKIE" \
  -H 'dnt: 1' \
  -H 'origin: https://jbzd.com.pl' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'referer: https://jbzd.com.pl/uzytkownik/ustawienia' \
  -H 'sec-ch-ua: "Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36' \
  -H "x-xsrf-token: $X-XSRF-TOKEN" \
  --data-raw "{\"image\":\"data:image/png;base64,$IMAGE_BASE64\"}"

echo "Avatar change request for USER_ID $USER_ID sent successfully."
