import os

# Get the input and output directories from the user
input_dir = input("Enter the path to the input directory: ")
output_dir = input("Enter the path to the output directory: ")

# Create the output directory if it doesn't exist
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Prompt the user for the subtitle format
subtitle_format = input("Choose the subtitle format:\n1. SRT\n2. ASS\n3. MicroDVD\n")

# Handle the different subtitle format options
if subtitle_format == "1":
    output_format = ".srt"
elif subtitle_format == "2":
    output_format = ".ass"
elif subtitle_format == "3":
    output_format = ".sub"
else:
    raise ValueError("Invalid option selected.")

# Get all MKV files in the input folder
mkv_files = [f for f in os.listdir(input_dir) if f.endswith(".mkv")]

# Loop through all MKV files and extract subtitles
for file in mkv_files:
    # Construct the output file name
    output_file = os.path.join(output_dir, file[:-4] + output_format)

    # Extract the subtitles
    os.system(f'mkvextract tracks "{os.path.join(input_dir, file)}" 0:"{output_file}"')
