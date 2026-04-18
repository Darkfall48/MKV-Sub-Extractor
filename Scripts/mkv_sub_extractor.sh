#!/usr/bin/env bash

# Prompt the user for the input and output folders
read -r -p "Enter the source folder path " input_dir
read -r -p "Enter the destination folder path " output_dir

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# jq is required to parse mkvmerge JSON; MKVToolNix must be on PATH
command -v jq >/dev/null 2>&1 && command -v mkvmerge >/dev/null 2>&1 && command -v mkvextract >/dev/null 2>&1 || {
  echo "Install jq and MKVToolNix (mkvmerge, mkvextract), or use the Python/PowerShell script." >&2
  exit 1
}

# Get all MKV files in the input folder
shopt -s nullglob
for file in "$input_dir"/*.mkv; do
  [[ -f "$file" ]] || continue
  base=$(basename "$file" .mkv)
  json=$(mkvmerge -J "$file" 2>/dev/null) || continue
  [[ -n "$json" ]] || continue

  # Loop through subtitle tracks only (native format per track)
  while IFS= read -r track_json; do
    [[ -z "$track_json" ]] && continue
    tid=$(jq -r '.id' <<<"$track_json")
    c=$(jq -r '.codec // ""' <<<"$track_json")
    # File extension from codec (.srt, .ass, .sup, …); empty = let mkvextract choose
    ext=""
    case "$c" in
      *SubRip*|*UTF-8*|*UTF8*|*S_TEXT/UTF8*) ext=".srt" ;;
      *SubStationAlpha*|*ASS*|*SSA*) ext=".ass" ;;
      *PGS*|*HDMV*) ext=".sup" ;;
      *VobSub*) ext=".sub" ;;
      *WebVTT*) ext=".vtt" ;;
    esac
    out_base="${output_dir}/${base}.track${tid}${ext}"
    # Windows: use TID+path when the path has ":" (drive or UNC), not TID:path
    if [[ "$out_base" =~ ^[A-Za-z]: ]] || [[ "$out_base" =~ ^\\\\ ]]; then
      spec="${tid}+${out_base}"
    else
      spec="${tid}:${out_base}"
    fi
    # Extract the subtitles
    mkvextract tracks "$file" "$spec"
  done < <(echo "$json" | jq -c '(.tracks // [])[] | select(.type == "subtitles")')
done
