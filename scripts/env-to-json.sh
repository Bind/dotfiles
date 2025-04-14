#!/bin/bash

# Read the .env file line by line
echo "{"
while read -r line; do
    # Ignore comments and blank lines
    if [[ $line == \#* || -z $line ]]; then
        continue
    fi

    # Extract the key and value from the line
    key=${line%%=*}
    value=${line#*=}

    # Escape special characters in the value
    value=${value//\"/\\\"}

    # Append the key-value pair to the JSON output
    echo "\"$key\": \"$value\","
done < "$1" | sed '$ s/.$//'
echo "}"