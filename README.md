# sddm-astronaut-theme

A theme for the [SDDM login manager](https://github.com/sddm/sddm) based on [`Sugar Dark for SDDM`](https://github.com/MarianArlt/sddm-sugar-dark).
Screen resolution: 1080p.

### Preview
![Preview](./Previews/preview.png)

### Dependencies

```sh
qt5-graphicaleffects qt5-quickcontrols2 qt5-svg sddm
```

### Install

1. Clone this repository, copy fonts to `/usr/share/fonts/`:

   ```sh
   sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
   sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
   ```

2. Then edit `/etc/sddm.conf`, so that it looks like this:

    ```sh
    echo "[Theme]
    Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf
    ```

### Credits

Based on the theme [`Sugar Dark for SDDM`](https://github.com/MarianArlt/sddm-sugar-dark) by **MarianArlt**.

### License

Distributed under the [GPLv3+](https://www.gnu.org/licenses/gpl-3.0.html) License.
