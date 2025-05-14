#!/bin/bash

# Variables
USERNAME="kong"
SECRET="secret"
DATE=$(date -u +"%a, %d %b %Y %H:%M:%S GMT")
METHOD="GET"
REQUEST_URI="/test"
ALGORITHM="hmac-sha256"

# Correct way to construct the signing string
SIGNING_STRING=$(printf "date: %s\n%s %s HTTP/1.1" "$DATE" "$METHOD" "$REQUEST_URI")

# Debug: Print signing string in bytes
echo "Signing String:"
printf "%s" "$SIGNING_STRING" | od -c

# Generate the HMAC signature correctly
SIGNATURE=$(printf "%s" "$SIGNING_STRING" | openssl dgst -sha256 -hmac "$SECRET" -binary | base64)

# Debug: Print the generated signature
echo "Generated Signature: $SIGNATURE"

# Send the request with HMAC authentication
curl -v -X $METHOD http://localhost:8000$REQUEST_URI \
  -H "Authorization: hmac username=\"$USERNAME\", algorithm=\"$ALGORITHM\", headers=\"date request-line\", signature=\"$SIGNATURE\"" \
  -H "Date: $DATE"