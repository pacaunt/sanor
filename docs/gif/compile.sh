#!/bin/bash

# Loop through every file ending in .typ
for file in *.typ; do
    # Get the filename without the extension (e.g., "main" instead of "main.c")
    filename="${file%.*}"
    
    echo "Compiling $file..."
    # mkdir "$filename"
    typst c "$file" --format=png --root ../.. "$filename/$filename{0p}.png"
    ffmpeg -framerate 1.5 -i $filename/$filename%d.png $filename.gif

done

echo "Done!"
