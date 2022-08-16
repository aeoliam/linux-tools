#!/bin/bash
# by @aeoliam

##################################################
# FUNCTIONS
##################################################

unistall_xfce4() {
	echo -e "This will remove & replace some xfce4 packages and dependencies." && sleep 0.3
	echo -e "for more information, see xfce4.txt" && sleep 0.5
	echo -e "Are you sure? [Y/n]"
	read XFCE
	{ [ "$XFCE" == "Y"] || [ "$XFCE" == "y" ]; } && {
		sudo apt -y update
		sudo apt-get -y purge --auto-remove 'xterm'
		sudo apt-get -y purge --auto-remove 'xarchiver'
		sudo apt-get -y purge --auto-remove 'xburn'
		sudo apt-get -y purge --auto-remove 'elementary-xfce-icon-theme'
		sudo apt-get -y purge --auto-remove 'tango-icon-theme'
		sudo apt-get -y purge --auto-remove 'fonts-*'
		sudo apt-get -y purge --auto-remove '*libreoffice*'
		sudo apt-get -y purge --auto-remove '*thunderbird*'
		sudo apt-get -y purge --auto-remove 'vim*'; sudo apt-get -y purge --auto-remove 'xxd'
		# bluetooth
		sudo apt -y install 'bluetooth'
		sudo apt -y install 'blueman'
		# image viewer
		sudo apt -y install 'ristretto'
		# archive manager
		sudo apt -y install 'engrampa'
		# media player
		sudo apt -y install 'vlc'
		# text editor
		sudo apt -y install 'mousepad'
		# compatibility fonts
		sudo apt -y install 'fonts-noto-*'
		# fira code fonts
		sudo apt -y install 'fonts-firacode'
	} || return 1
}
uninstall_firefox() {
	sudo apt -y update && { sudo apt-get -y purge --auto-remove '*firefox*'; } || return 1
	sudo snap remove 'firefox' && sudo rm -rf /root/snap/firefox
}
uninstall_thunderbird() {
	sudo apt -y update && { sudo apt-get -y purge --auto-remove '*thunderbird*'; } || return 1
}
uninstall_libreoffice() {
	sudo apt -y update && { sudo apt-get -y purge --auto-remove '*libreoffice*'; } || return 1
}
uninstall_vim() {
	sudo apt -y update && { sudo apt-get -y purge --auto-remove 'vim*'; sudo apt-get -y purge --auto-remove 'xxd'; } || return 1
}
uninstall_chrome() {
	sudo apt -y update && { sudo apt-get -y purge --auto-remove 'google-chrome-*'; } || return 1
}
uninstall_fonts() {
	sudo apt -y update && { sudo apt-get -y purge --auto-remove 'fonts-*'; } || return 1
}
uninstall_all() {
	uninstall_firefox
	uninstall_thunderbird
	uninstall_libreoffice
	uninstall_chrome
}

##################################################
# CLI
##################################################

echo -e "────────────────────────────────────────" && sleep 0.5
echo -e "Package list:"
PKGLIST="
[1]:Firefox
[2]:Thunderbird
[3]:LibreOffice
[4]:Vim
[5]:Chrome
[a]:AllPackagesAbove
[x]:xfce4
[f]:Fonts
[c]:Cancel
"
for PKG in $PKGLIST; do echo -e "$PKG" && sleep 0.3; done
echo -e "Which package's you wish to uninstall?"
read PACKAGES
{
	[ "$PACKAGES" == "1" ] && uninstall_firefox
	[ "$PACKAGES" == "2" ] && uninstall_thunderbird
	[ "$PACKAGES" == "3" ] && uninstall_libreoffice
	[ "$PACKAGES" == "4" ] && uninstall_chrome
	[ "$PACKAGES" == "a" ] && uninstall_all
	[ "$PACKAGES" == "f" ] && uninstall_fonts
	[ "$PACKAGES" == "x" ] && uninstall_xfce4
	wait
}

##################################################
# END OF SCRIPT
##################################################