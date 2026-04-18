# Prompt the user for the input and output folders
$input_dir = Read-Host "Enter the source folder path"
$output_dir = Read-Host "Enter the destination folder path"

# Create the output directory if it doesn't exist
if (-not (Test-Path $output_dir)) {
    New-Item -ItemType Directory -Path $output_dir | Out-Null
}

# Get all MKV files in the input folder
$mkv_files = Get-ChildItem -Path $input_dir -Filter *.mkv

# Loop through all MKV files and extract subtitle tracks (native format per track)
foreach ($file in $mkv_files) {
    $json = & mkvmerge.exe -J $file.FullName 2>$null
    if (-not $json) { continue }
    $ident = $json | ConvertFrom-Json

    foreach ($track in ($ident.tracks | Where-Object { $_.type -eq "subtitles" })) {
        # File extension from codec (.srt, .ass, .sup, …); empty = let mkvextract choose
        $c = [string]$track.codec
        $ext = ""
        if ($c -match "SubRip|UTF-8|UTF8|S_TEXT/UTF8") { $ext = ".srt" }
        elseif ($c -match "SubStationAlpha|ASS|SSA") { $ext = ".ass" }
        elseif ($c -match "PGS|HDMV") { $ext = ".sup" }
        elseif ($c -match "VobSub") { $ext = ".sub" }
        elseif ($c -match "WebVTT") { $ext = ".vtt" }

        $out_base = Join-Path $output_dir ($file.BaseName + ".track" + $track.id + $ext)
        # Windows: use TID+path when the path has ":" (drive or UNC), not TID:path
        $spec = if ($out_base -match "^[A-Za-z]:|^\\\\") { "$($track.id)+$out_base" } else { "$($track.id):$out_base" }

        # Extract the subtitles
        & mkvextract.exe tracks $file.FullName $spec
    }
}
