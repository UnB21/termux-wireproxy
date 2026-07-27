#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/lib/runtime.sh"

if has_active_profile; then
    ACTIVE_PROFILE_LOADED=true
else
    ACTIVE_PROFILE_LOADED=false
fi

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

echo "=== Runtime Profile ==="

if [ "$ACTIVE_PROFILE_LOADED" = true ]; then
    check_ok "active profile: $PROVIDER/$PROFILE"
else
    check_fail "no active runtime profile"
fi

echo
echo "=== Binary Check ==="

if command -v "$WIREPROXY_BIN" >/dev/null 2>&1; then
    check_ok "wireproxy installed"
else
    check_fail "wireproxy missing"
fi

echo
echo "=== Configuration Check ==="

if [ -f "$WIREPROXY_CONFIG" ]; then
    check_ok "runtime config found"
else
    check_fail "runtime config missing"
fi

if [ -f "$WG_CONFIG" ]; then
    check_ok "provider profile found"
else
    check_fail "provider profile missing"
fi

echo
echo "=== Process Check ==="

if is_running; then
    check_ok "wireproxy running"
else
    check_fail "wireproxy not running"
fi

echo
echo "=== SOCKS Check ==="

if curl \
    --silent \
    --max-time 5 \
    --socks5-hostname "$SOCKS_HOST:$SOCKS_PORT" \
    https://api.ipify.org >/dev/null; then

    check_ok "SOCKS5 upstream connection working"

    EXIT_IP=$(curl \
        --silent \
        --max-time 5 \
        --socks5-hostname "$SOCKS_HOST:$SOCKS_PORT" \
        https://api.ipify.org)

    echo "Exit IP: $EXIT_IP"

else

    check_fail "SOCKS5 upstream connection failed"

    echo
    echo "Possible causes:"
    echo "- Another Android VPN service may be active (RethinkDNS, VPN apps, etc.)"
    echo "- WireGuard tunnel failed"
    echo "- Provider profile may be invalid"

fi

echo

if [ "$FAIL" -eq 0 ]; then
    echo "STATUS: READY"
else
    echo "STATUS: ISSUES FOUND"
fi

exit "$FAIL"
