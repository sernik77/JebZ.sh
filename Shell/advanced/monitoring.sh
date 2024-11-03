#!/bin/bash

# Simple script to perform user bilans log and compare at regular time intervals
# Uses load-comments.sh and radar.sh modules

# Params: check and set variables once at the start
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <config_file> <username> [delay between loops (default: 3600s / 1h)]"
  exit 1
fi

# Vars
config=$1
user=$2
delay=${3:-3600s}  # Set default delay to 3600s (1 hour) if not specified

# Infinite loop to repeat the operations
while true; do
  bash load-comments.sh "$config" "$user" all --bilans --json
  bash radar.sh "${user}_bilans.json"
  sleep "$delay"
done
