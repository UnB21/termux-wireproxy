#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/lib/runtime.sh"

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

echo "Profile Path:"
echo "$WG_CONFIG"
echo

echo "SOCKS5:"
echo "$SOCKS_HOST:$SOCKS_PORT"
echo

echo "Runtime Config:"
echo "$WIREPROXY_CONFIG"
echo

echo "Version:"
echo "$VERSION"
