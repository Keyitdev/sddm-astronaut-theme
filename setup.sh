#!/bin/bash

## Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
## Copyright (C) 2022-2025 Keyitdev
## Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

red='\033[0;31m'
green='\033[0;32m'
no_color='\033[0m'
date=$(date +%s)

path_to_git_clone="$HOME"

install_dependencies(){
    if [ -x "$(command -v pacman)" ];
    then
        echo -e "${green}[*] Installing packages using pacman.${no_color}"
        sudo pacman --noconfirm --needed -S sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg
    elif [ -x "$(command -v xbps-install)" ];
    then
        echo -e "${green}[*] Installing packages using xbps-install.${no_color}"
        sudo xbps-install sddm qt6-svg qt6-virtualkeyboard qt6-multimedia
    elif [ -x "$(command -v dnf)" ];
    then
        echo -e "${green}[*] Installing packages using dnf.${no_color}"
        sudo dnf install sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia
    elif [ -x "$(command -v zypper)" ];
    then
        echo -e "${green}[*] Installing packages using zypper.${no_color}"
        sudo zypper install sddm-qt6 libQt6Svg6 qt6-virtualkeyboard qt6-virtualkeyboard-imports qt6-multimedia qt6-multimedia-imports
    else
        echo -e "${red}[*] FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install dependencies.">&2;
    fi
}

git_clone(){
    umask 022
    echo -e "${green}[*] Cloning theme to $path_to_git_clone.${no_color}"
    [ -d "$path_to_git_clone"/sddm-astronaut-theme ] && sudo mv "$path_to_git_clone"/sddm-astronaut-theme "$path_to_git_clone"/sddm-astronaut-theme_$date && echo -e "${green}[*] Old configs detected in $path_to_git_clone, backing up.${no_color}"
    git clone -b master --depth 1 https://github.com/keyitdev/sddm-astronaut-theme.git "$path_to_git_clone"/sddm-astronaut-theme
}

copy_files(){
    umask 022
    echo -e "${green}[*] Coping theme from $path_to_git_clone to /usr/share/sddm/themes/.${no_color}"
    [ -d /usr/share/sddm/themes/sddm-astronaut-theme ] && sudo mv /usr/share/sddm/themes/sddm-astronaut-theme /usr/share/sddm/themes/sddm-astronaut-theme_$date && echo -e "${green}[*] Old configs detected in /usr/share/sddm/themes/sddm-astronaut-theme, backing up.${no_color}"
    sudo mkdir -p /usr/share/sddm/themes/sddm-astronaut-theme
    sudo cp -r "$path_to_git_clone"/sddm-astronaut-theme/* /usr/share/sddm/themes/sddm-astronaut-theme
    sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
    echo -e "${green}[*] Setting up theme.${no_color}"
    echo "[Theme]
    Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf
    echo "[General]
    InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf
}

select_theme(){
    path_to_metadata="/usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop"
    text="ConfigFile=Themes/"

    line=$(grep $text "$path_to_metadata")

    themes="astronaut black_hole cyberpunk hyprland_kath jake_the_dog japanese_aesthetic pixel_sakura pixel_sakura_static post-apocalyptic_hacker purple_leaves"
    
    echo -e "${green}[*] Select theme (enter number e.g. astronaut - 1).${no_color}"
    echo -e "${green}[*] 0. Other (choose if you created your own theme)."
    echo -e "${green}[*] 1. Astronaut                   2. Black hole${no_color}"
    echo -e "${green}[*] 3. Cyberpunk                   4. Hyprland Kath (animated)${no_color}"
    echo -e "${green}[*] 5. Jake the dog (animated)     6. Japanese aesthetic${no_color}"
    echo -e "${green}[*] 7. Pixel sakura (animated)     8. Pixel sakura (static)${no_color}"
    echo -e "${green}[*] 9. Post-apocalyptic hacker    10. Purple leaves${no_color}"
    read -p "[*] Your choice: " new_number
    
    if [ "$new_number" -eq 0 ] 2>/dev/null;then
        echo -e "${green}[*] Enter name of the config file (without .conf).${no_color}"
        read -p "[*] Theme name: " answer
        selected_theme="$answer"
    elif [ "$new_number" -ge 1 ] 2>/dev/null && [ "$new_number" -le 10 ] 2>/dev/null; then
        set -- $themes
        selected_theme=$(echo "$@" | cut -d ' ' -f $(("new_number")))
        echo -e "${green}[*] You selected: $selected_theme ${no_color}"
    else
        echo -e "${red}[*] Error: invalid number or input.${no_color}"
        exit
    fi

    modified_line="$text$selected_theme.conf"

    sudo sed -i "s|^$text.*|$modified_line|" $path_to_metadata
    echo -e "${green}[*] Changed: $line -> $modified_line${no_color}"
}

while true; do
    clear
    echo -e "${green}sddm-astronaut-theme made by Keyitdev${no_color}"
    echo -e "${green}[*] Choose option.${no_color}"
    echo -e "1. All of the below."
    echo -e "2. Install dependencies with package manager."
    echo -e "3. Clone theme from github.com to $path_to_git_clone."
    echo -e "4. Copy theme from $path_to_git_clone to /usr/share/sddm/themes/."
    echo -e "5. Select theme (/usr/share/sddm/themes/)."
    echo -e "6. Preview the set theme (/usr/share/sddm/themes/)."
    echo -e "7. Exit."
    read -p "[*] Your choice: " x
    case $x in
        [1]* ) install_dependencies; git_clone; copy_files; select_theme; exit;;
        [2]* ) install_dependencies; exit;;
        [3]* ) git_clone; exit;;
        [4]* ) copy_files; exit;;
        [5]* ) select_theme; exit;;
        [6]* ) sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme/; exit;;
        [7]* ) exit;;
        * )  echo -e "${red}[*] Error: invalid number or input.${no_color}";;
    esac
done
