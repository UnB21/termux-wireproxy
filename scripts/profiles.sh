#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/lib/common.sh"

echo "================================="
echo " Available WireGuard Profiles"
echo "================================="
echo

echo "Provider : $PROVIDER"
echo

PROFILE_DIR="$ACTIVE_PROVIDER_DIR"

if [ ! -d "$PROFILE_DIR" ]; then
    echo "[✗] Provider directory missing:"
    echo "$PROFILE_DIR"
    exit 1
fi

COUNT=0

while IFS= read -r PROFILE_FILE; do

    COUNT=$((COUNT + 1))

    PROFILE_NAME="$(basename "$PROFILE_FILE")"

    if [ "$PROFILE_NAME" = "$PROFILE" ]; then
        MARKER="[✓]"
    else
        MARKER="[ ]"
    fi

    ENDPOINT="$(get_profile_endpoint "$PROFILE_FILE")"

    ROUTING="$(get_profile_routing "$PROFILE_FILE")"

    if profile_has_private_key "$PROFILE_FILE"; then
        KEY="Present"
    else
        KEY="Missing"
    fi

    echo "$MARKER $PROFILE_NAME"
    echo "    Endpoint : ${ENDPOINT:-Unknown}"
    echo "    Routing  : $ROUTING"
    echo "    Key      : $KEY"
    echo

done < <(find "$PROFILE_DIR" -maxdepth 1 -name "*.conf" | sort)

if [ "$COUNT" -eq 0 ]; then
    echo "[!] No WireGuard profiles found."
    exit 0
fi

echo "---------------------------------"
echo "Total profiles : $COUNT"
