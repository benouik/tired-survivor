version="1.2.3"

IFS='.' read -ra version_parts <<< "$version"
major="${version_parts[0]}"
minor="${version_parts[1]}"
patch="${version_parts[2]}"


# Increment version
((patch++))
if [ "$patch" -gt 9 ]; then
    ((minor++))
    patch=0
    if [ "$minor" -gt 9 ]; then
        ((major++))
        minor=0
    fi
fi

# Construct new version string
new_version="$major.$minor.$patch"

echo "$new_version"
