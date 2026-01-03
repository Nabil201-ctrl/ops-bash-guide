#!/bin/bash
# CHALLENGE 3: The Ghost Variable
# Goal: Run this script. It counts files, but prints "Total files: 0". Why?
# Hint: Pipes (|) create subshells.

TOTAL_FILES=0

echo "Counting files in current directory..."

# We list files and loop through them to count
ls -1 | while read filename; do
    # We increment the counter
    ((TOTAL_FILES++))
    echo "Found: $filename (Count: $TOTAL_FILES)"
done

# BUG: The 'while' loop is in a pipe, so it runs in a Subshell.
# Variables inside the subshell die when the loop ends.
# The global TOTAL_FILES remains 0.

echo "-----------------"
echo "Total files processed: $TOTAL_FILES"
