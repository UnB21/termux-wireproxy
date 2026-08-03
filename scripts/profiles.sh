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

PROFILE_DIR="$PROJECT_DIR/providers/$PROVIDER"

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

    ENDPOINT=$(grep -m1 "^Endpoint" "$PROFILE_FILE" | cut -d'=' -f2- | xargs || true)

    ALLOWED_IPS=$(grep -m1 "^AllowedIPs" "$PROFILE_FILE" | cut -d'=' -f2- | xargs || true)

    if echo "$ALLOWED_IPS" | grep -q "0.0.0.0/0" &&
       echo "$ALLOWED_IPS" | grep -q "::/0"; then
        ROUTING="Dual Stack"
    elif echo "$ALLOWED_IPS" | grep -q "0.0.0.0/0"; then
        ROUTING="IPv4"
    else
        ROUTING="Partial"
    fi

    if grep -q "^PrivateKey" "$PROFILE_FILE"; then
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
