#!/data/data/com.termux/files/usr/bin/bash

#
# Termux WireProxy
# Common Library
#

set -euo pipefail

# Load project configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_DIR/configs/project.conf"

########################################
# Version
#######################################

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
