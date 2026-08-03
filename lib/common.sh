#!/data/data/com.termux/files/usr/bin/bash

#
# Termux WireProxy
# Common Library
#

set -euo pipefail

########################################
# Configuration Loading
########################################

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load tracked default configuration
source "$PROJECT_DIR/configs/project.conf"

# Load local user overrides if available
if [ -f "$PROJECT_DIR/configs/project.local.conf" ]; then
    source "$PROJECT_DIR/configs/project.local.conf"
fi

########################################
# Rebuild Derived Paths
########################################

ACTIVE_PROVIDER_DIR="$PROJECT_DIR/providers/$PROVIDER"

WG_CONFIG="$ACTIVE_PROVIDER_DIR/$PROFILE"

WIREPROXY_CONFIG="$STATE_DIR/wireproxy.conf"

PID_FILE="$STATE_DIR/wireproxy.pid"

########################################
# Version
########################################

VERSION_FILE="$PROJECT_DIR/VERSION"

if [ -f "$VERSION_FILE" ]; then
    VERSION=$(tr -d '\n' < "$VERSION_FILE")
else
    VERSION="unknown"
fi

########################################
# Logging
########################################

log() {
    printf '[%s] %s\n' "$(date '+%F %T')" "$*"
}

########################################
# Error handling
########################################

die() {
    log "ERROR: $*"
    exit 1
}

########################################
# Process management
########################################

get_pid() {
    pgrep -f "wireproxy.*$WIREPROXY_CONFIG" || true
}

is_running() {
    [ -n "$(get_pid)" ]
}

########################################
# Validation
########################################

check_wireproxy() {
    command -v "$WIREPROXY_BIN" >/dev/null 2>&1 \
        || die "wireproxy is not installed."
}

check_files() {

    [ -f "$WG_CONFIG" ] \
        || die "WireGuard configuration not found."

    [ -f "$WIREPROXY_CONFIG" ] \
        || die "wireproxy.conf not found."

}

########################################
# WireGuard Profile Helpers
########################################

get_profile_endpoint() {

    local profile="$1"

    grep -m1 "^Endpoint" "$profile" \
        | cut -d'=' -f2- \
        | xargs || true
}

get_profile_allowed_ips() {

    local profile="$1"

    grep -m1 "^AllowedIPs" "$profile" \
        | cut -d'=' -f2- \
        | xargs || true
}

profile_has_private_key() {

    local profile="$1"

    grep -q "^PrivateKey" "$profile"
}

profile_has_peer_key() {

    local profile="$1"

    grep -q "^PublicKey" "$profile"
}

get_profile_routing() {

    local profile="$1"

    local allowed

    allowed="$(get_profile_allowed_ips "$profile")"

    if echo "$allowed" | grep -q "0.0.0.0/0" &&
       echo "$allowed" | grep -q "::/0"; then

        echo "Dual Stack"

    elif echo "$allowed" | grep -q "0.0.0.0/0"; then

        echo "IPv4"

    elif echo "$allowed" | grep -q "::/0"; then

        echo "IPv6"

    else

        echo "Partial"

    fi
}

########################################
# Information
########################################

banner() {

cat <<EOF

=====================================
      Termux WireProxy
        Version $VERSION
=====================================

Provider : $PROVIDER
Profile  : $PROFILE

=====================================

EOF

}
