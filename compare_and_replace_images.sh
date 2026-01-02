#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <folder1> <folder2>"
    exit 1
fi

folder1="$1"
folder2="$2"

# Loop through all files in folder1
for file in "$folder1"/*; do
    # Get just the filename without path
    filename=$(basename "$file")
    file2="$folder2/$filename"
    
    # Check if corresponding file exists in folder2
    if [ -f "$file2" ]; then
        # Compare files silently
        if ! cmp -s "$file" "$file2"; then
            cp "$file2" "$file"
            echo "Replaced: $filename"
        fi
    else
        echo "Not found in $folder2: $filename"
    fi
done

echo "Operation completed"