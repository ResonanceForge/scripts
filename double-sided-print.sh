#!/bin/bash

set -e

# Function to clean up temp files on exit (runs even if script crashes)
cleanup() {
    rm -f "$TEMP_EVEN" "$TEMP_ODD"
}
trap cleanup EXIT

# 1. Dependency Checks
if ! command -v qpdf &> /dev/null; then
    echo "Error: qpdf is not installed."
    exit 1
fi

if ! command -v lp &> /dev/null; then
    echo "Error: cups (lp) is not installed."
    exit 1
fi

# 2. Argument Checks
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_file.pdf> <printer-name>"
    exit 1
fi

INPUT_FILE="$1"
PRINTER="$2"

# Create temporary files
TEMP_EVEN=$(mktemp --suffix=.pdf)
TEMP_ODD=$(mktemp --suffix=.pdf)

echo "Processing PDF..."

# 3. Split the PDF
# Note: Depending on your printer's output tray (face-up vs face-down),
# you might need to add --reverse to one of these lines.
qpdf "$INPUT_FILE" --pages . 1-z:even -- "$TEMP_EVEN"
qpdf "$INPUT_FILE" --pages . 1-z:odd -- "$TEMP_ODD"

# 4. Print Evens
echo "Sending EVEN pages to printer '$PRINTER'..."
lp -d "$PRINTER" "$TEMP_EVEN"

# 5. User Interaction
echo "----------------------------------------------------"
echo "Step 1 complete."
echo "Please take the paper, flip it, and put it back in the tray."
echo "Ensure orientation matches your printer's manual duplex style."
echo "Press [Enter] when ready to print ODD pages..."
read -r
echo "----------------------------------------------------"

# 6. Print Odds
echo "Sending ODD pages to printer '$PRINTER'..."
lp -d "$PRINTER" "$TEMP_ODD"

echo "Success! All jobs sent to queue."
