#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

echo "========================================"
echo "      Termux WireProxy Installer"
echo "========================================"
echo

# Verify we're running in Termux.
if [ -z "${PREFIX:-}" ]; then
    echo "Error: This installer must be run inside Termux."
    exit 1
fi

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$PREFIX/bin/twp"

echo "Project directory:"
echo "  $PROJECT_DIR"
echo

echo "Checking dependencies..."

if command -v wireproxy >/dev/null 2>&1; then
    echo "✓ wireproxy found"
else
    echo "wireproxy not found."
    echo "Installing wireproxy..."

    pkg install -y wireproxy

    if command -v wireproxy >/dev/null 2>&1; then
        echo "✓ wireproxy installed"
    else
        echo "Failed to install wireproxy."
        exit 1
    fi
fi

echo

echo "Making twp executable..."
chmod +x "$PROJECT_DIR/bin/twp"

echo "Creating symlink..."
ln -sf "$PROJECT_DIR/bin/twp" "$TARGET"

echo
echo "Verifying installation..."

if command -v twp >/dev/null 2>&1; then
    echo "✓ twp installed successfully."
    echo
    twp version
else
    echo "Installation failed."
    exit 1
fi

echo
echo "Installation complete!"
echo "Run:"
echo "  twp doctor"
