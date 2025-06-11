#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Exports all .xopp files from a source directory to a destination directory."
  echo ""
  echo "Usage: $0 <source_directory> <destination_directory>"
  echo ""
  echo "Arguments:"
  echo "  <source_directory>      The directory containing the .xopp files."
  echo "  <destination_directory> The output directory. Must not exist, or must be empty."
  exit 1
}

if [ "$#" -ne 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  usage
fi

SOURCE_DIR="$1"
DEST_DIR="$2"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory '$SOURCE_DIR' not found." >&2
  exit 1
fi

# Validate Destination Directory
if [ -e "$DEST_DIR" ]; then
  # Is path a directory?
  if [ ! -d "$DEST_DIR" ]; then
    echo "Error: Destination '$DEST_DIR' exists but is not a directory." >&2
    exit 1
  fi
  # Is directory empty?
  if [ -n "$(ls -A "$DEST_DIR")" ]; then
    echo "Error: Destination directory '$DEST_DIR' exists but is not empty." >&2
    exit 1
  fi
fi

mkdir -p "$DEST_DIR"
SOURCE_DIR_ABS=$(realpath "$SOURCE_DIR")
DEST_DIR_ABS=$(realpath "$DEST_DIR")

echo "jaqx2pc: Starting export process..."
echo "= Source:      $SOURCE_DIR_ABS"
echo "= Destination: $DEST_DIR_ABS"


find "$SOURCE_DIR_ABS" -maxdepth 1 -type f -name '*.xopp' -print0 | while IFS= read -r -d '' file_path; do
  file_name="${file_path##*/}"
  base_name="${file_name%.*}"

  echo "- Exporting '$file_name'..."
  xournalpp "$file_path" -p "$DEST_DIR_ABS/$base_name.pdf"
done

processed_count=$(find "$SOURCE_DIR_ABS" -maxdepth 1 -type f -name '*.xopp' | wc -l)
if [ "$processed_count" -eq 0 ]; then
    echo "- No .xopp files found in '$SOURCE_DIR_ABS'."
else
    echo "- Done. Processed $processed_count files."
fi