#!/bin/bash

# Set the URL prefix
URL_PREFIX="https://jbzd.com.pl/uzytkownik/"

# Create a folder for user data if it doesn't exist
mkdir -p users

# Loop through each username in dzidowcy.txt
while IFS= read -r NICK; do
    # Generate the full URL for the user
    USER_URL="${URL_PREFIX}${NICK}/komentarze"

    # Use curl to fetch the user page and save it to a file
    curl -s "$USER_URL" > "users/${NICK}.html"

    # Attempt to download the avatar from the different variations
    avatar_url=$(grep -o '<img src="https://i1.jbzd.com.pl/users/\(large\|small\)/[^"]*' "users/${NICK}.html" | awk -F '"' '{print $2}' | head -n 1)

    if [ -n "$avatar_url" ]; then
        # Download the avatar as a 500x500 jpg
        avatar_file="users/${NICK}.jpg"
        curl -s "$avatar_url" > "$avatar_file"

        # Print a message to indicate the avatar download
        echo "Downloaded avatar for $NICK to $avatar_file"
    else
        # Print a message if no avatar was found
        echo "No avatar found for $NICK"
    fi
done < dzidowcy.txt
