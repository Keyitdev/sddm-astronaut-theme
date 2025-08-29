# sddm-astronaut-theme-pop-os for Pop!OS

![Stars](https://img.shields.io/github/stars/keyitdev/sddm-astronaut-theme-pop-os?color=dd864a&labelColor=1b1b25&style=for-the-badge)
![Forks](https://img.shields.io/github/forks/keyitdev/sddm-astronaut-theme-pop-os?color=bf616a&labelColor=1b1b25&style=for-the-badge)

[sddm-astronaut-theme-pop-pop-os] is a version of [sddm-astronaut-theme](https://github.com/Keyitdev/sddm-astronaut-theme) display manager made by **[Keyitdev](https://github.com/Emii-lia)** for Pop!OS.

**Pop!_OS Edition Note**: This version has been modified for compatibility with Pop!_OS (Ubuntu-based systems) using Qt5 instead of Qt6. Some advanced features like MultiEffect blur have been replaced with Qt5-compatible alternatives. The animated background may not work properly or even crash ; it is recommended to use static background

## Preview of all themes

![all_themes.gif](https://github.com/Emii-lia/screenshots/blob/master/sddm-astronaut-theme-pop-os/master/all_themes.gif?raw=true)

## Preview of animated themes

https://github.com/user-attachments/assets/2cfc947e-4621-4e98-b5f3-07d5e224b80c

<!-- <h2><a href="https://youtu.be/4tQ56xh7wBc" target="_blank">Watch more on Youtube!</a></h2> -->
<details>
<summary><h2>Detailed previews</h2></summary>

**Astronaut**|**Black hole**
|:--:|:--:|
![astronaut](https://github.com/Emii-lia/screenshots/blob/master/sddm-astronaut-theme-pop-os/master/astronaut.png?raw=true)|![black_hole](https://github.com/Emii-lia/screenshots/blob/master/sddm-astronaut-theme-pop-os/master/black_hole.png?raw=true)
**Japanese aesthetic**|**Pixel sakura static**
![japanese_aesthetic](https://github.com/Emii-lia/screenshots/blob/master/sddm-astronaut-theme-pop-os/master/japanese_aesthetic.png?raw=true)|![pixel_sakura_static](https://github.com/Emii-lia/screenshots/blob/master/sddm-astronaut-theme-pop-os/master/pixel_sakura_static.png?raw=true)
**Purple leaves**|**Cyberpunk**
![purple_leaves](https://github.com/Emii-lia/screenshots/blob/master/sddm-astronaut-theme-pop-os/master/purple_leaves.png?raw=true)|![cyberpunk](https://github.com/Emii-lia/screenshots/blob/master/sddm-astronaut-theme-pop-os/master/cyberpunk.png?raw=true)
**Post-apocalyptic hacker**|**xxx**
![post-apocalyptic_hacker](https://github.com/Emii-lia/screenshots/blob/master/sddm-astronaut-theme-pop-os/master/post-apocalyptic_hacker.png?raw=true)|

**Hyprland Kath**

https://github.com/user-attachments/assets/1d926e76-44f7-4d99-ac6d-d1abcd7ed688

**Pixel sakura**

https://github.com/user-attachments/assets/ea004765-7e84-4a0d-90cd-aaac97679f62

**Jake the dog**

https://github.com/user-attachments/assets/181d48c2-f152-45f5-b568-21145be180f6

</details>

## Installation

### Automatic Installation


1. Install **dependencies**

[`sddm >= 0.21.0`](https://github.com/sddm/sddm)

``` sh
sudo apt update
sudo apt install sddm qml-module-qtquick2 qml-module-qtgraphicaleffects \
qml-module-qtquick-layouts qml-module-qtquick-controls2 \
qml-module-qtmultimedia gstreamer1.0-plugins-good \
gstreamer1.0-libav fonts-noto-color-emoji
```

2. Get and install the theme
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Emii-lia/sddm-astronaut-theme-pop-os/master/setup.sh)"
```

> Remember to always read the scripts you run from the internet.

### Manual Installation

1. Install **dependencies**

[`sddm >= 0.21.0`](https://github.com/sddm/sddm)

``` sh
sudo apt update
sudo apt install sddm qml-module-qtquick2 qml-module-qtgraphicaleffects \
qml-module-qtquick-layouts qml-module-qtquick-controls2 \
qml-module-qtmultimedia gstreamer1.0-plugins-good \
gstreamer1.0-libav fonts-noto-color-emoji
```

2. Clone this repository
```sh
sudo git clone -b master --depth 1 https://github.com/Emii-lia/sddm-astronaut-theme-pop-os.git /usr/share/sddm/themes/sddm-astronaut-theme-pop-os
```
3. Copy fonts to `/usr/share/fonts/`
```sh
sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme-pop-os/Fonts/* /usr/share/fonts/
```
4. Edit `/etc/sddm.conf`
```sh
echo "[Theme]
Current=sddm-astronaut-theme-pop-os" | sudo tee /etc/sddm.conf
```
5. Edit `/etc/sddm.conf.d/virtualkbd.conf`
```sh
echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf
```

6. Switch to SDDM

```sh
sudo dpkg-reconfigure gdm3
# Select SDDM from the list
```

7. Restart SDDM

```sh
sudo systemctl restart sddm
```

## Selecting a theme

You can select theme by editing [metadata](./metadata.desktop) (`/usr/share/sddm/themes/sddm-astronaut-theme-pop-os/metadata.desktop`).

Just edit this line:
```
ConfigFile=Themes/astronaut.conf
```
All available configs are in [Themes](./Themes/) directory.

## Sources

This theme is a fork of [sddm-astronaut-theme](https://github.com/keyitdev/sddm-astronaut-theme).