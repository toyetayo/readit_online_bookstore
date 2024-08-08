#!/bin/bash
 
# Define the output file
OUTPUT_FILE="project_files.txt"
 
# Create or empty the output file
> "$OUTPUT_FILE"
 
# Generate the tree structure, excluding unnecessary directories

 
# Define an array of important directories and files to include
FILES_TO_INCLUDE=(
  "app"
  "config"
  "db/migrate"
  "db/seeds.rb"
  "Gemfile"
  "config/database.yml"
)
 
# Define an array of image file extensions to exclude
IMAGE_EXTENSIONS=("jpg" "jpeg" "png" "gif" "bmp" "tiff" "svg")
 
# Function to check if a file is an image
is_image_file() {
  local file="$1"
  for ext in "${IMAGE_EXTENSIONS[@]}"; do
    if [[ "$file" == *.$ext ]]; then
      return 0
    fi
  done
  return 1
}
 
# Loop through each file/directory and append its contents to the output file
for ITEM in "${FILES_TO_INCLUDE[@]}"; do
  if [ -d "$ITEM" ]; then
    # If it's a directory, find all files in it, excluding the images folder in app directory
    if [ "$ITEM" == "app" ]; then
      find "$ITEM" -type f -not -path "app/images/*" | while read -r FILE; do
        if ! is_image_file "$FILE"; then
          echo "### $FILE ###" >> "$OUTPUT_FILE"
          cat "$FILE" >> "$OUTPUT_FILE"
          echo -e "\n\n" >> "$OUTPUT_FILE"
        fi
      done
    else
      find "$ITEM" -type f | while read -r FILE; do
        if ! is_image_file "$FILE"; then
          echo "### $FILE ###" >> "$OUTPUT_FILE"
          cat "$FILE" >> "$OUTPUT_FILE"
          echo -e "\n\n" >> "$OUTPUT_FILE"
        fi
      done
    fi
  elif [ -f "$ITEM" ]; then
    # If it's a file, append its contents if it's not an image
    if ! is_image_file "$ITEM"; then
      echo "### $ITEM ###" >> "$OUTPUT_FILE"
      cat "$ITEM" >> "$OUTPUT_FILE"
      echo -e "\n\n" >> "$OUTPUT_FILE"
    fi
  fi
done
 
echo "Project files have been collected into $OUTPUT_FILE"