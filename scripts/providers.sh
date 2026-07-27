#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/lib/runtime.sh"
source "$PROJECT_DIR/lib/providers.sh"

echo "================================="
echo " Available Providers"
echo "================================="

FOUND_PROVIDER=false

for provider in $(list_providers); do

    FOUND_PROVIDER=true

    echo
    echo "Provider: $provider"
    echo

    FOUND_PROFILE=false

    for profile in $(list_profiles "$provider"); do

        FOUND_PROFILE=true

        if [ "$provider" = "$PROVIDER" ] && [ "$profile" = "$PROFILE" ]; then
            echo "  ★ $profile"
        else
            echo "    $profile"
        fi

    done

    if [ "$FOUND_PROFILE" = false ]; then
        echo "    (no profiles)"
    fi

    if [ -d "$(provider_path "$provider")/examples" ]; then
        echo "    examples/"
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
