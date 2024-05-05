#!/bin/bash

# ASCII Art for "imageo-ng"
echo -e "\e[1;36m"
cat << "EOF"


██╗███╗   ███╗ █████╗  ██████╗ ███████╗ ██████╗       ███╗   ██╗ ██████╗ 
██║████╗ ████║██╔══██╗██╔════╝ ██╔════╝██╔═══██╗      ████╗  ██║██╔════╝ 
██║██╔████╔██║███████║██║  ███╗█████╗  ██║   ██║█████╗██╔██╗ ██║██║  ███╗
██║██║╚██╔╝██║██╔══██║██║   ██║██╔══╝  ██║   ██║╚════╝██║╚██╗██║██║   ██║
██║██║ ╚═╝ ██║██║  ██║╚██████╔╝███████╗╚██████╔╝      ██║ ╚████║╚██████╔╝
╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝ ╚═════╝       ╚═╝  ╚═══╝ ╚═════╝ 
                                                                         
██╗  ██╗███████╗██╗   ██╗       ██████╗████████╗███████╗                 
██║ ██╔╝██╔════╝██║   ██║      ██╔════╝╚══██╔══╝██╔════╝                 
█████╔╝ ███████╗██║   ██║█████╗██║        ██║   █████╗                   
██╔═██╗ ╚════██║██║   ██║╚════╝██║        ██║   ██╔══╝                   
██║  ██╗███████║╚██████╔╝      ╚██████╗   ██║   ██║                      
╚═╝  ╚═╝╚══════╝ ╚═════╝        ╚═════╝   ╚═╝   ╚═╝                      

By Mr.Faisal
                                                          
EOF
echo -e "\e[0m"

sleep 1


# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo -e "\e[1;31mUsage: $0 <image path>\e[0m"
    exit 1
fi

# Check if the provided argument is a valid file
if [ ! -f "$1" ]; then
    echo -e "\e[1;31mError: '$1' is not a valid file.\e[0m"
    exit 1
fi

# Extract the filename from the provided path
filename=$(basename "$1")
# Extract the directory path from the provided path
dir=$(dirname "$1")
# Extract the name of the file without extension
filename_no_ext="${filename%.*}"

# Create a folder with the same name as the image
mkdir -p "$dir/${filename_no_ext}_Results"

# Move the image to the created folder
mv "$1" "$dir/${filename_no_ext}_Results/"

cd "$dir/${filename_no_ext}_Results/"

echo -e "\e[1;34mImage '$filename' moved to '$dir/$filename_no_ext/'\e[0m"

# Run 'strings' command on the image and print the result
echo -e "\e[1;33mStrings extracted from '$filename' and saved at 'strings_$filename_no_ext.txt':\e[0m"
strings "$filename" > "strings_$filename_no_ext.txt"

echo -e "\e[1;33mFile type detected:\e[0m"
file "$filename"

echo -e "\e[1;33mExiftool extracted from '$filename':\e[0m"
exiftool "$filename"

echo -e "\e[1;33mBinwalk extracted from '$filename':\e[0m"
binwalk -e "$filename"

echo -e "\e[1;33mPNG check extracted from '$filename':\e[0m"
pngcheck "$filename"

echo -e "\e[1;33mPNG split extracted from '$filename':\e[0m"
pngsplit "$filename"

echo -e "\e[1;33mEditing Magic Bytes of '$filename' to create GIF, PNG, and JPG:\e[0m"
# Define new magic bytes for PNG format
new_magic_bytes_png="\x89\x50\x4E\x47\x0D\x0A\x1A\x0A"
# Define new magic bytes for JPG format
new_magic_bytes_jpg="\xFF\xD8\xFF\xE0"




cp $filename new_image.png
echo -n -e '\x89\x50\x4E\x47\x0D\x0A\x1A\x0A' | dd of=new_image.png bs=1 seek=0 count=8 conv=notrunc


cp $filename new_image.jpg
echo -n -e '\xFF\xD8\xFF\xE0' | dd of=new_image.jpg bs=1 seek=0 count=4 conv=notrunc

echo -e "\e[1;32mNew edited files saved as PNG and JPG\e[0m"

echo -e "\e[1;33mForemost extracted from '$filename':\e[0m"
foremost -v "$filename" -T "'$filename'_output"

echo -e "\e[1;33mStegseek extracted from '$filename':\e[0m"
stegseek -sf "$filename"
stegseek --crack "$filename" /usr/share/wordlists/rockyou.txt

echo -e "\e[1;33mSteghide for '$filename':\e[0m"
steghide --extract -sf "$filename"

echo -e "\e[1;32mDone\e[0m"
