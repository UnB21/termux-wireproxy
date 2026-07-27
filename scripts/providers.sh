#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/configs/project.conf"
source "$PROJECT_DIR/lib/common.sh"
source "$PROJECT_DIR/lib/state.sh"

# Load active runtime profile if available
load_active_profile >/dev/null 2>&1 || true

echo "================================="
echo " Available Providers"
echo "================================="

FOUND_PROVIDER=false

for provider_dir in "$PROJECT_DIR/providers/"*; do

    [ -d "$provider_dir" ] || continue

    FOUND_PROVIDER=true

    provider=$(basename "$provider_dir")

    echo
    echo "Provider: $provider"
    echo

    FOUND_PROFILE=false

    for profile in "$provider_dir"/*.conf; do

        [ -f "$profile" ] || continue

        FOUND_PROFILE=true

        profile_name=$(basename "$profile")

        if [ "$provider" = "$PROVIDER" ] && [ "$profile_name" = "$PROFILE" ]; then
            echo "  ★ $profile_name"
        else
            echo "    $profile_name"
        fi

    done

    if [ -d "$provider_dir/examples" ]; then
        echo "    examples/"
    fi

    if [ "$FOUND_PROFILE" = false ]; then
        echo "    (no profiles)"
    fi

done

if [ "$FOUND_PROVIDER" = false ]; then
    echo
    echo "No providers found."
fi

echo
echo "================================="
echo " Active Profile"
echo "================================="
echo
echo "Provider : $PROVIDER"
echo "Profile  : $PROFILE"
