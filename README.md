# Linux Tools

Bash script tools for Linux, specifically for Debian/Ubuntu-based Linux distributions.

Make it easier just by running one script than executing commands one-by-one.

## Description & Usage

- [cleanup.sh](/cleanup.sh)
<br>Perform **apt** `update`, `upgrade`, `full-upgrade`, `dist-upgrade`, `clean`, `auto-clean` and `auto-remove` commands.<br>
<br>Usage:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/cleanup.sh | sh
  ```

- [installer.sh](/installer.sh)
<br>Install Linux applications. (Selectable)<br>
<br>List of applications on this command are basic and my most frequently used applications.<br>
(Spotify and Spicetify are also included in this script.)<br>
<br>Usage:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/installer.sh | sh
  ```

- [uninstaller.sh](/uninstaller.sh)
<br>Uninstall Linux applications. (Selectable)<br>
<br>List of applications on this command are mostly prebuilt and rarely used applications.<br>
<br>Usage:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/uninstaller.sh | sh
  ```

- [spotify.sh](/spotify.sh)
<br>Install Spotify and Spicetify just by executing this script. Make it ready-to-play, so you don't have to execute any commands manually. Just open Spotify and listen to a song peacefully after executed this script.<br>
<br>Spicetify v2.9.9 will be used since Spotify for Debian/Ubuntu stuck at v1.1.84.<br>
<br>Usage:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/spotify.sh | sh
  ```

- [deb_install.sh](/deb_install.sh)
<br>This script will install all the `.deb` files located in `/Downloads` folder.<br>
<br>Usage:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/deb_install.sh | sh
  ```

#### Advanced Usage
( _can be used anytime without internet connection_ )

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