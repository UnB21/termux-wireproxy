#!/data/data/com.termux/files/usr/bin/bash

#
# Termux WireProxy
# Diagnostics helper library
#

set -euo pipefail

########################################
# Output Helpers
########################################

diag_section() {
    echo
    echo "=== $1 ==="
}

diag_ok() {
    printf "[✓] %s\n" "$1"
}

diag_warn() {
    printf "[!] %s\n" "$1"
}

diag_fail() {
    printf "[✗] %s\n" "$1"
}

diag_check() {
    local description="$1"
    shift

    if "$@" >/dev/null 2>&1; then
        diag_ok "$description"
        return 0
    fi

    diag_fail "$description"
    return 1
}

diag_info() {
    printf "%-18s %s\n" "$1:" "$2"
}


########################################
# WireGuard Validation Helpers
########################################

validate_private_key() {

    local profile="$1"

    if grep -q "^PrivateKey" "$profile"; then
        diag_ok "PrivateKey present"
        return 0
    fi

    diag_fail "PrivateKey missing"
    return 1
}


validate_peer_key() {

    local profile="$1"

    if grep -q "^PublicKey" "$profile"; then
        diag_ok "Peer PublicKey present"
        return 0
    fi

    diag_fail "Peer PublicKey missing"
    return 1
}


validate_endpoint() {

    local profile="$1"

    local endpoint

    endpoint=$(grep "^Endpoint" "$profile" | sed 's/^Endpoint = //' || true)

    if [ -n "$endpoint" ]; then
        diag_ok "Endpoint: $endpoint"
        return 0
    fi

    diag_fail "Endpoint missing"
    return 1
}


validate_ipv4_routing() {

    local profile="$1"

    local allowed

    allowed=$(grep "^AllowedIPs" "$profile" || true)

    if echo "$allowed" | grep -q "0.0.0.0/0"; then
        diag_ok "IPv4 routing enabled"
        return 0
    fi

    diag_warn "IPv4 routing disabled"
    return 1
}


validate_ipv6_routing() {

    local profile="$1"

    local allowed

    allowed=$(grep "^AllowedIPs" "$profile" || true)

    if echo "$allowed" | grep -q "::/0"; then
        diag_ok "IPv6 routing enabled"
        return 0
    fi

    diag_warn "IPv6 routing disabled"
    return 1
}


########################################
# Complete WireGuard Profile Check
########################################

validate_wireguard_profile() {

    local profile="$1"

    local failures=0

    if [ ! -f "$profile" ]; then
        diag_fail "Profile not found"
        return 1
    fi


    validate_private_key "$profile" || failures=$((failures + 1))

    validate_peer_key "$profile" || failures=$((failures + 1))

    validate_endpoint "$profile" || failures=$((failures + 1))

    validate_ipv4_routing "$profile" || failures=$((failures + 1))


    # IPv6 is optional
    validate_ipv6_routing "$profile" || true


    return "$failures"
}
