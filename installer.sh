#!/bin/bash
# by @aeoliam

##################################################
# FUNCTIONS
##################################################

install_extra() {
	echo -e "\nDo you also want to install $1? [Y/n]"
	read EXTRA
	if [ "$EXTRA" == "y" ] || [ "$EXTRA" == "Y" ]; then
		sudo apt -y install "$1"
	else
		return 1
	fi
}
install_codecs() {
	sudo add-apt-repository multiverse
	sudo apt -y update
	sudo apt -y install ubuntu-restricted-extras
	install_extra "vlc" && install_extra "vlc-plugin-*"
}
install_fonts() {
	echo -e "────────────────────────────────────────" && sleep 0.5
	echo -e "Fonts list:"
	local FONTSLIST="
	[1]:Noto(Selection)
	[2]:FiraCode
	[3]:Lato
	[4]:IBM-Plex
	[c]:Cancel
	"
	for FONTS in $FONTSLIST; do echo -e "$FONTS" && sleep 0.3; done
	echo -e "Which fonts you wish to install?"
	read FONT
	[ "$FONT" == "1" ] && install_fonts_noto
	[ "$FONT" == "2" ] && install_fonts_firacode
	[ "$FONT" == "3" ] && install_fonts_lato
	[ "$FONT" == "4" ] && install_fonts_ibm_plex
}
install_fonts_noto() {
	echo -e "────────────────────────────────────────" && sleep 0.5
	echo -e "Noto fonts list:"
	local NOTOLIST="
	[0]:Noto(FullNotoFonts)
	[1]:NotoCore
	[2]:NotoUI
	[4]:NotoHint
	[3]:NotoMono
	[5]:NotoEmoji(EmojiSupport)
	[6]:NotoCJK(Chinese,Japanese,Korean)
	[c]:Cancel
	"
	for NOTOFONTS in $NOTOLIST; do echo -e "$NOTOFONTS" && sleep 0.3; done
	echo -e "Which Noto fonts you wish to install?"
	read NOTO
	[ "$NOTO" == "0" ] && { sudo apt -y update && sudo apt -y install 'fonts-noto*'; }
	[ "$NOTO" == "1" ] && { sudo apt -y update && sudo apt -y install 'fonts-noto-core' && install_extra "fonts-noto-extra"; }
	[ "$NOTO" == "2" ] && { sudo apt -y update && sudo apt -y install 'fonts-noto-ui-core' && install_extra "fonts-noto-ui-extra"; }
	[ "$NOTO" == "3" ] && { sudo apt -y update && sudo apt -y install 'fonts-noto-hinted' 'fonts-noto-unhinted'; }
	[ "$NOTO" == "4" ] && { sudo apt -y update && sudo apt -y install 'fonts-noto-mono'; }
	[ "$NOTO" == "5" ] && { sudo apt -y update && sudo apt -y install 'fonts-noto-color-emoji'; }
	[ "$NOTO" == "6" ] && { sudo apt -y update && sudo apt -y install 'fonts-noto-cjk' && install_extra "fonts-noto-cjk-extra"; }
}
install_fonts_lato() {
	sudo apt -y update && sudo apt -y install 'fonts-lato'
}
install_fonts_firacode() {
	case $OS_ID in
		"ubuntu") sudo add-apt-repository -y universe ;;
		"debian") sudo add-apt-repository -y contrib ;;
		*) echo -e "Your system ($OS_ID) is not supported, \nthis script only available for Debian/Ubuntu based system."; exit 1 ;;
	esac
	sudo apt -y update && sudo apt -y install fonts-firacode
}
install_chrome() {
	local DOWNDIR="$HOME/Downloads"
	local DEBURL='https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
	# check if the file exists / already downloaded
	DEBFILE=${DEBURL##*/}
	[ -f "$DOWNDIR/$DEBFILE" ] || wget --directory-prefix="$DOWNDIR" $DEBURL
	# begin installation
	sudo apt -y update && { sudo apt -y install ~/${DOWNDIR##*/}/$DEBFILE || sudo dpkg -i $DOWNDIR/$DEBFILE; }
	# remove leftover file after installation
	[ -f "$DOWNDIR/$DEBFILE" ] && rm -f $DOWNDIR/$DEBFILE
}
install_mousepad() {
	sudo apt -y update && sudo apt -y install mousepad
}
install_nautilusadmin() {
	sudo apt -y update && sudo apt -y install nautilus-admin
}

##################################################
# CLI
##################################################

echo -e "────────────────────────────────────────" && sleep 0.5
echo -e "Package list:"
PKGLIST="
[1]:MultimediaCodecs
[2]:Spotify+Spicetify
[3]:Chrome
[4]:Mousepad(TextEditor)
[5]:Nautilus-Admin
[f]:Fonts(Selection)
[c]:Cancel
"
for PKG in $PKGLIST; do echo -e "$PKG" && sleep 0.3; done
echo -e "Which package's you wish to install?"
read PACKAGES
{
	[ "$PACKAGES" == "1" ] && install_codecs
	[ "$PACKAGES" == "2" ] && install_spotify
	[ "$PACKAGES" == "3" ] && install_chrome
	[ "$PACKAGES" == "4" ] && install_mousepad
	[ "$PACKAGES" == "5" ] && install_nautilusadmin
	[ "$PACKAGES" == "f" ] && install_fonts
}

##################################################
# END OF SCRIPT
##################################################