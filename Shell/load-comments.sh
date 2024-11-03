#!/bin/bash

# Script to load user comments with optional ID extraction, short output, balance calculation, and comment search.
# Usage: bash load-comments.sh <config_file> <username_or_profile_url> <pages_to_fetch | "all"> [--id] [--short] [--bilans] [--search <query>]
# Options:
#   --id: Extract only the comment IDs
#   --short: Save only specific fields to a short JSON file
#   --bilans: Calculate the total score, plus, and minus values from the short JSON file
#   --search <query>: Extract all comments matching the search query into a separate JSON file

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "jq could not be found, please install it to use this script."
  exit 1
fi

# Check if the user has provided the required arguments
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <config_file> <username_or_profile_url> <pages_to_fetch | 'all'> [--id] [--short] [--bilans] [--search <query>]"
  echo "Example: $0 config.txt templeos all --id --short --bilans --search example"
  exit 1
fi

CONFIG_FILE=$1
USERNAME_OR_URL=$2
PAGES=$3
USERNAME=$(basename "$USERNAME_OR_URL")
ONLY_IDS=false
SHORT_OUTPUT=false
BILANS=false
SEARCH_MODE=false
SEARCH_QUERY=""

# Check for optional flags
for (( i=4; i<=$#; i++ )); do
  arg="${!i}"
  if [[ "$arg" == "--id" ]]; then
    ONLY_IDS=true
  elif [[ "$arg" == "--short" ]]; then
    SHORT_OUTPUT=true
  elif [[ "$arg" == "--bilans" ]]; then
    BILANS=true
    SHORT_OUTPUT=true  # Automatically enable --short when --bilans is used
  elif [[ "$arg" == "--search" ]]; then
    SEARCH_MODE=true
    ((i++))
    SEARCH_QUERY="${!i}"
    SHORT_OUTPUT=true  # Automatically enable --short when --search is used
  fi
done

# Determine if input is a URL or a username, then retrieve user ID and total comments count
if [[ $USERNAME_OR_URL =~ ^https:// ]]; then
  url=$USERNAME_OR_URL
else
  url="https://jbzd.com.pl/uzytkownik/$USERNAME_OR_URL"
fi

# Fetch the HTML content and extract user ID and total comments
html_content=$(curl -s "$url")
USER_ID=$(echo "$html_content" | grep -oP '(?<=&quot;id&quot;:)\d+' | head -n 1)
TOTAL_COMMENTS=$(echo "$html_content" | grep -oP '(?<=<span class="user-icon ion-ios-chatbubble"></span> )\d+' | head -n 1)

# Check if USER_ID was found
if [[ -z $USER_ID ]]; then
  echo "User ID could not be found. Please check the username or URL."
  exit 1
fi

# Check if TOTAL_COMMENTS was found and calculate the number of pages if "all" was specified
if [[ "$PAGES" == "all" ]]; then
  if [[ -n $TOTAL_COMMENTS ]]; then
    PAGES=$(( (TOTAL_COMMENTS + 99) / 100 ))  # Calculates pages, each containing up to 100 comments
    echo "User has $TOTAL_COMMENTS comments, which requires $PAGES pages to fetch."
  else
    echo "Could not determine the total number of comments."
    exit 1
  fi
fi

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

# Initialize variables for totals and temporary storage
total_score=0
total_plus=0
total_minus=0
temp_dir=$(mktemp -d)

# Loop through the pages and fetch each one
for (( PAGE=1; PAGE<=PAGES; PAGE++ )); do
  echo "Fetching page $PAGE of $PAGES..."
  
  # Perform the curl request for each page and capture the response
  RESPONSE=$(curl -s "https://jbzd.com.pl/comment/user/listing/$USER_ID?page=$PAGE&per_page=100&sort=newest" \
    -H 'accept: application/json' \
    -H 'accept-language: en-US,en;q=0.9' \
    -H "cookie: $COOKIE" \
    -H 'priority: u=1, i' \
    -H "referer: https://jbzd.com.pl/uzytkownik/$USERNAME_OR_URL/komentarze" \
    -H 'sec-ch-ua: "Brave";v="125", "Chromium";v="125", "Not.A/Brand";v="24"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "Linux"' \
    -H 'sec-fetch-dest: empty' \
    -H 'sec-fetch-mode: cors' \
    -H 'sec-fetch-site: same-origin' \
    -H 'sec-gpc: 1' \
    -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36' \
    -H "x-csrf-token: $X_CSRF_TOKEN" \
    -H 'x-requested-with: XMLHttpRequest' \
    -H "x-xsrf-token: $X_XSRF_TOKEN")

  # Check if the response contains an empty message or null data
  if [[ "$RESPONSE" == *'"message":""'* ]] || [[ "$RESPONSE" == *'"data":null'* ]]; then
    echo "Page $PAGE returned an empty response or no data. Stopping."
    break
  fi

  # Save the page response to a temporary file
  echo "$RESPONSE" | jq '.pagination.data' > "$temp_dir/page_$PAGE.json"

  # Update totals by summing values directly from response
  total_score=$((total_score + $(echo "$RESPONSE" | jq '[.pagination.data[].score // 0] | add')))
  total_plus=$((total_plus + $(echo "$RESPONSE" | jq '[.pagination.data[].plus // 0] | add')))
  total_minus=$((total_minus + $(echo "$RESPONSE" | jq '[.pagination.data[].minus // 0] | add')))
done

# Combine all page data if --short flag is used
SHORT_OUTPUT_FILE="${USERNAME}_comments_short.json"
if [ "$SHORT_OUTPUT" = true ]; then
  jq -s '[.[][]]' "$temp_dir"/page_*.json | jq '{
      comments: [.[] | 
        {id, 
         comment, 
         score, 
         plus, 
         minus, 
         created_at, 
         badge: (.badge // {} | {gold, silver, stone, wyp})
        }]
    }' > "$SHORT_OUTPUT_FILE"
    cat "$SHORT_OUTPUT_FILE"
  echo "Short output saved to $SHORT_OUTPUT_FILE"
  
fi

# If --id flag is used, extract the comment IDs from "commentable_url"
if [ "$ONLY_IDS" = true ]; then
  ID_OUTPUT_FILE="${USERNAME}_ids.txt"
  jq -s '.[][] | .commentable_url | capture("/(?<id>[0-9]+)$").id' "$temp_dir"/page_*.json > "$ID_OUTPUT_FILE"
  echo -e "\nComment IDs saved to $ID_OUTPUT_FILE"
fi

# Perform search and save matching comments if --search flag is used
if [ "$SEARCH_MODE" = true ]; then
  SEARCH_OUTPUT_FILE="${USERNAME}_search_${SEARCH_QUERY}.json"
  jq --arg query "$SEARCH_QUERY" '[.comments[] | select(.comment | test($query; "i"))]' "$SHORT_OUTPUT_FILE" > "$SEARCH_OUTPUT_FILE"
  cat "$SEARCH_OUTPUT_FILE"
  echo -e "\nComments matching search query \"$SEARCH_QUERY\" saved to $SEARCH_OUTPUT_FILE"
fi


# Display totals for --bilans
if [ "$BILANS" = true ]; then
  BILANS_OUTPUT_FILE="${USERNAME}_bilans.json"

  # Calculate the ratio with printf to ensure correct formatting
  Ratio=$(printf "%0.3f" "$(echo "scale=3; $total_score / $TOTAL_COMMENTS" | bc)")
  DATE=$(date +"%Y-%m-%d %H:%M")
  
  # Prepare the bilans data
  bilans_data=$(cat <<EOF
  
===-=-=-=-=-=-=-=-=-=-=-===
Date: [$DATE]
- - - - - - - - - - - - - -
User: [$USERNAME] / [$USER_ID]
Bilans: [$total_score] / [$Ratio]
- - - - - - - - - - - - - -
Total Comments: [$TOTAL_COMMENTS]
Total Plus [+]: [$total_plus]
Total Minus [-]: [$total_minus]
===-=-=-=-=-=-=-=-=-=-=-===

EOF
) 

  # Append the bilans data to the file and display it
  echo "$bilans_data" | tee -a "$BILANS_OUTPUT_FILE" | boxes -d parchment
  echo -e "\nBilans details appended to $BILANS_OUTPUT_FILE"
fi

# Cleanup temporary files
rm -rf "$temp_dir"
