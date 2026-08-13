#!/data/data/com.termux/files/usr/bin/bash

#
# Termux WireProxy
# Security Diagnostics Library
#

set -euo pipefail

########################################
# Permission Helpers
########################################

security_permissions() {

    local path="$1"

    if [ ! -e "$path" ]; then
        return 1
    fi

    stat -c '%a' "$path" 2>/dev/null
}

security_is_private() {

    local path="$1"
    local mode

    mode="$(security_permissions "$path")" || return 1

    case "$mode" in
        600|640|660|700|750|770)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

security_is_private_file() {

    local path="$1"
    local mode

    mode="$(security_permissions "$path")" || return 1

    case "$mode" in
        600|640|660)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

########################################
# Security Check Helpers
########################################

security_check_path() {

    local description="$1"
    local path="$2"

    if [ ! -e "$path" ]; then
        diag_info "$description" "Not present"
        return 0
    fi

    local mode
    mode="$(security_permissions "$path")"

    if security_is_private "$path"; then
        diag_ok "$description permissions: $mode"
        return 0
    fi

    diag_warn "$description permissions may be too permissive: $mode"
    return 1
}


security_check_private_file() {

    local description="$1"
    local path="$2"

    if [ ! -e "$path" ]; then
        diag_info "$description" "Not present"
        return 0
    fi

    local mode
    mode="$(security_permissions "$path")"

    if security_is_private_file "$path"; then
        diag_ok "$description permissions: $mode"
        return 0
    fi

    diag_fail "$description permissions are too permissive: $mode"
    return 1
}


########################################
# WireGuard Credential Protection
########################################

security_check_wireguard_profile() {

    local profile="$1"

    if [ ! -f "$profile" ]; then
        diag_fail "Active WireGuard profile missing"
        return 1
    fi

    security_check_private_file \
        "WireGuard profile" \
        "$profile"
}


########################################
# Local Configuration Protection
########################################

security_check_local_config() {

    local config="$PROJECT_DIR/configs/project.local.conf"

    if [ ! -f "$config" ]; then
        diag_info "Local configuration" "Not present"
        return 0
    fi

    security_check_private_file \
        "Local configuration" \
        "$config"
}


########################################
# Runtime Configuration Protection
########################################

security_check_runtime_config() {

    local config="$WIREPROXY_CONFIG"

    if [ ! -f "$config" ]; then
        diag_info "Runtime configuration" "Not present"
        return 0
    fi

    security_check_private_file \
        "Runtime configuration" \
        "$config"
}


########################################
# Provider Directory Protection
########################################

security_check_provider_directory() {

    local directory="$ACTIVE_PROVIDER_DIR"

    if [ ! -d "$directory" ]; then
        diag_info "Provider directory" "Not present"
        return 0
    fi

    local mode
    mode="$(security_permissions "$directory")"

    case "$mode" in
        700|750|770)
            diag_ok "Provider directory permissions: $mode"
            return 0
            ;;
        *)
            diag_warn "Provider directory permissions may be too permissive: $mode"
            return 1
            ;;
    esac
}


########################################
# Git Tracking Protection
########################################

security_check_git_tracking() {

    local profile="$1"

    if [ ! -f "$profile" ]; then
        return 0
    fi

    if ! command -v git >/dev/null 2>&1; then
        diag_info "Git credential tracking" "Git not installed"
        return 0
    fi

    if ! git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree \
        >/dev/null 2>&1; then

        diag_info "Git credential tracking" "Not a Git repository"
        return 0
    fi

    local relative_path

    relative_path="${profile#"$PROJECT_DIR"/}"

    if git -C "$PROJECT_DIR" ls-files --error-unmatch "$relative_path" \
        >/dev/null 2>&1; then

        diag_fail "WireGuard profile is tracked by Git"
        echo "    $relative_path"
        return 1
    fi

    diag_ok "WireGuard profile is not tracked by Git"
    return 0
}


########################################
# Security Summary
########################################

security_check_all() {

    local failures=0

    diag_section "File Permissions"

    security_check_path \
        "Project directory" \
        "$PROJECT_DIR" || failures=$((failures + 1))

    security_check_provider_directory \
        || failures=$((failures + 1))

    security_check_wireguard_profile \
        "$WG_CONFIG" \
        || failures=$((failures + 1))

    security_check_local_config \
        || failures=$((failures + 1))

    security_check_runtime_config \
        || failures=$((failures + 1))


    diag_section "Git Protection"

    security_check_git_tracking \
        "$WG_CONFIG" \
        || failures=$((failures + 1))


    return "$failures"
}
