#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/configs/project.conf"
source "$PROJECT_DIR/lib/common.sh"

mkdir -p "$LOG_DIR" "$STATE_DIR"

echo "=== Starting Termux WireProxy ==="

if is_running; then
    echo "Wireproxy is already running."
    get_pid
    exit 0
fi

echo "Preparing WireProxy configuration..."

cat > "$WIREPROXY_CONFIG" <<EOF
WGConfig = $WG_CONFIG

[Socks5]
BindAddress = $SOCKS_HOST:$SOCKS_PORT
EOF

echo "Starting wireproxy..."

"$WIREPROXY_BIN" -s -c "$WIREPROXY_CONFIG" \
    >> "$LOG_FILE" 2>&1 &

PID=$!

echo "$PID" > "$PID_FILE"

sleep 2

if kill -0 "$PID" 2>/dev/null; then
    echo "Wireproxy started."
    echo "PID: $PID"
    echo "Config: $WIREPROXY_CONFIG"
    echo "Log: $LOG_FILE"
else
    echo "Failed to start wireproxy."
    rm -f "$PID_FILE"
    exit 1
fi
