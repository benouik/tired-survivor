#!/bin/bash


# Check if project.godot exists
if [ ! -f "project.godot" ]; then
    echo "project.godot not found in the current folder. Exiting."
    read -p "Press Enter to exit"
    exit 1
fi

# Define paths
version_file='version.txt'
build_folder='build/html5'

# Read version from file or set default value
if [ -f "$version_file" ]; then
    version=$(cat "$version_file")
else
    version='0.1.0'
fi

# Split version into parts
major=$(echo "$version" | cut -d'.' -f 1)
minor=$(echo "$version" | cut -d'.' -f 2)
subminor=$(echo "$version" | cut -d'.' -f 3)


echo "$major.$minor.$subminor"

# Increment version
subminor=$((subminor+1))
if [ $subminor -gt 9 ]; then
    minor=$((minor+1))
    subminor=0
    if [ $minor -gt 9 ]; then
        major=$((major+1))
        minor=0
    fi
fi

# Construct new version string
new_version="$major.$minor.$subminor"

# Write new version back to file
echo "$new_version" > "$version_file"

version_name="v$new_version"

# godot_path="/path/to/godot" # Replace with the actual path to your Godot executable

# "$godot_path" --headless --path ./ --export-release "Web"
# "$godot_path" --headless --path ./ --export-release "Windows Desktop"
# "$godot_path" --headless --path ./ --export-release "Linux/X11"

# butler_path="/path/to/butler" # Replace with the actual path to your Butler executable
# "$butler_path" push "$build_folder" "turbob/tired-survivor:html5"

git add --all
git commit -m "$version_name"
git push

# Invoke-Expression 'git add --all'
# Invoke-Expression 'git commit -m "$versionName"'
# Invoke-Expression 'git push'
