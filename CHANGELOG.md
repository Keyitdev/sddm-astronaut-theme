# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2025-08-08

### 🚀 Major Rewrite
- Complete rewrite of the original `install.sh` by Keyitdev.
- Modernized structure using `set -euo pipefail` for safer Bash execution.
- Separated functionality into well-defined functions for modularity and clarity.

### ✨ New Features
- **Gum UI integration** for enhanced terminal interactivity.
- **Interactive theme selection** with icons and descriptions.
- **Main menu system** using `gum choose` with labeled options.
- **Preview mode** for themes using `sddm-greeter-qt6` or `sddm-greeter`.
- **Backup system** for existing installs (timestamped safely).
- **Systemd service management** for enabling/disabling SDDM safely.

### ✅ Improvements
- Cross-distro package manager detection (`pacman`, `dnf`, `apt`, `zypper`, `xbps`).
- Cleaner logging via `gum style` for status messages.
- Font installation is now automated and visually indicated.
- Added confirmation prompts for destructive or system-altering actions.
- Ensures script is not run as root directly (`EUID` check).

### 🐛 Fixes
- Resolved hard-coded paths by using variables consistently.
- Improved error handling when directories or files are missing.

## Original by Keyitdev

### Initial Release
- Base script to install and configure `sddm-astronaut-theme`.
- Basic support for multiple distros and theme selection via numbered input.
- Manual-style execution flow with minimal validation.
