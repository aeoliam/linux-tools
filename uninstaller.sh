#!/bin/bash
# by @aeoliam

##################################################
# from cleanup.sh
##################################################

clean_up() {
	sudo apt -y update
	sudo apt -y upgrade
	sudo apt -y full-upgrade
	sudo apt-get -y dist-upgrade
	sudo apt-get -y clean
	sudo apt-get -y autoclean
	sudo apt-get -y autoremove
}

##################################################
# packgage functions
##################################################

unistall_xfce4() {
	echo -e "This will remove/replace some xfce4 packages and dependencies." && sleep 0.3
	echo -e "for more information, see xfce4.txt" && sleep 0.5
	echo -e "Are you sure? [Y/n]"
	read XFCE
	{ [ "$XFCE" == "Y"] || [ "$XFCE" == "y" ] } && { sudo apt -y update
	sudo apt-get -y purge --auto-remove 'xterm'
	sudo apt-get -y purge --auto-remove 'xarchiver'
	sudo apt-get -y purge --auto-remove 'xburn'
	# theme
	sudo apt-get -y purge --auto-remove 'elementary-xfce-icon-theme'
	sudo apt-get -y purge --auto-remove 'tango-icon-theme'
	sudo apt-get -y purge --auto-remove '*libreoffice*'
	sudo apt-get -y purge --auto-remove '*thunderbird*'
	sudo apt-get -y purge --auto-remove 'vim*'
	sudo apt-get -y purge --auto-remove 'fonts-*'
	# replace
	# image viewer
	sudo apt -y install 'ristretto'
	# archive manager
	sudo apt -y install 'engrampa'
	# media player
	sudo apt -y install 'vlc'
	# text editor
	sudo apt -y install --reinstall 'mousepad'
	# Chinese, Japanese and Korean fonts support
	sudo apt -y install 'fonts-noto-cjk'
	# emoji fonts support
	sudo apt -y install 'fonts-noto-color-emoji'
	}
}

uninstall_vim() {
	sudo apt -y update && sudo apt-get -y purge --auto-remove 'vim*'
}

uninstall_firefox() {
	sudo apt -y update && sudo apt-get -y purge --auto-remove '*firefox*'
	sudo snap remove 'firefox' && sudo rm -rf /root/snap/firefox
}
uninstall_libreoffice() {
	sudo apt -y update && sudo apt-get -y purge --auto-remove '*libreoffice*'
}
uninstall_thunderbird() {
	sudo apt -y update && sudo apt-get -y purge --auto-remove '*thunderbird*'
}
uninstall_chrome() {
	sudo apt -y update && sudo apt-get -y purge --auto-remove 'google-chrome-*'
}
uninstall_xterm() {
	sudo apt -y update && sudo apt-get -y purge --auto-remove 'xterm'
}
uninstall_fonts() {
	sudo apt -y update && sudo apt-get -y purge --auto-remove 'fonts-*'
}
uninstall_all() {
	uninstall_firefox
	uninstall_libreoffice
	uninstall_thunderbird
	uninstall_xterm
}

##################################################
# script
##################################################

echo -e "────────────────────────────────────────" && sleep 0.5
echo -e "Package list:"
PKGLIST="
[1]:Firefox
[2]:LibreOffice
[3]:Thunderbird
[a]:AllPackagesAbove
[x]:xfce4
[f]:AllFonts
[c]:Cancel
"
for PKG in $PKGLIST; do echo -e "$PKG" && sleep 0.3; done
echo -e "Which package's you wish to install?"
read PACKAGES
{
	[ "$PACKAGES" == "1" ] && uninstall_firefox
	[ "$PACKAGES" == "2" ] && uninstall_libreoffice
	[ "$PACKAGES" == "3" ] && uninstall_thunderbird
	[ "$PACKAGES" == "4" ] && uninstall_xterm
	[ "$PACKAGES" == "x" ] && uninstall_xfce4
	[ "$PACKAGES" == "a" ] && uninstall_all
} & clean_up

##################################################
# end
##################################################