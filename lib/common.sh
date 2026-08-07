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

profile_has_ipv4() {

    local profile="$1"

    local allowed

    allowed="$(get_profile_allowed_ips "$profile")"

    echo "$allowed" | grep -q "0.0.0.0/0"
}


profile_has_ipv6() {

    local profile="$1"

    local allowed

    allowed="$(get_profile_allowed_ips "$profile")"

    echo "$allowed" | grep -q "::/0"
}


profile_exists() {

    local provider="$1"
    local profile="$2"

    [ -f "$PROJECT_DIR/providers/$provider/$profile" ]
}


list_profiles() {

    local provider="$1"

    local profile_dir="$PROJECT_DIR/providers/$provider"

    find "$profile_dir" -maxdepth 1 -name "*.conf" -type f \
        -printf "%f\n" | sort
}

########################################
# Runtime Helpers
########################################

get_runtime_config() {
    printf '%s\n' "$WIREPROXY_CONFIG"
}

get_log_file() {
    printf '%s\n' "$LOG_DIR/wireproxy.log"
}

get_pid_file() {
    printf '%s\n' "$PID_FILE"
}

get_socks_address() {
    printf '%s:%s\n' "$SOCKS_HOST" "$SOCKS_PORT"
}

get_project_dir() {
    printf '%s\n' "$PROJECT_DIR"
}

get_profile_path() {
    printf '%s\n' "$WG_CONFIG"
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
