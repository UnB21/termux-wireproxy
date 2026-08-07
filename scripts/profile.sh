#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/lib/common.sh"

COMMAND="${1:-}"

case "$COMMAND" in

    list)
        exec "$PROJECT_DIR/scripts/profiles.sh"
        ;;

    compare)
        shift

        if [ "$#" -ne 2 ]; then
            echo "Usage:"
            echo "  twp profile compare <profile1> <profile2>"
            exit 1
        fi

        PROFILE_A="$1"
        PROFILE_B="$2"

        if ! profile_exists "$PROVIDER" "$PROFILE_A"; then
            echo "ERROR: Profile not found:"
            echo "$PROJECT_DIR/providers/$PROVIDER/$PROFILE_A"
            exit 1
        fi

        if ! profile_exists "$PROVIDER" "$PROFILE_B"; then
            echo "ERROR: Profile not found:"
            echo "$PROJECT_DIR/providers/$PROVIDER/$PROFILE_B"
            exit 1
        fi

        PROFILE_A_PATH="$PROJECT_DIR/providers/$PROVIDER/$PROFILE_A"
        PROFILE_B_PATH="$PROJECT_DIR/providers/$PROVIDER/$PROFILE_B"

        echo "================================="
        echo " WireGuard Profile Comparison"
        echo "================================="
        echo

        echo "Provider:"
        echo "$PROVIDER"
        echo

        echo "Profile A:"
        echo "$PROFILE_A"
        echo

        echo "Profile B:"
        echo "$PROFILE_B"
        echo

        echo "Endpoint:"
        echo "A: $(get_profile_endpoint "$PROFILE_A_PATH")"
        echo "B: $(get_profile_endpoint "$PROFILE_B_PATH")"
        echo

        echo "Routing:"
        echo "A: $(get_profile_routing "$PROFILE_A_PATH")"
        echo "B: $(get_profile_routing "$PROFILE_B_PATH")"
        echo

        echo "IPv4 Routing:"
        if profile_has_ipv4 "$PROFILE_A_PATH" && profile_has_ipv4 "$PROFILE_B_PATH"; then
            echo "MATCH"
        else
            echo "DIFFERENT"
        fi
        echo

        echo "IPv6 Routing:"
        if profile_has_ipv6 "$PROFILE_A_PATH" && profile_has_ipv6 "$PROFILE_B_PATH"; then
            echo "MATCH"
        else
            echo "DIFFERENT"
        fi
        echo

        echo "Private Keys:"
        if profile_has_private_key "$PROFILE_A_PATH" && profile_has_private_key "$PROFILE_B_PATH"; then
            echo "Present in both"
        else
            echo "Difference detected"
        fi

        echo

        echo "Peer Keys:"
        if profile_has_peer_key "$PROFILE_A_PATH" && profile_has_peer_key "$PROFILE_B_PATH"; then
            echo "Present in both"
        else
            echo "Difference detected"
        fi

        exit 0
        ;;

    info)
        shift
        ;;

    validate)
        exec "$PROJECT_DIR/scripts/doctor.sh"
        ;;

    *)
        echo "Usage:"
        echo "  twp profile list"
        echo "  twp profile info <profile>"
        echo "  twp profile compare <profile1> <profile2>"
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
