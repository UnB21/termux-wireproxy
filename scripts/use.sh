#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/lib/common.sh"

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

LOCAL_CONFIG="$PROJECT_DIR/configs/project.local.conf"

if [ ! -f "$LOCAL_CONFIG" ]; then
    cat > "$LOCAL_CONFIG" <<EOF
#########################################
# Termux WireProxy Local Configuration
#########################################

PROVIDER="$NEW_PROVIDER"
PROFILE="$NEW_PROFILE"
EOF
else
    sed -i "s/^PROVIDER=.*/PROVIDER=\"$NEW_PROVIDER\"/" "$LOCAL_CONFIG"
    sed -i "s/^PROFILE=.*/PROFILE=\"$NEW_PROFILE\"/" "$LOCAL_CONFIG"
fi

echo "Active provider changed:"
echo "Provider: $NEW_PROVIDER"
echo "Profile:  $NEW_PROFILE"

echo
echo "Restarting WireProxy..."

"$PROJECT_DIR/scripts/restart.sh"
