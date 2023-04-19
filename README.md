# MKV Sub Extractor

The MKV Sub Extractor is a code that extracts subtitles from all MKV files in a specified folder to another folder. It supports three different subtitle formats: SRT, ASS, and MicroDVD. The code automatically creates the output folder if it doesn't exist and uses the `mkvextract` command-line tool to extract the subtitles. It can handle any number of MKV files, and the user is prompted to enter the input and output folder paths as well as the desired subtitle format. The code can be executed using PowerShell, Bash, or Python, depending on the user's preference.

## Features

- Supports SRT, ASS, and MicroDVD subtitle formats
- Automatically creates the destination folder if it doesn't exist
- Extracts subtitles from all MKV files in the source folder
- Can handle any number of MKV files.
- Uses the `mkvextract` command-line tool to extract the subtitles.

# Instructions
_Note: The mkvtoolnix package is required for this code to work, and can be installed using your system's package manager._
1. Install MKVToolNix (https://mkvtoolnix.download/)

### PowerShell
2. Open PowerShell and navigate to the directory containing the script.
3. Execute the script by running the command:
```
.\mkv_sub_extractor.ps1
```
### Bash
2. Open a terminal and navigate to the directory containing the script.
3. Execute the script by running the command:
```
.\mkv_sub_extractor.sh
```
### Python
2. Install Python (https://www.python.org/downloads/)
3. Execute the script by running the command:
```
python .\mkv_sub_extractor.py
```

4. When prompted, enter the path to the input folder containing the MKV files.
5. When prompted, enter the path to the output folder where the subtitles will be saved.
6. When prompted, enter the desired subtitle format by entering the corresponding number (1 for SRT, 2 for ASS, 3 for MicroDVD).

_The extracted subtitles will be saved in the output folder in the chosen format._
