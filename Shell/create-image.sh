#!/bin/bash

# Prosty skrypt dodający mema obrazkowego.
# Użycie: <plik config> <tytuł> <ścieżka do folderu lub konkretnego pliku>
# Gdzie plik config to ciastka i tokeny danego użytkownika, każdy użytkownik ma własny config. (config musi zawierać wartości COOKIE, X-XSRF-TOKEN oraz X-CSRF-TOKEN)
# Tytuł to tytuł wrzuty (tagi są takie jak tytuł)
# Ścieżka do folderu lub konkretnego pliku - Jeśli podasz ścieżkę folderu, skrypt wybierze losowy obrazek w formacie jpg, jpeg, png, gif.
# Np `bash create-image.sh config/username.txt dupa obrazki/`

# Check if the user has provided a config file and a file or directory path
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <config_file> <title> <path_to_folder_or_file>"
  exit 1
fi

CONFIG_FILE=$1
TITLE=$2
FILE_PATH=$3

# Load the config file
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
else
  echo "Config file not found!"
  exit 1
fi

# Ensure all tokens are set
if [ -z "$COOKIE" ] || [ -z "$X-CSRF-TOKEN" ] || [ -z "$X-XSRF-TOKEN" ]; then
  echo "Missing token(s) in the config file!"
  exit 1
fi

# Check if the given path is a directory
if [ -d "$FILE_PATH" ]; then
  # Select a random image file (jpg, jpeg, png, gif) from the directory
  FILE_PATH=$(find "$FILE_PATH" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) | shuf -n 1)
  
  # Check if a file was found
  if [ -z "$FILE_PATH" ]; then
    echo "No valid image files found in the specified directory!"
    exit 1
  fi
elif [ ! -f "$FILE_PATH" ]; then
  echo "File does not exist!"
  exit 1
fi

# Execute the curl request with the variables from the config file
curl 'https://jbzd.com.pl/content/create/image' \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.9,pl-PL;q=0.8,pl;q=0.7' \
  -H 'cache-control: no-cache' \
  -H 'content-type: multipart/form-data' \
  -H "cookie: $COOKIE" \
  -H 'dnt: 1' \
  -H 'origin: https://jbzd.com.pl' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'referer: https://jbzd.com.pl/oczekujace' \
  -H 'sec-ch-ua: "Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36' \
  -H "x-csrf-token: $X-CSRF-TOKEN" \
  -H "x-xsrf-token: $X-XSRF-TOKEN" \
  -F "title=$TITLE" \
  -F 'description=' \
  -F 'state=humor-memy' \
  -F 'mca=false' \
  -F 'mero=false' \
  -F 'mature=false' \
  -F 'search=' \
  -F "tags[0]=$TITLE" \
  -F 'age_group=0' \
  -F 'agreements[0]=1' \
  -F "file[7gTAAEwX2KzloMhj]=@$FILE_PATH"
