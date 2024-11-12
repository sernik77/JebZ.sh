#!/bin/bash

# Usage: ./deep_search.sh <search_phrase> [--timeout <seconds>]
# Arguments:
# - search_phrase: the phrase to search for (e.g., an email or username)
# - --timeout <seconds>: optional flag to specify a timeout duration in seconds
# The database file is hardcoded as "db.txt"

# Check if a search phrase is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <search_phrase> [--timeout <seconds>]"
    exit 1
fi

# Parse arguments
search_phrase="$1"
timeout=0

if [[ "$2" == "--timeout" && -n "$3" ]]; then
    timeout="$3"
fi

input_file="db.txt"  # Hardcoded database file
log_file="search_log.txt"

# Clear previous log file or create a new one
> "$log_file"

# Output initial phrase to both terminal and log file
echo -e "Phrase: $search_phrase\n" | tee -a "$log_file"

# Associative arrays for tracking unique items
declare -A unique_passwords unique_usernames unique_urls url_map
search_queue=("$search_phrase")
processed_items=()

# Start the timer if a timeout is specified
if [[ "$timeout" -gt 0 ]]; then
    end_time=$((SECONDS + timeout))
fi

# Function to check if an item is unique
is_unique() {
    local item="$1"
    for processed in "${processed_items[@]}"; do
        if [[ "$processed" == "$item" ]]; then
            return 1
        fi
    done
    processed_items+=("$item")
    return 0
}

# Function to save results to the log file
save_results() {
    echo -e "Passwords:" | tee -a "$log_file"
    for pass in "${!unique_passwords[@]}"; do
        echo "$pass" | tee -a "$log_file"
    done

    echo -e "\nUsernames / Emails:" | tee -a "$log_file"
    for user in "${!unique_usernames[@]}"; do
        echo "$user" | tee -a "$log_file"
    done

    echo -e "\nNetwork Discovered:" | tee -a "$log_file"
    for key in "${!url_map[@]}"; do
        for url in ${url_map["$key"]}; do
            if [[ -n "$url" && -z "${unique_urls[$url]}" ]]; then
                unique_urls["$url"]=1
                echo "$url" | tee -a "$log_file"
            fi
        done
    done

    echo -e "\nLog file 'search_log.txt' created with the full network results."
}

# Main loop to process items in the search queue
while [ ${#search_queue[@]} -gt 0 ]; do
    # Check for timeout
    if [[ "$timeout" -gt 0 && $SECONDS -ge $end_time ]]; then
        echo "Timeout reached. Saving collected data..."
        save_results
        exit 0
    fi

    current_phrase="${search_queue[0]}"
    search_queue=("${search_queue[@]:1}")

    # Skip if already processed
    is_unique "$current_phrase" || continue

    # Grep lines only for the current phrase to avoid full-file reads
    matched_lines=$(grep -F "$current_phrase" "$input_file")

    # Process each matched line
    while IFS= read -r line; do
        url=$(echo "$line" | awk '{print $1}')
        user=$(echo "$line" | awk '{print $2}' | cut -d':' -f1)
        pass=$(echo "$line" | awk '{print $2}' | cut -d':' -f2)

        # Process and add unique usernames
        if [[ -n "$user" && -z "${unique_usernames[$user]}" ]]; then
            unique_usernames["$user"]=1
            search_queue+=("$user")
            url_map["$user"]+="$url "
        fi

        # Process and add unique passwords
        if [[ -n "$pass" && -z "${unique_passwords[$pass]}" ]]; then
            unique_passwords["$pass"]=1
            search_queue+=("$pass")
            url_map["$pass"]+="$url "
        fi
    done <<< "$matched_lines"
done

# Save final results
save_results
