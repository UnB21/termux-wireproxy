#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/lib/common.sh"

COMMAND="${1:-}"

case "$COMMAND" in
    info)
        shift
        ;;
    validate)
        shift
        exec "$PROJECT_DIR/scripts/doctor.sh"
        ;;
    *)
        echo "Usage:"
        echo "  twp profile info <profile>"
        echo "  twp profile validate"
        exit 1
        ;;
esac

# Existing "info" implementation starts here...

PROFILE_NAME="${1:-}"

if [ -z "$PROFILE_NAME" ]; then
    echo "Usage:"
    echo "  twp profile info <profile>"
    exit 1
fi

if ! profile_exists "$PROVIDER" "$PROFILE_NAME"; then
    echo "ERROR: Profile not found:"
    echo "$PROJECT_DIR/providers/$PROVIDER/$PROFILE_NAME"
    exit 1
fi


PROFILE_PATH="$PROJECT_DIR/providers/$PROVIDER/$PROFILE_NAME"

echo "================================="
echo " WireGuard Profile Information"
echo "================================="
echo

echo "Provider:"
echo "$PROVIDER"
echo

echo "Profile:"
echo "$PROFILE_NAME"
echo

echo "Endpoint:"
get_profile_endpoint "$PROFILE_PATH"
echo

echo "Routing:"
if profile_has_ipv4 "$PROFILE_PATH"; then
    echo "IPv4 : Enabled"
else
    echo "IPv4 : Disabled"
fi

if profile_has_ipv6 "$PROFILE_PATH"; then
    echo "IPv6 : Enabled"
else
    echo "IPv6 : Disabled"
fi

echo

echo "Keys:"
if profile_has_private_key "$PROFILE_PATH"; then
    echo "Private Key : Present"
else
    echo "Private Key : Missing"
fi

if profile_has_peer_key "$PROFILE_PATH"; then
    echo "Peer Key     : Present"
else
    echo "Peer Key     : Missing"
fi

echo

echo "Path:"
echo "$PROFILE_PATH"
