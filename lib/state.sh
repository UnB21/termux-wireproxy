#!/data/data/com.termux/files/usr/bin/bash

#
# Termux WireProxy
# State Management Library
#

set -euo pipefail

########################################
# State Paths
########################################

ACTIVE_STATE_FILE="$STATE_DIR/active.conf"

########################################
# Initialize State Directory
########################################

init_state() {

    mkdir -p "$STATE_DIR"

}

########################################
# Save Active Profile
########################################

save_active_profile() {

    local provider="$1"
    local profile="$2"

    init_state

    cat > "$ACTIVE_STATE_FILE" <<EOF
PROVIDER="$provider"
PROFILE="$profile"
EOF

}

########################################
# Refresh Derived Paths
########################################

refresh_profile_paths() {

    ACTIVE_PROVIDER_DIR="$PROJECT_DIR/providers/$PROVIDER"
    WG_CONFIG="$ACTIVE_PROVIDER_DIR/$PROFILE"

}

########################################
# Load Active Profile
########################################

load_active_profile() {

    if [ -f "$ACTIVE_STATE_FILE" ]; then

        source "$ACTIVE_STATE_FILE"

        refresh_profile_paths

        return 0

    fi

    return 1

}

########################################
# Check Active Profile
########################################

has_active_profile() {

    [ -f "$ACTIVE_STATE_FILE"

}
