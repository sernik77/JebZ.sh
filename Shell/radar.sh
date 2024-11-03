#!/bin/bash

# Dzid-RADAR
# Compare two most recent _bilans.json logs to monitor +/- ratio changes for specified users and send alerts via discord webhook

# Path to your JSON log file
LOG_FILE=$1

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <bilans.json>"
  exit 1
fi

# Webhook
WEBHOOK_URL="<DISCORD-WEBHOOK-URL>"

# Thresholds for alerts
THRESHOLD_SCORE=50
THRESHOLD_PLUS=50
THRESHOLD_MINUS=50

# Parse the two most recent entries from the JSON log file
recent_logs=$(jq 'sort_by(.date) | reverse | .[:2]' "$LOG_FILE")

# Check if there are at least two logs
if [[ $(echo "$recent_logs" | jq 'length') -lt 2 ]]; then
  echo "Not enough logs to compare."
  exit 1
fi

# Extract values from the most recent log entry
date_new=$(echo "$recent_logs" | jq -r '.[0].date')
user_new=$(echo "$recent_logs" | jq -r '.[0].user')
total_score_new=$(echo "$recent_logs" | jq -r '.[0].bilans.total_score')
ratio_new=$(echo "$recent_logs" | jq -r '.[0].bilans.ratio')
total_plus_new=$(echo "$recent_logs" | jq -r '.[0].total_plus')
total_minus_new=$(echo "$recent_logs" | jq -r '.[0].total_minus')

# Extract values from the second most recent log entry
date_old=$(echo "$recent_logs" | jq -r '.[1].date')
total_score_old=$(echo "$recent_logs" | jq -r '.[1].bilans.total_score')
ratio_old=$(echo "$recent_logs" | jq -r '.[1].bilans.ratio')
total_plus_old=$(echo "$recent_logs" | jq -r '.[1].total_plus')
total_minus_old=$(echo "$recent_logs" | jq -r '.[1].total_minus')

# Calculate differences
total_score_diff=$((total_score_new - total_score_old))
ratio_diff=$(echo "$ratio_new - $ratio_old" | bc)
total_plus_diff=$((total_plus_new - total_plus_old))
total_minus_diff=$((total_minus_new - total_minus_old))

# Display results
echo "Comparing the two most recent logs:"
echo "Date difference: $date_old -> $date_new"
echo "Total Score difference: $total_score_diff"
echo "Ratio difference: $ratio_diff"
echo "Total Plus difference: $total_plus_diff"
echo "Total Minus difference: $total_minus_diff"

# Check if any differences exceed the threshold
if (( total_score_diff > THRESHOLD_SCORE )) || (( total_plus_diff > THRESHOLD_PLUS )) || (( total_minus_diff > THRESHOLD_MINUS )); then
  # Construct the formatted alert message
  alert_message="# Alert! - Anomalie na rynku minusów!!!\n\n\
# User: *$user_new*\n\n\
[$date_old] / [$date_new] \n\
## *Score:* [**$total_score_diff**]\
 *Ratio:* [**$ratio_diff**]\n\
### *Plus:* [**$total_plus_diff**]\
 *Minus:* [**$total_minus_diff**]\n\
URL: https://jbzd.com.pl/uzytkownik/$user_new"

  # Send alert to Discord webhook
  curl -H "Content-Type: application/json" \
       -X POST \
       -d "{\"content\": \"$alert_message\"}" \
       "$WEBHOOK_URL"

  echo "Alert sent!"
else
  echo "No significant changes detected."
fi
