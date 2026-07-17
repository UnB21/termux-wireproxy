#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

source "$HOME/termux-wireproxy/configs/project.conf"

echo "================================="
echo " Termux WireProxy Logs"
echo "================================="
echo

if [ ! -f "$LOG_FILE" ]; then
    echo "No log file found:"
    echo "$LOG_FILE"
    exit 1
fi

case "${1:-}" in

    -f|--follow)
        tail -f "$LOG_FILE"
        ;;

    *)
        tail -50 "$LOG_FILE"
        ;;

esac
