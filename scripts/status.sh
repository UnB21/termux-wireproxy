#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/lib/runtime.sh"

if has_active_profile; then
    ACTIVE_PROFILE_LOADED=true
else
    ACTIVE_PROFILE_LOADED=false
fi

echo "================================="
echo " Termux WireProxy Status"
echo "================================="

echo
echo "=== Version ==="
echo "${VERSION:-unknown}"

echo
echo "=== Provider ==="

if [ "$ACTIVE_PROFILE_LOADED" = true ]; then
    echo "$PROVIDER / $PROFILE"
else
    echo "$PROVIDER / $PROFILE (default)"
fi

echo
echo "=== WireGuard Profile ==="

if [ "$ACTIVE_PROFILE_LOADED" = true ]; then
    echo "$WG_CONFIG"
else
    echo "No active runtime profile."
fi

echo
echo "=== Wireproxy Process ==="

if is_running; then
    PID=$(get_pid | head -n1)
    echo "Running"
    echo "PID: $PID"
else
    echo "Stopped"
fi

echo
echo "=== SOCKS5 Proxy ==="
echo "$SOCKS_HOST:$SOCKS_PORT"

echo
echo "=== Runtime Config ==="
echo "$WIREPROXY_CONFIG"

echo
echo "=== VPN Exit IP ==="

if is_running; then
    curl --silent \
    --max-time 10 \
    --socks5-hostname "$SOCKS_HOST:$SOCKS_PORT" \
    https://api.ipify.org \
    && echo
else
    echo "Wireproxy is not running."
fi

echo
echo "=== Recent Logs ==="

if [ -f "$LOG_FILE" ]; then
    tail -n 10 "$LOG_FILE"
else
    echo "No log file found."
fi
