#!/bin/bash
# LINK_URL="https://crackmes.one/crackme/66c724b9b899a3b9dd02ad98"
LINK_URL="$1"
URL="${LINK_URL/crackme\//static\/crackme\/}"
echo "${URL}"

TMP_DIR="/tmp"

CRACKME_DIR="/home/sarath/Projects/crackmes/"
FOLDER_NAME="$(basename "$URL")"
DEST_DIR="$CRACKME_DIR$FOLDER_NAME"

PASSWORD="crackmes.one"

# Download the zip file
ZIP_FILE="$TMP_DIR/$(basename "$URL").zip"
wget "$URL.zip" -O "$ZIP_FILE" 

# # Extract the downloaded zip file with the password to /tmp
unzip -P "$PASSWORD" "$ZIP_FILE" -d "$TMP_DIR/$FOLDER_NAME"

# # Find the extracted folder (assuming one level deep extraction)
EXTRACTED_DIR=$(find "$TMP_DIR/$FOLDER_NAME" -mindepth 1 -maxdepth 1 )

# # Extract the internal contents using 7z to the destination directory
7z x "$EXTRACTED_DIR" -o"$DEST_DIR"

# # Clean up
rm -rf "$ZIP_FILE" "$TMP_DIR/$FOLDER_NAME"

echo "Extraction complete. Files are in $DEST_DIR"
