#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_DIR/configs/project.conf"

echo "================================="
echo " Termux WireProxy Initialization"
echo "================================="
echo

echo "Project:"
echo "$PROJECT_DIR"

echo

echo "Checking directories..."

mkdir -p \
"$PROJECT_DIR/providers" \
"$PROJECT_DIR/logs" \
"$PROJECT_DIR/state"

echo "✓ Directory structure ready"

echo

echo "Initialization complete."
