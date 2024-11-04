#!/bin/bash

# Split image in quad. (4 equal parts) for jbzd.com.pl comments

# Check if an argument (image file) is given
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <image-file>"
  exit 1
fi

# The input image file
input_image="$1"

# Get image width and height
width=$(identify -format "%w" "$input_image")
height=$(identify -format "%h" "$input_image")

# Calculate half width and half height
half_width=$((width / 2))
half_height=$((height / 2))

# Split the image into four parts
convert "$input_image" -crop "${half_width}x${half_height}+0+0" "${input_image%.jpg}_top_left.jpg"
convert "$input_image" -crop "${half_width}x${half_height}+${half_width}+0" "${input_image%.jpg}_top_right.jpg"
convert "$input_image" -crop "${half_width}x${half_height}+0+${half_height}" "${input_image%.jpg}_bottom_left.jpg"
convert "$input_image" -crop "${half_width}x${half_height}+${half_width}+${half_height}" "${input_image%.jpg}_bottom_right.jpg"

echo "Splitting completed."
