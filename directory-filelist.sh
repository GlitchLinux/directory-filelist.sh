#!/bin/bash

# Prompt the user for a system path
user_path=$(zenity --entry --title="Enter Path" --text="Enter the system path:" --width=400)

# Check if the user canceled the input
if [ -z "$user_path" ]; then
    zenity --error --text="Operation canceled by the user."
    exit 1
fi

# Check if the entered path exists
if [ ! -d "$user_path" ]; then
    zenity --error --text="The specified path does not exist."
    exit 1
fi

# Set the output file path
output_file="/tmp/file_list_of-$(basename "$user_path").txt"

# Scan the location and create a sorted list of files/folders by size
cd "$user_path" || exit 1

# Add a header line to the file
echo "Below are the contents of: $user_path" > "$output_file"
echo >> "$output_file"  # Add a blank row

# Append the sorted list of files/folders by size, including hidden ones, with full paths
find . -type f -exec du -h {} + | sort -rh | awk -v path="$user_path" '{printf "%-8s%-s\n", $1, path $2}' >> "$output_file"
find . -maxdepth 1 -type d -name ".*" -exec du -h {} + | sort -rh | awk -v path="$user_path" '{printf "%-8s%-s\n", $1, path $2}' >> "$output_file"

# Open the text file using mousepad
mousepad "$output_file" &

exit 0
