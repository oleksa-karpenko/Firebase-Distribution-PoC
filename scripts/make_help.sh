#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OUTPUT_FILE="$SCRIPT_DIR/../docs/make.md"
SEARCH_DIR="make" # Default to current directory


for MAKEFILE in ./make/*.mk; do
    if [[ ! -f "$MAKEFILE" ]]; then
        continue
    fi

    MAKEFILE_NAME=$(basename "$MAKEFILE")

    # Extract the first meaningful comment (ignoring separators like "# ---")
    HEADER=$(grep -m 1 -E '^# [^#-]' "$MAKEFILE" | sed 's/^# *//')

    # If no meaningful comment is found, use the filename as a fallback
    if [[ -z "$HEADER" ]]; then
        HEADER="Makefile Commands"
    fi

    # Write header with extracted comment + filename
    echo "## $HEADER ($MAKEFILE_NAME)" >> "$OUTPUT_FILE"
    echo "| Target | Description |" >> "$OUTPUT_FILE"
    echo "|---|------------------|" >> "$OUTPUT_FILE"

    awk '
        /^#/ { comment = $0; sub(/^# /, "", comment); next }  # Capture and clean comment
        /^[a-zA-Z0-9_-]+:/ {
            target = $1; sub(/:$/, "", target);  # Extract target (remove trailing ":")
            if (comment != "") {
                printf "| %-13s | %-55s |\n", target, comment;
                comment = "";  # Reset comment
            }
        }
    ' "$MAKEFILE" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE" # Add spacing between Makefile sections
done

echo "Commands have been extracted to $OUTPUT_FILE."
