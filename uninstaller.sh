#!/bin/bash
# by @aeoliam

##################################################
# FUNCTIONS
##################################################

ui_print() { printf "${1}\n"; sleep 0.5; }
apt_remove()
{
	ui_print "Updating databases..." && sudo apt -y update &>/dev/null
	sudo apt-get -y purge --auto-remove "$1"
	[ -z "$2" ] || sudo apt-get -y purge --auto-remove "$2"
	[ -z "$3" ] || sudo apt-get -y purge --auto-remove "$3"
	wait; }
snap_remove()
{
	local TARGET=$(printf "$1" | sed 's/*//g')
	sudo snap remove "$1" && sudo find / -type 'f,d' -name "$TARGET" | while read leftover; do rm -fr "$leftover" 2>/dev/null; done
}
unistall_xfce4()
{
	ui_print "This will remove & replace some xfce4 packages and dependencies."
	ui_print "Are you sure? [Y/n]"
	read XFCE
	if [ "$XFCE" == "y"] || [ "$XFCE" == "Y" ]; then
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
		local PKGLIST=$(printf "$PKGLIST" | grep -v '#')
		for PKG in $PKGLIST; do apt_remove "$PKG"; done
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
		local PKGLIST=$(printf "$PKGLIST" | grp -v '#')
		for PKG in $PKGLIST; do sudo apt -y update; sudo apt -y install "$PKG"; done
	elif [ "$XFCE" == "n" ] || [ "$XFCE" == "N" ]; then
		return 0
	else
		return 1
	fi
}

##################################################
# CLI
##################################################

ui_print "────────────────────────────────────────" && sleep 0.5
ui_print "Package list:"
PKGLIST="
[1]:Firefox
[2]:Thunderbird
[3]:LibreOffice
[4]:Vim
[5]:Chrome
[5]:VirtualBox
[f]:Fonts
[x]:xfce4
[c]:Cancel
"
for PKG in $PKGLIST; do ui_print "$PKG" && sleep 0.3; done
ui_print "Which package's you wish to uninstall?"
read PACKAGE
case $PACKAGE in
	1) apt_remove '*firefox*' || snap_remove '*firefox*' ;;
	2) apt_remove '*thunderbird*' || apt_remove '*thunderbird*' ;;
	3) apt_remove '*libreoffice*' || snap_remove '*libreoffice*' ;;
	4) { apt_remove 'vim*' && apt_remove 'xxd'; } || { snap_remove 'vim*' && snap_remove 'xxd'; } ;;
	5) apt_remove 'google-chrome*' || snap_remove 'google-chrome*' ;;
	6) apt_remove 'dkms' 'virtualbox' 'virtualbox-ext-pack' || snap_remove 'dkms' 'virtualbox' 'virtualbox-ext-pack' ;;
	f) apt_remove 'fonts-*' || snap_remove 'fonts-*' ;;
	x) xfce4 ;;
	c) return 0 ;;
	*) ui_print 'Please input one of the options above!'; return 1 ;;
esac
wait

# perform cleanupe
ui_print "Cleaning  Up.."
curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/cleanup.sh &>/dev/null | sh
wait

# detect whether reboot is required or not
curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/reboot_required.sh | sh

##################################################
# END OF SCRIPT
##################################################