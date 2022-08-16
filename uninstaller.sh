#!/bin/bash
# by @aeoliam

##################################################
# FUNCTIONS
##################################################

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
uninstall_vbox() {
	sudo apt -y update && {
		sudo apt-get -y purge --auto-remove 'dkms'
		sudo apt-get -y purge --auto-remove 'virtualbox'
		sudo apt-get -y purge --auto-remove 'virtualbox-ext-pack'
	} || return 1
}
uninstall_fonts() {
	sudo apt -y update && { sudo apt-get -y purge --auto-remove 'fonts-*'; } || return 1
}
unistall_xfce4() {
	echo -e "This will remove & replace some xfce4 packages and dependencies." && sleep 0.3
	echo -e "for more information, see xfce4.txt" && sleep 0.5
	echo -e "Are you sure? [Y/n]"
	read XFCE
	{ [ "$XFCE" == "Y"] || [ "$XFCE" == "y" ]; } && {
		sudo apt -y update
		local PKGLIST="
		# xfce4
		xterm
		xarchiver
		xburn
		# Icon Theme
		elementary-xfce-icon-theme
		tango-icon-theme
		# All Fonts
		fonts-*
		# Media Player
		parole*
		# LibreOffice
		*libreoffice*
		# Thunderbird
		*thunderbird*
		# Vim
		vim*
		xxd
		"
		local PKGLIST=$(echo "$PKGLIST" | grep -v '#')
		for PKG in $PKGLIST; do sudo apt-get purge --auto-remove "$PKG"; done
		PKGLIST="
		# Bluetooth
		bluetooth
		blueman
		# Image Viewer
		ristretto
		# Archive Manager
		engrampa
		# Media Player
		vlc
		# text editor
		mousepad
		# compatibility fonts
		fonts-noto-*
		# fira code fonts
		fonts-firacode
		"
		local PKGLIST=$(echo -n "$PKGLIST" | grp -v '#')
		for PKG in $PKGLIST; do sudo apt -y install "$PKG"; done
	} || return 1
}
uninstall_all() {
	uninstall_firefox
	uninstall_thunderbird
	uninstall_libreoffice
	unistall_vim
	uninstall_chrome
	uninstall_vbox
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
[5]:VirtualBox
[a]:AllPackagesAbove
[f]:Fonts
[x]:xfce4
[c]:Cancel
"
for PKG in $PKGLIST; do echo -e "$PKG" && sleep 0.3; done
echo -e "Which package's you wish to uninstall?"
read PACKAGE
case $PACKAGE in
	1) uninstall_firefox ;;
	2) uninstall_thunderbird ;;
	3) uninstall_libreoffice ;;
	4) uninstall_vim ;;
	5) uninstall_chrome ;;
	6) uninstall_vbox ;;
	a) uninstall_all ;;
	f) uninstall_fonts ;;
	x) uninstall_xfce4 ;;
	c) exit 0 ;;
	*) echo -e 'Please input one of the options above!'; exit 1 ;;
esac
wait

# perform cleanup
echo -e "Cleaning Up.."
curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/cleanup.sh | sh &>/dev/null
wait

# detect whether reboot is required or not
curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/reboot_required.sh | sh

##################################################
# END OF SCRIPT
##################################################