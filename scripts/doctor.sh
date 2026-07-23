#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/configs/project.conf"

echo "================================="
echo " Termux WireProxy Doctor"
echo "================================="
echo

FAIL=0

check_ok() {
    echo "[✓] $1"
}

check_fail() {
    echo "[✗] $1"
    FAIL=1
}

echo "=== Binary Check ==="

if command -v "$WIREPROXY_BIN" >/dev/null 2>&1; then
    check_ok "wireproxy installed"
else
    check_fail "wireproxy missing"
fi

echo
echo "=== Configuration Check ==="

if [ -f "$WIREPROXY_CONFIG" ]; then
    check_ok "wireproxy config found"
else
    check_fail "wireproxy config missing"
fi

if [ -f "$WG_CONFIG" ]; then
    check_ok "provider profile found"
else
    check_fail "provider profile missing"
fi

echo
echo "=== Process Check ==="

if pgrep -f "wireproxy.*$WIREPROXY_CONFIG" >/dev/null; then
    check_ok "wireproxy running"
else
    check_fail "wireproxy not running"
fi

echo
echo "=== SOCKS Check ==="

if curl --silent \
    --socks5-hostname "$SOCKS_HOST:$SOCKS_PORT" \
    https://api.ipify.org >/dev/null; then

    check_ok "SOCKS5 proxy responding"

else
    check_fail "SOCKS5 proxy unavailable"
fi

echo

if [ "$FAIL" -eq 0 ]; then
    echo "STATUS: READY"
else
    echo "STATUS: ISSUES FOUND"
fi

exit "$FAIL"
