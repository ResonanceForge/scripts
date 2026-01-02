#!/bin/bash

# Check if qpdf is installed
if ! command -v qpdf &> /dev/null; then
    echo "Error: qpdf is not installed. Please install it first."
    exit 1
fi

# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_file.pdf> <output_file.pdf>"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="$2"

# Run qpdf command
# The range '1-z' selects all pages (1 to end).
# The modifier ':even' filters for every 2nd page in that range.
qpdf "$INPUT_FILE" --pages . 1-z:even -- "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Success! Even pages extracted to '$OUTPUT_FILE'."
else
    echo "An error occurred."
fi
