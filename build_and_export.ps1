# Check if project.godot exists
if (-not (Test-Path "project.godot")) {
    Write-Host "project.godot not found in the current folder. Exiting."
    Read-Host -Prompt "Press Enter to exit"
    exit
}

# Define paths
$versionFile = '.\version.txt'
# $buildFolder = '.\build\html5'



# Read version from file or set default value
if (Test-Path $versionFile) {
    $version = Get-Content $versionFile
} else {
    $version = '0.1.0'
}

# Split version into parts
$versionParts = $version -split '\.'
$major = [int]$versionParts[0]
$minor = [int]$versionParts[1]
$patch = [int]$versionParts[2]

# Increment version
$patch++
if ($patch -gt 9) {
    $minor++
    $patch = 0
    if ($minor -gt 9) {
        $major++
        $minor = 0
    }
}

# Construct new version string
$newVersion = "$major.$minor.$patch"

# Write new version back to file
$newVersion | Set-Content $versionFile

$versionName = "v$newVersion"

# Invoke-Expression '& "G:\Softwares Portables\Godot_v4.2.2-stable_win64.exe" --headless --path .\ --export-release "Web"'
# Invoke-Expression '& "G:\Softwares Portables\Godot_v4.2.2-stable_win64.exe" --headless --path .\ --export-release "Windows Desktop"'
# Invoke-Expression '& "G:\Softwares Portables\Godot_v4.2.2-stable_win64.exe" --headless --path .\ --export-release "Linux/X11"'

# Invoke-Expression '& "G:\Softwares Portables\Butler\butler.exe" push "$buildFolder" "turbob/tired-farmer:html5"'

Invoke-Expression 'git add --all'
Invoke-Expression 'git commit -m "$versionName"'
Invoke-Expression 'git push'
