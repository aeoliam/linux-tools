# LINUX TOOLS

Bash script tools for Linux.<br>
Specifically for Debian/Ubuntu-based Linux distributions.

## Script

- [cleanup.sh](/cleanup.sh)
<br>Perform _apt_ / _apt-get_ `update`, `upgrade` ,`full-upgrade`, `dist-upgrade`, `clean`, `auto-clean` and `auto-remove` commands.

- [installer.sh](/installer.sh)
<br>Install Linux applications. (Selectable)<br>
<br>List of applications on this command are basic and my frequently used applications.

- [uninstaller.sh](/uninstaller.sh)
<br>Uninstall Linux applications. (Selectable)<br>
<br>List of applications on this command are mostly prebuilt and rarely used.

- [spotify.sh](/spotify.sh)
<br>Install Spotify and Spicetify just by executing this script. Make it ready-to-play, so you don't have to execute any commands manually. Just open Spotify and listen to a song peacefully after executed this script.<br>
<br>Spicetify v2.9.9 will be used since Spotify for Debian/Ubuntu stuck at v1.1.84.

- [deb.sh](/deb_install.sh)
<br>This script will install all the `.deb` files located in `/Downloads` folder.
<br><br>You can also specify the `.deb` file by executing the following command:
  ```bash
  ./deb.sh install 'filename'
  
  # File must be located at /Downloads folder.

  # You can install it without specify the file name.
  # e.g. file name is 'code_1.69.2-1658162013_amd64.deb'
  # you can execute:
  ./deb.sh install 'code'
  ```