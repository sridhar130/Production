#!/usr/bin/bash
# Script to insert a test field in the output

for file in *.art cnf*.fcl cnf*.tar; do
    if [ -e "$file" ]; then
        # Extract the first four fields
        prefix=$(echo "$file" | cut -d'.' -f1-4)
        # Extract the the fields after the first four fields and prepend test string $1
        suffix="$1.$(echo "$file" | cut -d'.' -f5-)"
        new_file="${prefix}${suffix}"
        mv "$file" "$new_file"
    fi
done
