#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

source "$HOME/termux-wireproxy/configs/project.conf"

if [ $# -ne 2 ]; then
    echo "Usage:"
    echo "  twp use <provider> <profile>"
    exit 1
fi

NEW_PROVIDER="$1"
NEW_PROFILE="$2"
if [ "$PROVIDER" = "$NEW_PROVIDER" ] && [ "$PROFILE" = "$NEW_PROFILE" ]; then
    echo "Already active:"
    echo "Provider: $PROVIDER"
    echo "Profile:  $PROFILE"
    echo
    echo "No restart required."
    exit 0
fi
PROFILE_PATH="$PROJECT_DIR/providers/$NEW_PROVIDER/$NEW_PROFILE"

if [ ! -f "$PROFILE_PATH" ]; then
    echo "ERROR: Profile not found:"
    echo "$PROFILE_PATH"
    exit 1
fi

CONFIG_FILE="$PROJECT_DIR/configs/project.conf"

sed -i "s/^PROVIDER=.*/PROVIDER=\"$NEW_PROVIDER\"/" "$CONFIG_FILE"
sed -i "s/^PROFILE=.*/PROFILE=\"$NEW_PROFILE\"/" "$CONFIG_FILE"

echo "Active provider changed:"
echo "Provider: $NEW_PROVIDER"
echo "Profile:  $NEW_PROFILE"

echo
echo "Restarting WireProxy..."

"$PROJECT_DIR/scripts/restart.sh"
