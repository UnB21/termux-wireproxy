#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/lib/common.sh"

echo "================================="
echo " Termux WireProxy Configuration"
echo "================================="
echo

echo "=== Application ==="
echo "Version        : $VERSION"
echo "Project Dir    : $(get_project_dir)"
echo

echo "=== Provider ==="
echo "Provider       : $PROVIDER"
echo "Profile        : $PROFILE"
echo "Profile Path   : $(get_profile_path)"
echo

echo "=== WireGuard ==="

ENDPOINT="$(get_profile_endpoint "$WG_CONFIG")"

echo "Endpoint       : ${ENDPOINT:-Unknown}"

if profile_has_ipv4 "$WG_CONFIG"; then
    echo "IPv4 Routing   : Enabled"
else
    echo "IPv4 Routing   : Disabled"
fi

if profile_has_ipv6 "$WG_CONFIG"; then
    echo "IPv6 Routing   : Enabled"
else
    echo "IPv6 Routing   : Disabled"
fi

if profile_has_private_key "$WG_CONFIG"; then
    echo "Private Key    : Present"
else
    echo "Private Key    : Missing"
fi

if profile_has_peer_key "$WG_CONFIG"; then
    echo "Peer Key       : Present"
else
    echo "Peer Key       : Missing"
fi

echo

echo "=== Runtime ==="
echo "Runtime Config : $(get_runtime_config)"
echo "PID File       : $(get_pid_file)"
echo "Log File       : $(get_log_file)"
echo

echo "=== Network ==="
echo "SOCKS5         : $(get_socks_address)"

if is_running; then
    echo "Status         : Running"
    echo "PID            : $(get_pid | head -n1)"
else
    echo "Status         : Stopped"
fi
