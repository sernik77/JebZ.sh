#!/bin/bash

# Check if input was given
if [[ -z $1 ]]; then
    echo "Usage: $0 <username or full URL>"
    exit 1
fi

# Determine if input is a URL or a username
if [[ $1 =~ ^https:// ]]; then
    # If input is a URL, use it directly
    url=$1
else
    # If input is a username, construct the URL
    url="https://jbzd.com.pl/uzytkownik/$1"
fi

# Fetch the HTML content quietly, ignoring errors
html_content=$(curl -s "$url" 2>/dev/null)

# Extract the user ID
user_id=$(echo "$html_content" | grep -oP '(?<=&quot;id&quot;:)\d+' | head -n 1)

# Check if user ID was found
if [[ -n $user_id ]]; then
    echo "User ID: $user_id"
else
    echo "User ID not found. Please check the username or URL."
fi
