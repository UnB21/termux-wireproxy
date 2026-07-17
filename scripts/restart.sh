#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Restarting Termux WireProxy ==="

"$PROJECT_DIR/scripts/stop.sh"

sleep 2

"$PROJECT_DIR/scripts/start.sh"
