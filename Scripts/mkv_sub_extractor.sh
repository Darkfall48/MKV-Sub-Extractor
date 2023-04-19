#!/bin/bash

# Prompt the user for the input directory
read -p "Enter the path to the input directory: " input_dir

# Prompt the user for the output directory
read -p "Enter the path to the output directory: " output_dir

# Create the output directory if it doesn't exist
if [ ! -d "$output_dir" ]; then
  mkdir -p "$output_dir"
fi

# Prompt the user for the subtitle format
read -p "Choose the subtitle format:
1. SRT
2. ASS
3. MicroDVD
" subtitle_format

# Handle the different subtitle format options
case $subtitle_format in
  1) output_format=".srt" ;;
  2) output_format=".ass" ;;
  3) output_format=".sub" ;;
  *) echo "Invalid option selected." && exit 1 ;;
esac

# Get all MKV files in the input folder
mkv_files=$(find "$input_dir" -type f -name "*.mkv")

# Loop through all MKV files and extract subtitles
for file in $mkv_files; do
  # Construct the output file name
  output_file="$output_dir/$(basename "$file" .mkv)$output_format"
  
  # Extract the subtitles
  mkvextract tracks "$file" 0:"$output_file"
done
