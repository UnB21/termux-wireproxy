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

    if grep -q "^PrivateKey" "$WG_CONFIG"; then
        diag_ok "PrivateKey present"
    else
        diag_fail "PrivateKey missing"
        FAILURES=$((FAILURES + 1))
    fi

    if grep -q "^PublicKey" "$WG_CONFIG"; then
        diag_ok "Peer PublicKey present"
    else
        diag_fail "Peer PublicKey missing"
        FAILURES=$((FAILURES + 1))
    fi

    ENDPOINT=$(grep "^Endpoint" "$WG_CONFIG" | sed 's/^Endpoint = //' || true)

    if [ -n "$ENDPOINT" ]; then
        diag_ok "Endpoint: $ENDPOINT"
    else
        diag_fail "Endpoint missing"
        FAILURES=$((FAILURES + 1))
    fi

    ALLOWED=$(grep "^AllowedIPs" "$WG_CONFIG" || true)

    if echo "$ALLOWED" | grep -q "0.0.0.0/0"; then
        diag_ok "IPv4 routing enabled"
    else
        diag_warn "IPv4 routing disabled"
    fi

    if echo "$ALLOWED" | grep -q "::/0"; then
        diag_ok "IPv6 routing enabled"
    else
        diag_warn "IPv6 routing disabled"
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
