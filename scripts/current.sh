#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/configs/project.conf"

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

echo "Provider:"
echo "$PROVIDER"
echo

echo "Profile:"
echo "$PROFILE"
echo

echo "SOCKS5:"
echo "$SOCKS_HOST:$SOCKS_PORT"
echo

echo "Version:"
echo "$VERSION"
