#!/bin/bash

# Check if input was given
if [[ -z $1 ]]; then
    echo "Usage: $0 <username or full URL> [--detailed]"
    exit 1
fi

# Check if --detailed flag is set
detailed=false
if [[ "$2" == "--detailed" ]]; then
    detailed=true
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

    # If --detailed flag is provided, extract additional information
    if [[ "$detailed" == true ]]; then
        # Extract Nick
        nick=$(echo "$html_content" | grep -oP '(?<=<title>Profil użytkownika ).*?(?= - JBZD.com.pl)' | head -n 1)

        # Extract Uploads, Comments, and Created date
        uploads=$(echo "$html_content" | grep -oP '(?<=<span class="user-icon ion-image"></span> )\d+ / \d+' | head -n 1)
        comments=$(echo "$html_content" | grep -oP '(?<=<span class="user-icon ion-ios-chatbubble"></span> )\d+' | head -n 1)
        created=$(echo "$html_content" | grep -oP '(?<=<span class="user-icon ion-ios-flag"></span> )\d{2}\.\d{2}\.\d{4}' | head -n 1)

        # Display detailed information
        echo -e "$nick $user_id\nUploads: $uploads\nComments: $comments\nCreated: $created"
    fi
else
    echo "User ID not found. Please check the username or URL."
fi
