# Linux Tools

Bash script tools for Linux, specifically for `Debian/Ubuntu` based Linux distributions.

## Description & Usage
- [cleanup.sh](/cleanup.sh)
  <br>Perform **apt** `update`, `upgrade`, `full-upgrade`, `dist-upgrade`, `clean`, `auto-clean` and `auto-remove` commands.
  <br>
  <br>Usage:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/cleanup.sh | sh
  ```
- [installer.sh](/installer.sh)
  <br>Install Linux applications. _(Selectable)_
  <br>
  <br>* _List of applications in this script are custom (my most frequently used applications), it will not show all avaible applications._
  <br>* ( **Spotify** and **Spicetify** are also included in this script. )
  <br>
  <br>Usage:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/installer.sh | sh
  ```
- [uninstaller.sh](/uninstaller.sh)
  <br>Uninstall Linux applications. _(Selectable)_
  <br>
  <br>* _List of applications in this script are custom, it will not show all installed applications._
  <br>
  <br>Usage:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/uninstaller.sh | sh
  ```
- [spotify.sh](/spotify.sh)
  <br>A simple script to install **Spotify** and **Spicetify** along with it's dependencies. It will also configure the permissions, **$PATH**, and spicetify config.
  <br>
  <br>* **Spicetify v2.9.9** will be used since **Spotify** for Linux stuck at **v1.1.84.**
  <br>
  <br>Usage:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/spotify.sh | sh
  ```
- [deb_install.sh](/deb_install.sh)
  <br>This script will install all the `.deb` files located in `/Downloads` folder.
  <br>
  <br>Usage:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/deb_install.sh | sh
  ```
- [prop_tools.sh](/prop_tools.sh)
  <br>Read/Write a file's property. _(Selectable)_
  <br>
  <br>i.e. you want to know the ID's of your machine.
  <br>  - input: `r` (to read the property)
  <br>  - input: `ID` (property name)
  <br>  - input: `/etc/os-relese` (file path)
  <br>  - output: `ubuntu` (because I'm using Ubuntu)
  <br>* If you want to write property just input `w` and input property's value after input property's name.
  <br>
  <br>Usage:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/prop_tools.sh | sh
  ```
- [shutdown_timer.sh](/shutdown_timer.sh)
  <br>Automatically shutdown your computer on specific times.
  <br>
  <br>* _Only work on **xfce** Desktop Environment._
  <br>
  <br>Usage:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/shutdown_timer.sh | sh
  ```
- [reboot_required.sh](/reboot_required.sh)
  <br>Sometimes you need to restart/reboot your computer after performing an update/upgrade or any operation that need reboot to working. Use this script to detect whether reboot is required or not.
  <br>
  <br>Usage:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/reboot_required.sh | sh
  ```

#### Advanced Usage
```bash
wget <url>
chmod +x <script-name>.sh
./<script-name>.sh
```
**Example**
```bash
wget https://raw.githubusercontent.com/aeoliam/linux-tools/master/cleanup.sh
chmod +x cleanup.sh
./cleanup.sh
```