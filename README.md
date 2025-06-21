# sddm-astronaut-theme

![Stars](https://img.shields.io/github/stars/keyitdev/sddm-astronaut-theme?color=dd864a&labelColor=1b1b25&style=for-the-badge)
![Forks](https://img.shields.io/github/forks/keyitdev/sddm-astronaut-theme?color=bf616a&labelColor=1b1b25&style=for-the-badge)

A modern and extensible **SDDM theme system** built with **Qt6**, featuring support for both static and animated wallpapers, a dynamic theme system, a virtual keyboard, and theme creation tools — all powered by an interactive setup script.

> 🧠 This is a maintained fork of [Keyitdev's sddm-astronaut-theme](https://github.com/Keyitdev/sddm-astronaut-theme), extending it with developer tools and automation while keeping it fully GPLv3-compliant.

---

## 🖼️ Theme Previews

<img src="https://github.com/Keyitdev/screenshots/blob/master/sddm-astronaut-theme/master/all_themes.gif?raw=true" alt="Theme Preview" width="700"/>

---

## ✨ What’s New in This Fork

This fork keeps all features from the original and adds:

- 📦 **Modular installer (`setup.sh`)**  
  Fully rewritten installer with input coloring, animated loading bars, structured UI, and fail-safe prompts

- 🎛️ **Interactive theme selector**  
  Automatically detects `.conf` files in the `Themes/` directory and classifies them into Presets or Custom Themes

- 🧪 **Theme preview system**  
  Run the current theme or preview any theme with `sddm-greeter-qt6 --test-mode`, directly from the menu

- 🧰 **Theme creation wizard (`create_theme.sh`)**  
  Interactively select layout, wallpaper, and fonts to build and register your own theme

- 🎨 **Enhanced configuration logic**  
  Automatically updates `metadata.desktop` and `sddm.conf` with appropriate paths

- 🖋️ **Respectful GPLv3+ licensing**  
  All modifications are fully compatible with and built on top of the original license and structure

---

## 🔧 Features Overview

| Feature                          | Description                                                                 |
|----------------------------------|-----------------------------------------------------------------------------|
| ✅ Qt6 Support                   | Works with `qt6-svg`, `qt6-virtualkeyboard`, and `qt6-multimedia`          |
| 🎨 Dynamic Themes               | Swap or preview `.conf` layouts instantly                                  |
| 🔤 Font + Wallpaper Customization| Fully override wallpapers and fonts for each layout                        |
| 🧪 Preview Mode                 | Launch `sddm-greeter-qt6` in test mode with the selected theme             |
| 🛠️ Theme Generator             | Easily create new layout configurations with your assets                   |
| 📦 Multiple Package Manager Support | Works with `pacman`, `xbps-install`, `dnf`, and `zypper`                 |

---

## 🚀 One-Liner Installation (Recommended)

To install and launch the theme installer directly:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Ishan0121/sddm-astronaut-theme/main/setup.sh)"
````
---

## 🧰 Manual Installation

If you'd prefer to set things up manually, follow these steps:

### 1. Install Required Packages

| Distro   | Command                                                                  |
| -------- | ------------------------------------------------------------------------ |
| Arch     | `sudo pacman -S sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg`  |
| Void     | `sudo xbps-install -S sddm qt6-svg qt6-virtualkeyboard qt6-multimedia`   |
| Fedora   | `sudo dnf install sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia` |
| openSUSE | `sudo zypper install sddm-qt6 libQt6Svg6 qt6-virtualkeyboard qt6-virtualkeyboard-imports qt6-multimedia qt6-multimedia-imports `        |

### 2. Clone This Repository

```bash
sudo git clone -b master --depth 1 https://github.com/Ishan0121/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
```

### 3. Copy Fonts

```bash
sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
```

### 4. Set Theme in `sddm.conf`

```bash
echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf
```

### 5. Enable Virtual Keyboard

```bash
echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf
```

---

## 🖼️ Theme Management Tips

* All layout configs are stored in `/usr/share/sddm/themes/sddm-astronaut-theme/Themes/`
* Active theme is set via the line:

  ```ini
  ConfigFile=Themes/YOUR_THEME.conf
  ```

  inside `metadata.desktop`
* Preview themes without restarting the display manager using:

  ```bash
  sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme
  ```

---

## 🧩 Adding Your Own Themes

To make a new theme:

```bash
cd /path/to/sddm-astronaut-theme
./setup.sh
```

Then choose: `Create a new theme`

You'll be guided through layout selection, font and wallpaper configuration, and save it into the correct directory automatically.

---

## 📜 License

This project is licensed under the **GNU General Public License v3.0 or later** ([GPLv3+](https://www.gnu.org/licenses/gpl-3.0.html)).

All original assets, base code, and visuals are created by [Keyitdev](https://github.com/Keyitdev).

This fork builds on that foundation and extends it with advanced tooling and quality-of-life improvements, while honoring all original license terms and attribution.

---

```
