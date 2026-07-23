#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/configs/project.conf"

echo "================================="
echo " Termux WireProxy Exit IP"
echo "================================="
echo

if ! pgrep -f "wireproxy.*$WIREPROXY_CONFIG" >/dev/null; then
    echo "ERROR: Wireproxy is not running."
    exit 1
fi

IP=$(curl --silent \
    --socks5-hostname "$SOCKS_HOST:$SOCKS_PORT" \
    https://api.ipify.org)

if [ -z "$IP" ]; then
    echo "ERROR: Unable to determine exit IP."
    exit 1
fi

echo "$IP"
