#! /usr/bin/python3

import os
import subprocess
import platform

# Check if project.godot exists
if not os.path.isfile("project.godot"):
    print("project.godot not found in the current folder. Exiting.")
    input("Press Enter to exit")
    exit()

# Define paths
version_file = 'version.txt'
build_folder = 'build/html5'

# Read version from file or set default value
if os.path.isfile(version_file):
    with open(version_file, 'r') as f:
        version = f.read().strip()
else:
    version = '0.1.0'

# Split version into parts
version_parts = version.split('.')
major = int(version_parts[0])
minor = int(version_parts[1])
patch = int(version_parts[2])

# Increment version
patch += 1
if patch > 9:
    minor += 1
    patch = 0
    if minor > 9:
        major += 1
        minor = 0

# Construct new version string
new_version = f"{major}.{minor}.{patch}"

# Write new version back to file
with open(version_file, 'w') as f:
    f.write(new_version)

version_name = f"v{new_version}"

# Determine the Godot executable path based on the operating system
# if platform.system() == "Windows":
#     godot_exe = "G:/Softwares Portables/Godot_v4.2.2-stable_win64.exe"
# else:
#     godot_exe = "/path/to/godot"  # Replace with the appropriate path for your Linux system

# Export for Web
# subprocess.run([godot_exe, "--headless", "--path", ".", "--export-release", "Web"])

# Export for Windows Desktop (Uncomment if needed)
# subprocess.run([godot_exe, "--headless", "--path", ".", "--export-release", "Windows Desktop"])

# Export for Linux/X11 (Uncomment if needed)
# subprocess.run([godot_exe, "--headless", "--path", ".", "--export-release", "Linux/X11"])

# Push to itch.io
# if platform.system() == "Windows":
    # butler_exe = "G:/Softwares Portables/Butler/butler.exe"
# else:
    # butler_exe = "/path/to/butler"  # Replace with the appropriate path for your Linux system

# subprocess.run([butler_exe, "push", build_folder, "turbob/tired-survivor:html5"])


# Uncomment the following lines if you want to commit and push to Git
subprocess.run(["git", "add", "--all"], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
subprocess.run(["git", "commit", "-m", version_name], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
subprocess.run(["git", "push"], stdout = subprocess.PIPE, stderr = subprocess.PIPE)