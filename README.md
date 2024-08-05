# directory-filelist.sh

This bash script prompts the user to enter a system path, verifies the path's existence, generates a sorted list of files and folders by size within the specified path, and then opens the list in a text editor.

## Features

- Prompts the user to input a system path using a graphical interface.
- Checks if the entered path exists.
- Generates a sorted list of files and folders (including hidden ones) by size.
- Saves the list to a text file in the `/tmp` directory.
- Opens the generated text file using Mousepad.

## Prerequisites

Make sure you have the following installed on your system:

- `zenity`: For graphical user interface prompts.
- `du`: Disk usage utility.
- `awk`: Text processing utility.
- `mousepad`: Simple text editor.

You can install these utilities using the following commands:

```bash
# Install zenity
sudo apt-get install zenity

# Install du (usually pre-installed on most systems)
sudo apt-get install coreutils

# Install awk (usually pre-installed on most systems)
sudo apt-get install gawk

# Install mousepad
sudo apt-get install mousepad
```

## Usage

1. Save the script to a file, for example, `generate_file_list.sh`.

2. Make the script executable:

```bash
chmod +x generate_file_list.sh
```

3. Run the script:

```bash
./generate_file_list.sh
```

## Script Details

```bash
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

# Open the text file using Mousepad
mousepad "$output_file" &

exit 0
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Acknowledgments

- Inspired by various bash scripting tutorials and resources.
- Special thanks to the developers of `zenity`, `du`, `awk`, and `mousepad` for their indispensable tools.

Feel free to customize this README to better suit your project and its requirements.
