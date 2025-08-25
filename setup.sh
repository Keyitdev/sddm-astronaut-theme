#!/bin/bash

## SDDM Astronaut Theme Installer
## Based on original by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
## Copyright (C) 2022-2025 Keyitdev

# Script works in Arch, Fedora, Ubuntu. Didn't tried in Void and openSUSE
#
set -euo pipefail

readonly THEME_REPO="https://github.com/Keyitdev/sddm-astronaut-theme.git"
readonly THEME_NAME="sddm-astronaut-theme"
readonly THEMES_DIR="/usr/share/sddm/themes"

readonly -a THEMES=(
    "astronaut" "black_hole" "cyberpunk" "hyprland_kath" "jake_the_dog"
    "japanese_aesthetic" "pixel_sakura" "pixel_sakura_static"
    "post-apocalyptic_hacker" "purple_leaves"
)

# Logging with gum fallback
info() {
    if command -v gum &>/dev/null; then
        gum style --foreground="#00ff00" "✓ $*"
    else
        echo -e "\e[32m✓ $*\e[0m"
    fi
}

warn() {
    if command -v gum &>/dev/null; then
        gum style --foreground="#ffaa00" "⚠ $*"
    else
        echo -e "\e[33m⚠ $*\e[0m"
    fi
}

error() {
    if command -v gum &>/dev/null; then
        gum style --foreground="#ff0000" "✗ $*" >&2
    else
        echo -e "\e[31m✗ $*\e[0m" >&2
    fi
}

# UI functions
confirm() {
    if command -v gum &>/dev/null; then
        gum confirm "$1"
    else
        echo -n "$1 (y/N): "; read -r r; [[ "$r" =~ ^[Yy]$ ]]
    fi
}

choose() {
    if command -v gum &>/dev/null; then
        gum choose "$@"
    else
        select opt in "$@"; do [[ -n "$opt" ]] && { echo "$opt"; break; }; done
    fi
}

spin() {
    local title="$1"; shift
    if command -v gum &>/dev/null; then
        gum spin --spinner="dot" --title="$title" -- "$@"
    else
        echo "$title"; "$@"
    fi
}

# Install gum if missing
install_gum() {
    local mgr=$(for m in pacman xbps dnf zypper apt; do command -v $m &>/dev/null && { echo ${m%%-*}; break; }; done)

    case $mgr in
        pacman) sudo pacman -S gum ;;
        dnf) sudo dnf install -y gum ;;
        zypper) sudo zypper install -y gum ;;
        xbps) sudo xbps-install -y gum ;;
        # refrence https://github.com/basecamp/omakub/issues/222
        apt)
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
            echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
            sudo apt update && sudo apt install -y gum ;;
        *) error "Cannot install gum automatically"; return 1 ;;
    esac
}

# Check and install gum
check_gum() {
    if ! command -v gum &>/dev/null; then
        warn "gum not found - provides better UI experience"
        if confirm "Install gum?"; then
            install_gum && { info "Restarting with gum..."; exec "$0" "$@"; } || warn "Using fallback UI"
        fi
    fi
}

# Install dependencies
install_deps() {
    local mgr=$(for m in pacman xbps dnf zypper apt; do command -v $m &>/dev/null && { echo ${m%%-*}; break; }; done)
    info "Package manager: $mgr"

    case $mgr in
        pacman) sudo pacman --needed -S sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg ;;
        xbps) sudo xbps-install -y sddm qt6-svg qt6-virtualkeyboard qt6-multimedia ;;
        dnf) sudo dnf install -y sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia ;;
        zypper) sudo zypper install -y sddm libQt6Svg6 qt6-virtualkeyboard qt6-multimedia ;;
        apt) sudo apt update && sudo apt install -y sddm qt6-svg-dev qml6-module-qtquick-virtualkeyboard qt6-multimedia-dev ;;
        *) error "Unsupported package manager"; return 1 ;;
    esac
    info "Dependencies installed"
}

# Clone repository
clone_repo() {
    local path="$HOME/$THEME_NAME"
    [[ -d "$path" ]] && rm -rf "$path"
    spin "Cloning repository..." git clone -b master --depth 1 "$THEME_REPO" "$path"
    info "Repository cloned"
}

# Install theme
install_theme() {
    local src="$HOME/$THEME_NAME"
    local dst="$THEMES_DIR/$THEME_NAME"

    [[ ! -d "$src" ]] && { error "Clone repository first"; return 1; }

    # Backup and copy
    [[ -d "$dst" ]] && sudo mv "$dst" "${dst}_$(date +%s)"
    sudo mkdir -p "$dst"
    spin "Installing theme files..." sudo cp -r "$src"/* "$dst"/

    # Install fonts
    [[ -d "$dst/Fonts" ]] && spin "Installing fonts..." sudo cp -r "$dst/Fonts"/* /usr/share/fonts/

    # Configure SDDM
    echo "[Theme]
    Current=$THEME_NAME" | sudo tee /etc/sddm.conf >/dev/null

    sudo mkdir -p /etc/sddm.conf.d
    echo "[General]
    InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf >/dev/null

    info "Theme installed and configured"
}

# Select theme variant
select_theme() {
    local metadata="$THEMES_DIR/$THEME_NAME/metadata.desktop"
    [[ ! -f "$metadata" ]] && { error "Install theme first"; return 1; }

    local theme=$(choose "${THEMES[@]}")
    sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/${theme}.conf|" "$metadata"
    info "Selected: $theme"
}

# Enable SDDM
enable_sddm() {
    command -v systemctl &>/dev/null || { error "systemctl not found"; return 1; }

    sudo systemctl disable display-manager.service 2>/dev/null || true
    sudo systemctl enable sddm.service
    info "SDDM enabled - reboot required"
}

# Main menu
main() {
    [[ $EUID -eq 0 ]] && { error "Don't run as root"; exit 1; }
    command -v git &>/dev/null || { error "git required"; exit 1; }

    check_gum

    while true; do
        echo
        if command -v gum &>/dev/null; then
            gum style --foreground="#00ffff" "🚀 SDDM Astronaut Theme Installer"
        else
            echo -e "\e[36m🚀 SDDM Astronaut Theme Installer\e[0m"
        fi

        local choice=$(choose \
            "🚀 Complete Installation" \
            "📦 Install Dependencies" \
            "📥 Clone Repository" \
            "📂 Install Theme" \
            "🎨 Select Theme Variant" \
            "⚙️ Enable SDDM Service" \
            "❌ Exit")

        case "$choice" in
            "🚀 Complete Installation") install_deps && clone_repo && install_theme && select_theme && enable_sddm ;;
            "📦 Install Dependencies") install_deps ;;
            "📥 Clone Repository") clone_repo ;;
            "📂 Install Theme") install_theme ;;
            "🎨 Select Theme Variant") select_theme ;;
            "⚙️ Enable SDDM Service") enable_sddm ;;
            "❌ Exit") info "Goodbye!"; exit 0 ;;
        esac

        echo; if command -v gum &>/dev/null; then
            gum input --placeholder="Press Enter to continue..."
        else
            echo -n "Press Enter..."; read -r
        fi
    done
}

trap 'echo; info "Cancelled"; exit 130' INT TERM
main "$@"
