#!/bin/sh
echo -ne '\033c\033]0;Tired Survivor\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/tired-farmer.x86_64" "$@"
