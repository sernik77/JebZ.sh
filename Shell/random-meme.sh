#!/bin/bash

# Pobierz losowego mema z dzidy z /losowe
# [-n X] X = Ilość memów / [-d /ścieżka/do/folderu]
# bash random-meme.sh -n 10 -d obrazki ~ Pobierz 10 memów do folderu obrazki

# Default number of memes to download
quantity=1
# Default directory to download images to
download_dir="."

# Parse command line arguments
while getopts "n:d:" opt; do
    case ${opt} in
        n ) # Number of memes to download
            quantity=$OPTARG
            ;;
        d ) # Directory to save images
            download_dir=$OPTARG
            ;;
        \? ) echo "Usage: cmd [-n quantity] [-d directory]"
            exit 1
            ;;
    esac
done

# Create download directory if it doesn't exist
mkdir -p "$download_dir"

# Loop to download specified quantity of memes
for (( i=1; i<=quantity; i++ )); do
    echo "Downloading meme $i of $quantity..."

    # Fetch the HTML content of the random meme page
    html_content=$(curl -s "https://jbzd.com.pl/losowe")

    # Extract the image URL
    image_url=$(echo "$html_content" | grep -oP '(?<=<img src=")https://i[0-9].jbzd.com.pl/contents/[^\s"]+' | head -n 1)

    # Check if we successfully extracted an image URL
    if [ -n "$image_url" ]; then
        echo "Found image URL: $image_url"
        
        # Extract the image filename from the URL
        filename=$(basename "$image_url")
        
        # Download the image to the specified directory
        curl -s "$image_url" -o "$download_dir/$filename"
        echo "Image saved as $download_dir/$filename"
    else
        echo "No image URL found. Skipping this meme."
    fi
done

echo "Downloaded $quantity memes to $download_dir."
