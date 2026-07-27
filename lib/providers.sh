#!/data/data/com.termux/files/usr/bin/bash

#
# Termux WireProxy
# Provider Management Library
#

set -euo pipefail

########################################
# Provider Paths
########################################

provider_path() {

    local provider="$1"

    echo "$PROJECT_DIR/providers/$provider"

}

########################################
# Profile Path
########################################

get_profile_path() {

    local provider="$1"
    local profile="$2"

    echo "$(provider_path "$provider")/$profile"

}

########################################
# Provider Check
########################################

provider_exists() {

    local provider="$1"

    [ -d "$(provider_path "$provider")" ]

}

########################################
# Profile Check
########################################

profile_exists() {

    local provider="$1"
    local profile="$2"

    [ -f "$(get_profile_path "$provider" "$profile")" ]

}

########################################
# List Providers
########################################

list_providers() {

    for provider in "$PROJECT_DIR/providers/"*; do

        [ -d "$provider" ] || continue

        basename "$provider"

    done

}

########################################
# List Profiles
########################################

list_profiles() {

    local provider="$1"

    for profile in "$(provider_path "$provider")"/*.conf; do

        [ -f "$profile" ] || continue

        basename "$profile"

    done

}
