#!/data/data/com.termux/files/usr/bin/bash

#
# Termux WireProxy
# Diagnostics helper library
#

set -euo pipefail

#
# Print section header
#
diag_section() {
    echo
    echo "=== $1 ==="
}

#
# Success message
#
diag_ok() {
    printf "[✓] %s\n" "$1"
}

#
# Warning message
#
diag_warn() {
    printf "[!] %s\n" "$1"
}

#
# Error message
#
diag_fail() {
    printf "[✗] %s\n" "$1"
}

#
# Run a check command.
#
# Usage:
#   diag_check "Description" command arg1 arg2 ...
#
diag_check() {
    local description="$1"
    shift

    if "$@" >/dev/null 2>&1; then
        diag_ok "$description"
        return 0
    fi

    diag_fail "$description"
    return 1
}

#
# Print a key/value pair.
#
diag_info() {
    printf "%-18s %s\n" "$1:" "$2"
}
