#!/data/data/com.termux/files/usr/bin/bash

source "$HOME/termux-wireproxy/configs/project.conf"

echo "================================="
echo " Available Providers"
echo "================================="

for provider in "$PROJECT_DIR/providers/"*; do

    [ -d "$provider" ] || continue

    name=$(basename "$provider")

    echo
    echo "[$name]"

        configs=$(find "$provider" -maxdepth 1 -name "*.conf" -type f)

    if [ -n "$configs" ]; then
        echo "$configs" | while read -r file; do
            basename "$file"
        done
    else
        echo "(no profiles)"
    fi

done
