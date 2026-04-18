import json
import os
import subprocess
import sys

# Prompt the user for the input and output folders
input_dir = input("Enter the source folder path ").strip()
output_dir = input("Enter the destination folder path ").strip()

# Create the output directory if it doesn't exist
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Get all MKV files in the input folder
mkv_files = [f for f in os.listdir(input_dir) if f.lower().endswith(".mkv")]

# Loop through all MKV files and extract subtitle tracks (native format per track)
for file in mkv_files:
    src = os.path.join(input_dir, file)
    proc = subprocess.run(["mkvmerge", "-J", src], capture_output=True, text=True)
    if proc.returncode != 0 or not proc.stdout.strip():
        continue
    try:
        ident = json.loads(proc.stdout)
    except json.JSONDecodeError:
        continue

    base = os.path.splitext(file)[0]
    for track in ident.get("tracks") or []:
        if track.get("type") != "subtitles":
            continue
        tid = track["id"]
        c = str(track.get("codec") or "")
        # File extension from codec (.srt, .ass, .sup, …); empty = let mkvextract choose
        ext = ""
        if any(x in c for x in ("SubRip", "UTF-8", "UTF8", "S_TEXT/UTF8")):
            ext = ".srt"
        elif any(x in c for x in ("SubStationAlpha", "ASS", "SSA")):
            ext = ".ass"
        elif "PGS" in c or "HDMV" in c:
            ext = ".sup"
        elif "VobSub" in c:
            ext = ".sub"
        elif "WebVTT" in c:
            ext = ".vtt"

        out_base = os.path.join(output_dir, f"{base}.track{tid}{ext}")
        p = os.path.normpath(out_base)
        # Windows: use TID+path when the path has ":" (drive or UNC), not TID:path
        if sys.platform == "win32" and ((len(p) >= 2 and p[1] == ":") or p.startswith("\\\\")):
            spec = f"{tid}+{p}"
        else:
            spec = f"{tid}:{p}"

        # Extract the subtitles
        subprocess.run(["mkvextract", "tracks", src, spec], check=False)
