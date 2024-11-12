#!/bin/bash

# The URL of the page to scrape
URL="https://jbzd.com.pl/losowe"

# Use curl to fetch the HTML content of the page
HTML_CONTENT=$(curl -s $URL)

# Extract URLs of media files (jpg, png, gif, mp4) from the HTML content
# This regular expression might need adjustments depending on the actual HTML structure of the page
MEDIA_URLS=$(echo "$HTML_CONTENT" | grep -oP 'https://i1.jbzd.com.pl/contents/[^"]*\.(jpg|png|gif|mp4)')

# Download each media file
for media_url in $MEDIA_URLS; do
    wget $media_url
done
