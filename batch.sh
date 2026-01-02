#!/bin/bash

# Script to move images with similar file names to a new directory
# Usage: ./move_images.sh <pattern> <source_dir> <destination_dir>

# Check if correct number of arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <pattern> <source_dir> <destination_dir>"
    echo "Example: $0 'image_*' ./photos ./sorted_photos"
    exit 1
fi

PATTERN="$1"
SOURCE_DIR="$2"
DEST_DIR="$3"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Check if we have permission to write to destination
if [ ! -w "$DEST_DIR" ]; then
    echo "Error: No write permission for destination directory '$DEST_DIR'."
    exit 1
fi

echo "Moving files matching pattern: $PATTERN"
echo "From: $SOURCE_DIR"
echo "To: $DEST_DIR"
echo

# Count files before moving
file_count=$(find "$SOURCE_DIR" -maxdepth 1 -name "$PATTERN" | wc -l)
echo "Found $file_count files matching the pattern"

if [ $file_count -eq 0 ]; then
    echo "No files found matching the pattern '$PATTERN' in '$SOURCE_DIR'"
    exit 0
fi

# Ask for confirmation
read -p "Continue moving $file_count files? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Move the files
moved_count=0
for file in "$SOURCE_DIR"/$PATTERN; do
    if [ -f "$file" ]; then
        echo "Moving: $(basename "$file")"
        mv "$file" "$DEST_DIR/"
        ((moved_count++))
    fi
done

echo
echo "Successfully moved $moved_count files to $DEST_DIR"
