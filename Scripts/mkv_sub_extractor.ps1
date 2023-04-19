# Prompt the user for the input and output folders
$input_dir = Read-Host "Enter the source folder path"
$output_dir = Read-Host "Enter the destination folder path"

# Create the output directory if it doesn't exist
if (-not (Test-Path $output_dir)) {
    New-Item -ItemType Directory -Path $output_dir | Out-Null
}

# Prompt the user for the subtitle format
$subtitle_format = Read-Host "Choose the subtitle format:`n1. SRT`n2. ASS`n3. MicroDVD"

# Handle the different subtitle format options
switch ($subtitle_format) {
    1 { $output_format = ".srt" }
    2 { $output_format = ".ass" }
    3 { $output_format = ".sub" }
    default { Write-Error "Invalid option selected." }
}

# Get all MKV files in the input folder
$mkv_files = Get-ChildItem -Path $input_dir -Filter *.mkv

# Loop through all MKV files and extract subtitles
foreach ($file in $mkv_files) {
    # Construct the output file name
    $output_file = Join-Path -Path $output_dir -ChildPath ($file.BaseName + $output_format)
    
    # Extract the subtitles
    & mkvextract.exe tracks $file.FullName 0:$output_file
}
