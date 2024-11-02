#!/bin/bash

# Script to change user password by submitting current and new passwords.
# Usage: change_password.sh <config_file> <USER_ID> <OLD_PASSWORD> <NEW_PASSWORD>
# <USER_ID>: User ID to specify in the request.
# <OLD_PASSWORD>: Current password.
# <NEW_PASSWORD>: New password to set.

if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <config_file> <USER_ID> <OLD_PASSWORD> <NEW_PASSWORD>"
  echo "Example: $0 config.txt 582760 old_password new_password"
  exit 1
fi

CONFIG_FILE=$1
USER_ID=$2
OLD_PASSWORD=$3
NEW_PASSWORD=$4

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

# Execute the curl request with the variables from the config file
curl "https://jbzd.com.pl/user/change-password/$USER_ID" \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.6' \
  -H 'content-type: application/json;charset=UTF-8' \
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
  -H "x-xsrf-token: $X-XSRF-TOKEN" \
  --data-raw "{\"password_current\":\"$OLD_PASSWORD\",\"password\":\"$NEW_PASSWORD\",\"password_confirmation\":\"$NEW_PASSWORD\"}"

echo "Password change request for USER_ID $USER_ID sent successfully."
