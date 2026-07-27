#!/data/data/com.termux/files/usr/bin/bash

#
# Termux WireProxy
# Runtime Initialization
#

set -euo pipefail

########################################
# Project Root
########################################

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

########################################
# Load Runtime Libraries
########################################

source "$PROJECT_DIR/lib/common.sh"

########################################
# Load Active Profile
########################################

load_active_profile >/dev/null 2>&1 || true
