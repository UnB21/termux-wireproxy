#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/configs/project.conf"
source "$PROJECT_DIR/lib/common.sh"

echo "=== Stopping Termux WireProxy ==="

if [ ! -f "$PID_FILE" ]; then
    echo "No PID file found."

    if is_running; then
        echo "Found running wireproxy process:"
        get_pid
        echo "Stopping..."
        pkill -f "wireproxy.*$WIREPROXY_CONFIG" || true
    else
        echo "Wireproxy is not running."
    fi

    exit 0
fi


PID=$(cat "$PID_FILE")

if kill -0 "$PID" 2>/dev/null; then

    CMD=$(ps -p "$PID" -o args=)

    if echo "$CMD" | grep -q "wireproxy"; then
        echo "Stopping wireproxy PID: $PID"
        kill "$PID"

        sleep 2

        if kill -0 "$PID" 2>/dev/null; then
            echo "Process still running, forcing shutdown..."
            kill -9 "$PID"
        fi

    else
        echo "PID does not belong to wireproxy."
    fi

else
    echo "PID is no longer active."
fi


rm -f "$PID_FILE"

echo "Wireproxy stopped."
