#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/lib/common.sh"
source "$PROJECT_DIR/lib/diagnostics.sh"
source "$PROJECT_DIR/lib/security.sh"

if [ "$#" -ne 2 ]; then
    echo "Usage:"
    echo "  twp use <provider> <profile>"
    exit 1
fi

NEW_PROVIDER="$1"
NEW_PROFILE="$2"

if [ "$PROVIDER" = "$NEW_PROVIDER" ] && [ "$PROFILE" = "$NEW_PROFILE" ]; then
    echo "Already active:"
    echo "Provider: $PROVIDER"
    echo "Profile:  $PROFILE"
    echo
    echo "No restart required."
    exit 0
fi

PROFILE_PATH="$PROJECT_DIR/providers/$NEW_PROVIDER/$NEW_PROFILE"

########################################
# Candidate Profile Check
########################################

if [ ! -f "$PROFILE_PATH" ]; then
    echo "ERROR: Profile not found:"
    echo "$PROFILE_PATH"
    exit 1
fi

echo
echo "Validating WireGuard profile..."

if ! validate_wireguard_profile "$PROFILE_PATH"; then
    echo
    echo "ERROR: WireGuard profile validation failed."
    echo "Profile:"
    echo "$PROFILE_PATH"
    echo
    echo "Active configuration was not changed."
    exit 1
fi

echo
echo "WireGuard profile is valid."

########################################
# Candidate Security Check
########################################

echo
echo "Checking profile security..."

if ! security_check_private_file \
    "WireGuard profile" \
    "$PROFILE_PATH"; then

    echo
    echo "ERROR: WireGuard profile security check failed."
    echo "Profile:"
    echo "$PROFILE_PATH"
    echo
    echo "Active configuration was not changed."
    exit 1
fi

########################################
# Configuration Backup
########################################

LOCAL_CONFIG="$PROJECT_DIR/configs/project.local.conf"
BACKUP_CONFIG=""

if [ -f "$LOCAL_CONFIG" ]; then
    BACKUP_CONFIG="$(mktemp "$STATE_DIR/project.local.conf.backup.XXXXXX")"
    chmod 600 "$BACKUP_CONFIG"
    cp -p "$LOCAL_CONFIG" "$BACKUP_CONFIG"
else
    BACKUP_CONFIG=""
fi

restore_configuration() {

    echo
    echo "Restoring previous configuration..."

    if [ -n "$BACKUP_CONFIG" ] && [ -f "$BACKUP_CONFIG" ]; then
        cp -p "$BACKUP_CONFIG" "$LOCAL_CONFIG"
        chmod 600 "$LOCAL_CONFIG"
    else
        rm -f "$LOCAL_CONFIG"
    fi
}

cleanup_backup() {

    if [ -n "$BACKUP_CONFIG" ]; then
        rm -f "$BACKUP_CONFIG"
    fi
}

########################################
# Write Candidate Configuration
########################################

echo
echo "Activating provider:"
echo "Provider: $NEW_PROVIDER"
echo "Profile:  $NEW_PROFILE"

if [ ! -f "$LOCAL_CONFIG" ]; then

    cat > "$LOCAL_CONFIG" <<EOF
#########################################
# Termux WireProxy Local Configuration
#########################################

# User-selected provider profile

PROVIDER="$NEW_PROVIDER"
PROFILE="$NEW_PROFILE"
EOF

else

    sed -i "s/^PROVIDER=.*/PROVIDER=\"$NEW_PROVIDER\"/" "$LOCAL_CONFIG"
    sed -i "s/^PROFILE=.*/PROFILE=\"$NEW_PROFILE\"/" "$LOCAL_CONFIG"

fi

chmod 600 "$LOCAL_CONFIG"

########################################
# Restart With Candidate Configuration
########################################

echo
echo "Restarting WireProxy..."

if "$PROJECT_DIR/scripts/restart.sh"; then

    cleanup_backup

    echo
    echo "Provider changed successfully:"
    echo "Provider: $NEW_PROVIDER"
    echo "Profile:  $NEW_PROFILE"

    exit 0

fi

########################################
# Candidate Start Failed
########################################

echo
echo "ERROR: WireProxy failed to start with the new profile."

restore_configuration

echo
echo "Attempting to restore the previous configuration..."

if "$PROJECT_DIR/scripts/restart.sh"; then

    cleanup_backup

    # Reload the restored configuration for accurate reporting.
    source "$LOCAL_CONFIG"

    echo
    echo "Previous configuration restored successfully."
    echo "Provider: $PROVIDER"
    echo "Profile:  $PROFILE"
    echo
    echo "Active configuration was not changed."

    exit 1

fi

########################################
# Rollback Failed
########################################

cleanup_backup

echo
echo "CRITICAL ERROR: Previous configuration could not be restored."
echo
echo "WireProxy may not be running."
echo
echo "Run:"
echo "  twp doctor"
echo
echo "Then inspect:"
echo "  twp current"
echo "  twp health"

exit 1
