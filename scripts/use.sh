#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/lib/runtime.sh"
source "$PROJECT_DIR/lib/providers.sh"

if [ $# -ne 2 ]; then
    echo "Usage:"
    echo "  twp use <provider> <profile>"
    exit 1
fi

NEW_PROVIDER="$1"
NEW_PROFILE="$2"

if ! profile_exists "$NEW_PROVIDER" "$NEW_PROFILE"; then
    echo "ERROR: Profile not found:"
    echo "$(get_profile_path "$NEW_PROVIDER" "$NEW_PROFILE")"
    exit 1
fi

if has_active_profile; then

    load_active_profile

    if [ "$PROVIDER" = "$NEW_PROVIDER" ] && [ "$PROFILE" = "$NEW_PROFILE" ]; then
        echo "Already active:"
        echo "Provider: $PROVIDER"
        echo "Profile:  $PROFILE"
        exit 0
    fi

fi

save_active_profile "$NEW_PROVIDER" "$NEW_PROFILE"

echo "Active provider changed:"
echo "Provider: $NEW_PROVIDER"
echo "Profile:  $NEW_PROFILE"

echo
echo "State updated:"
echo "$STATE_DIR/active.conf"

echo
echo "Restart required to apply changes:"
echo "  twp restart"
