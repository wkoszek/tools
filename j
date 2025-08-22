#!/bin/bash

# Get current date in YYYYMMDD format
DATE=$(date +%Y%m%d)
FILENAME="${DATE}-journal.md"

# Get computer name
COMPUTER=$(hostname -s)

echo here
# Get location based on IP using ip-api.com
LOCATION_DATA=$(curl --max-time 2 -s "http://ip-api.com/json")
echo here
CITY=$(echo "$LOCATION_DATA" | grep -o '"city":"[^"]*' | cut -d'"' -f4)
REGION=$(echo "$LOCATION_DATA" | grep -o '"regionName":"[^"]*' | cut -d'"' -f4)
COUNTRY=$(echo "$LOCATION_DATA" | grep -o '"country":"[^"]*' | cut -d'"' -f4)

echo here
# Format location
if [ -n "$CITY" ] && [ -n "$REGION" ] && [ -n "$COUNTRY" ]; then
    LOCATION="$CITY, $REGION, $COUNTRY"
elif [ -n "$CITY" ] && [ -n "$COUNTRY" ]; then
    LOCATION="$CITY, $COUNTRY"
else
    LOCATION="Unknown"
fi

echo here
# Create journal file with YAML frontmatter
cat > "$FILENAME" << EOF
---
date: $(date +%Y-%m-%d)
time: $(date +%H:%M:%S)
location: $LOCATION
computer: $COMPUTER
---

# Journal Entry for $(date '+%B %d, %Y')

EOF

echo "Created journal file: $FILENAME"
echo "Location: $LOCATION"
echo "Computer: $COMPUTER"

# Open the file in the default editor if EDITOR is set
if [ -n "$EDITOR" ]; then
    $EDITOR "$FILENAME"
fi
