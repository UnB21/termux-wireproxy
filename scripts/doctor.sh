#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/lib/common.sh"
source "$PROJECT_DIR/lib/diagnostics.sh"

FAILURES=0

echo "================================="
echo " Termux WireProxy Doctor"
echo "================================="

diag_section "Binary Check"

if command -v "$WIREPROXY_BIN" >/dev/null 2>&1; then
    diag_ok "wireproxy installed"
else
    diag_fail "wireproxy not installed"
    FAILURES=$((FAILURES + 1))
fi


diag_section "Active Configuration"

echo "Provider : $PROVIDER"
echo "Profile  : $PROFILE"
echo

if [ -f "$WG_CONFIG" ]; then
    diag_ok "provider profile found"
else
    diag_fail "provider profile missing"
    FAILURES=$((FAILURES + 1))
fi

if [ -f "$WIREPROXY_CONFIG" ]; then
    diag_ok "wireproxy config found"
else
    diag_fail "wireproxy config missing"
    FAILURES=$((FAILURES + 1))
fi


diag_section "WireGuard Profile"

if [ -f "$WG_CONFIG" ]; then

    if ! validate_wireguard_profile "$WG_CONFIG"; then
        FAILURES=$((FAILURES + 1))
    fi

fi


diag_section "Process Check"

if is_running; then
    diag_ok "wireproxy running"
    echo "PID: $(get_pid | head -n1)"
else
    diag_fail "wireproxy not running"
    FAILURES=$((FAILURES + 1))
fi


diag_section "SOCKS Check"

if command -v curl >/dev/null 2>&1 &&
   curl --silent --socks5-hostname "$SOCKS_HOST:$SOCKS_PORT" http://example.com >/dev/null 2>&1; then

    diag_ok "SOCKS5 proxy responding"

else
    diag_fail "SOCKS5 proxy unavailable"
    FAILURES=$((FAILURES + 1))
fi


echo

if [ "$FAILURES" -eq 0 ]; then
    echo "STATUS: READY"
else
    echo "STATUS: NOT READY"
    echo
    echo "Issues detected: $FAILURES"
fi
