#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Exports all .xopp files from a source directory to a destination directory."
  echo ""
  echo "Usage: $0 [-v|-vv] <source_directory> <destination_directory>"
  echo ""
  echo "Options:"
  echo "  -v        Verbose: Print a message for each file being processed."
  echo "  -vv       Very Verbose: Also show the output from xournalpp itself."
  exit 1
  echo "Arguments:"
  echo "  <source_directory>      The directory containing the .xopp files."
  echo "  <destination_directory> The output directory. Must not exist, or must be empty."
  exit 1
}

verbosity=0
while [[ "${1:-}" =~ ^- ]]; do
  case "$1" in
    -v) verbosity=1; shift ;;
    -vv) verbosity=2; shift ;;
    -h | --help) usage ;;
    *) echo "Error: Unknown option '$1'" >&2; usage ;;
  esac
donee

if [ "$#" -ne 2 ]; then
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

  if [ "$verbosity" -ge 1 ]; then
    echo "-> Exporting '$file_name'..."
  fi
  
  if [ "$verbosity" -ge 2 ]; then
    # -vv
    xournalpp "$file_path" -p "$DEST_DIR_ABS/$base_name.pdf" < /dev/null || {
      echo "Error: xournalpp failed to export '$file_name'." >&2
      exit 1
    }
  else
    # Default or -v
    xournalpp "$file_path" -p "$DEST_DIR_ABS/$base_name.pdf" < /dev/null 2>/dev/null || {
      echo "Error: xournalpp failed to export '$file_name'." >&2
      exit 1
    }
  fi
done

processed_count=$(find "$SOURCE_DIR_ABS" -maxdepth 1 -type f -name '*.xopp' | wc -l)
if [ "$processed_count" -eq 0 ]; then
    echo "- No .xopp files found in '$SOURCE_DIR_ABS'."
else
    echo "- Done. Processed $processed_count files."
fi