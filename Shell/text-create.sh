#!/bin/bash

# Check if correct number of arguments are provided
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 config.txt <title> <text or path to file>"
  exit 1
fi

# Parse command line arguments
CONFIG_FILE="$1"
TITLE="$2"
CONTENT_INPUT="$3"


# Verify the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: Config file ($CONFIG_FILE) not found!"
  exit 1
fi

# Read COOKIE, X_CSRF_TOKEN, X_XSRF_TOKEN from config file
COOKIE=$(grep '^COOKIE=' "$CONFIG_FILE" | cut -d '=' -f2-)
X_CSRF_TOKEN=$(grep '^X-CSRF-TOKEN=' "$CONFIG_FILE" | cut -d '=' -f2-)
X_XSRF_TOKEN=$(grep '^X-XSRF-TOKEN=' "$CONFIG_FILE" | cut -d '=' -f2-)

# Validate that all required variables are set
if [ -z "$COOKIE" ] || [ -z "$X_CSRF_TOKEN" ] || [ -z "$X_XSRF_TOKEN" ]; then
  echo "Error: COOKIE, X-CSRF-TOKEN, and X-XSRF-TOKEN must be set in $CONFIG_FILE"
  exit 1
fi

# Prepare content
if [ -f "$CONTENT_INPUT" ]; then
  CONTENT=$(cat "$CONTENT_INPUT")
else
  CONTENT="$CONTENT_INPUT"
fi

# Define the boundary
BOUNDARY="----WebKitFormBoundary$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)"

# Send the request
curl 'https://jbzd.com.pl/content/create/article' \
  -H "accept: application/json" \
  -H "accept-language: en-US,en;q=0.8" \
  -H "content-type: multipart/form-data; boundary=$BOUNDARY" \
  -H "cookie: $COOKIE" \
  -H "origin: https://jbzd.com.pl" \
  -H "priority: u=1, i" \
  -H "referer: https://jbzd.com.pl/oczekujace" \
  -H 'sec-ch-ua: "Brave";v="125", "Chromium";v="125", "Not.A/Brand";v="24"' \
  -H "sec-ch-ua-mobile: ?0" \
  -H "sec-ch-ua-platform: \"Linux\"" \
  -H "sec-fetch-dest: empty" \
  -H "sec-fetch-mode: cors" \
  -H "sec-fetch-site: same-origin" \
  -H "sec-gpc: 1" \
  -H "user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36" \
  -H "x-csrf-token: $X_CSRF_TOKEN" \
  -H "x-xsrf-token: $X_XSRF_TOKEN" \
  --data-raw $'--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="additional[0][id]"\r\n\r\nX1ysZk8VzBxf0UY6\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="additional[0][type]"\r\n\r\narticle\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="additional[0][content][description]"\r\n\r\n'"$CONTENT"$'\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="title"\r\n\r\n'"$TITLE"$'\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="description"\r\n\r\n\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="state"\r\n\r\nhumor-memy\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="mca"\r\n\r\nfalse\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="mero"\r\n\r\nfalse\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="mature"\r\n\r\nfalse\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="search"\r\n\r\n\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="tags[0]"\r\n\r\ntag\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="age_group"\r\n\r\n0\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="agreements[0]"\r\n\r\n1\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="linking[url]"\r\n\r\n\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="linking[title]"\r\n\r\n\r\n--'"$BOUNDARY"$'\r\nContent-Disposition: form-data; name="linking[description]"\r\n\r\n\r\n--'"$BOUNDARY"$'--\r\n'
