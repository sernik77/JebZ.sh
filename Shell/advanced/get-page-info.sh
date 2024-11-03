#!/bin/bash

# Get jbzd.com.pl/str/X info, like:

# [title] [id]
# URL: X
# SRC: X
# score: X
# gold: X
# silver: X
# stone: X
# wyp: X

# Check if page number is passed as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <page_number>"
    exit 1
fi

# Define variables
PAGE_NUM=$1
OUTPUT_FILE="${PAGE_NUM}.txt"
URL="https://jbzd.com.pl/str/${PAGE_NUM}"

# Download the HTML source of the page
wget -q -O page.html "$URL"

# Separate each article's HTML block
awk '/<article class="article"/{flag=1} flag; /<\/article>/{flag=0}' page.html > articles.html

# Parse each article block individually
grep -oP '<article class="article" data-content-id="[^"]+"' articles.html | cut -d'"' -f4 | while read -r ID; do
    # Extract article block with the specific ID
    ARTICLE_HTML=$(awk "/<article class=\"article\" data-content-id=\"$ID\"/,/<\/article>/" articles.html)

    # Extract TITLE
    TITLE=$(echo "$ARTICLE_HTML" | grep -oP "<a href=\"https://jbzd.com.pl/obr/${ID}/[^\"]+\"" | head -1 | sed -E "s/^.*\/${ID}\///; s/\"//g")

    # Extract IMG_SRC
    IMG_SRC=$(echo "$ARTICLE_HTML" | grep -oP "(?<=<img src=\")[^\"]+(?=\" class=\"article-image\" alt=\"$TITLE\")")

    # Extract score
    SCORE=$(echo "$ARTICLE_HTML" | grep -oP "(?<=<vote :default_active=\"false\" :id=\"$ID\" :score=\")[^\"]+")

    # Extract badge counts (gold, silver, stone, wyp)
    BADGE_DATA=$(echo "$ARTICLE_HTML" | grep -oP "(?<=:model-badge='\{\"badgeable_id\":$ID,\"gold\":)[0-9]+|(?<=,\"silver\":)[0-9]+|(?<=,\"stone\":)[0-9]+|(?<=,\"wyp\":)[0-9]+")
    GOLD=$(echo "$BADGE_DATA" | sed -n '1p')
    SILVER=$(echo "$BADGE_DATA" | sed -n '2p')
    STONE=$(echo "$BADGE_DATA" | sed -n '3p')
    WYP=$(echo "$BADGE_DATA" | sed -n '4p')

    # Write extracted information to output file
    echo "[$TITLE] [$ID]" >> "$OUTPUT_FILE"
    echo "URL: https://jbzd.com.pl/obr/$ID/$TITLE" >> "$OUTPUT_FILE"
    echo "SRC: $IMG_SRC" >> "$OUTPUT_FILE"
    echo "score: $SCORE" >> "$OUTPUT_FILE"
    echo "gold: $GOLD" >> "$OUTPUT_FILE"
    echo "silver: $SILVER" >> "$OUTPUT_FILE"
    echo "stone: $STONE" >> "$OUTPUT_FILE"
    echo "wyp: $WYP" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done

# Clean up
# rm page.html articles.html

#!/bin/bash

# Input file with data
input_file="articles.html"

# Output file to save the results
output_file="scores.txt"

# Clear output file if it exists
> "$output_file"

# Read the input file line by line
while IFS= read -r line; do
    # If line contains ":score=", output previous line and current line
    if [[ "$line" == *":score="* ]]; then
        echo "$prev_line" >> "$output_file"
        echo "$line" >> "$output_file"
        echo >> "$output_file"  # Blank line for formatting
    fi
    # Update the previous line variable
    prev_line="$line"
done < "$input_file"

# Assign arguments to variables
scores_file="scores.txt"
elements_file="$OUTPUT_FILE"
temp_file=$(mktemp)

# Extract id and score from scores file and store them in an associative array
declare -A scores_map
while read -r line; do
  if [[ $line =~ :id=\"([0-9]+)\" ]]; then
    id="${BASH_REMATCH[1]}"
  elif [[ $line =~ :score=\"([0-9]+)\" ]]; then
    score="${BASH_REMATCH[1]}"
    scores_map["$id"]="$score"
  fi
done < "$scores_file"

# Process the elements file and update the scores
while IFS= read -r line; do
  # Check if the line contains an ID
  if [[ $line =~ \[([0-9]+)\] ]]; then
    current_id="${BASH_REMATCH[1]}"
  fi

  # If the line starts with "score:", update it if we have a matching score for the current ID
  if [[ $line =~ ^score:\  ]]; then
    if [[ -n "${scores_map[$current_id]}" ]]; then
      echo "score: ${scores_map[$current_id]}"
    else
      echo "$line"
    fi
  else
    echo "$line"
  fi
done < "$elements_file" > "$temp_file"

# Replace the original elements file with the updated content
mv "$temp_file" "$elements_file"

# Define file paths
SOURCE_FILE="$OUTPUT_FILE"       # Source file with URLs and empty SRC lines
ARTICLES_FILE="articles.html"  # HTML file containing links and image sources

# Loop through each line in the source file
while read -r line; do
    # Check if the line contains "URL:"
    if [[ "$line" =~ ^URL:\ (https?://[^[:space:]]+) ]]; then
        url="${BASH_REMATCH[1]}"
        
        # Find the line containing the URL in the articles file
        img_src=$(grep -A 1 "$url" "$ARTICLES_FILE" | awk -F'"' '/<img src=/{print $2}')
        
        # If an img src is found, update the SRC line in the source file
        if [[ -n "$img_src" ]]; then
            # Escape special characters in URL for sed
            escaped_url=$(printf '%s\n' "$url" | sed 's/[\/&]/\\&/g')
            escaped_img_src=$(printf '%s\n' "$img_src" | sed 's/[\/&]/\\&/g')
            
            # Replace the empty SRC line with the found img src URL
            sed -i "/^URL: $escaped_url/{n;s|^SRC:.*|SRC: $escaped_img_src|}" "$SOURCE_FILE"
            echo "Updated SRC for $url"
        else
            echo "No image source found for $url"
        fi
    fi
done < "$SOURCE_FILE"

rm page.html articles.html scores.txt
