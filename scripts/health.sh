#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/configs/project.conf"
source "$PROJECT_DIR/lib/common.sh"

FAIL=0

echo "================================="
echo " Termux WireProxy Health Check"
echo "================================="


echo
echo "=== Process Check ==="

if is_running; then
    echo "OK: wireproxy running"
else
    echo "FAIL: wireproxy not running"
    FAIL=1
fi


echo
echo "=== SOCKS5 Check ==="

if curl \
    --silent \
    --max-time 10 \
    --socks5-hostname "$SOCKS_HOST:$SOCKS_PORT" \
    https://api.ipify.org >/dev/null
then
    echo "OK: SOCKS5 proxy responding"
else
    echo "FAIL: SOCKS5 proxy unavailable"
    FAIL=1
fi


echo
echo "=== VPN Exit Check ==="

if is_running; then

    EXIT_IP=$(curl \
    --silent \
    --max-time 10 \
    --socks5-hostname "$SOCKS_HOST:$SOCKS_PORT" \
    https://api.ipify.org)

    if [ -n "$EXIT_IP" ]; then
        echo "OK: Exit IP $EXIT_IP"
    else
        echo "FAIL: No exit IP"
        FAIL=1
    fi

fi


echo

if [ "$FAIL" -eq 0 ]; then
    echo "STATUS: HEALTHY"
    exit 0
else
    echo "STATUS: FAILED"
    exit 1
fi
