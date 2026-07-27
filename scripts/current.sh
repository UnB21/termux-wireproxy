#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/configs/project.conf"
source "$PROJECT_DIR/lib/state.sh"

VERSION_FILE="$PROJECT_DIR/VERSION"

if [ -f "$VERSION_FILE" ]; then
    VERSION=$(cat "$VERSION_FILE")
else
    VERSION="unknown"
fi

echo "================================="
echo " Active Configuration"
echo "================================="
echo

if load_active_profile; then

    echo "Provider:"
    echo "$PROVIDER"
    echo

    echo "Profile:"
    echo "$PROFILE"
    echo

    echo "Profile Path:"
    echo "$WG_CONFIG"
    echo

else

    echo "No active profile selected."
    echo

    echo "Using configured defaults:"
    echo

    echo "Provider:"
    echo "$PROVIDER"
    echo

    echo "Profile:"
    echo "$PROFILE"
    echo

fi

echo "SOCKS5:"
echo "$SOCKS_HOST:$SOCKS_PORT"
echo

echo "Runtime Config:"
echo "$WIREPROXY_CONFIG"
echo

echo "Version:"
echo "$VERSION"
