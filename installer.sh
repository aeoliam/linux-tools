#!/bin/bash
# by @aeoliam

##################################################
# FUNCTIONS
##################################################

install_extra() {
	echo -e "\nDo you also want to install ${1}? [Y/n]"
	read EXTRA
	{ [ "$EXTRA" == "y" ] || [ "$EXTRA" == "Y" ] } && { sudo apt -y install "$1"; } || return 1
}
install_codecs() {
	sudo add-apt-repository multiverse
	sudo apt -y update
	sudo apt -y install 'ubuntu-restricted-extras'
	install_extra 'vlc' && install_extra 'vlc-plugin-*'
}
#install_spotify() {;}
install_chrome() {
	local DOWNDIR="${HOME}/Downloads"
	local DEBURL='https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
	local DEBFILE="${DOWNDIR}/${DEBURL##*/}"
	[ -f "$DEBFILE" ] || wget --directory-prefix="$DOWNDIR" "$DEBURL" && wait
	sudo apt -y update && { sudo apt -y install . "${DOWNDIR}/${DEBFILE}" || sudo dpkg -i "${DOWNDIR}/${DEBFILE}"; } || return 1
	[ -f "$DOWNDIR/$DEBFILE" ] && rm -f $DOWNDIR/$DEBFILE
}
install_vbox() {
	sudo apt -y update && {
		sudo apt -y install 'dkms'
		sudo apt -y install 'virtualbox'
		sudo apt -y install 'virtualbox-ext-pack'
	} || return 1
}
install_mousepad() {
	sudo apt -y update && { sudo apt -y install 'mousepad'; } || return 1
}
install_nautilusadmin() {
	sudo apt -y update && { sudo apt -y install 'nautilus-admin'; } || return 1
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
	case $FONT in
		1) install_fonts_noto ;;
		2) install_fonts_firacode ;;
		3) install_fonts_lato ;;
		4) install_fonts_ibmplex ;;
		c) exit 0 ;;
		*) echo -e 'Please input one of the options above!'; exit 1 ;;
	esac
}
install_fonts_noto() {
	echo -e "────────────────────────────────────────" && sleep 0.5
	echo -e "Noto's Fonts list:"
	local NOTOLIST="
	[0]:Full(Recommended)
	[1]:NotoCore
	[2]:NotoUI
	[4]:NotoHint
	[3]:NotoMono
	[5]:NotoColorEmoji
	[6]:NotoChineseJapaneseKorean
	[c]:Cancel
	"
	for NOTOFONTS in $NOTOLIST; do echo -e "$NOTOFONTS" && sleep 0.3; done
	echo -e "Which Noto's Fonts you wish to install?"
	read NOTO
	case $NOTO in
		0) sudo apt -y update && sudo apt -y install 'fonts-noto*' ;;
		1) sudo apt -y update && sudo apt -y install 'fonts-noto-core' && install_extra "fonts-noto-extra" ;;
		2) sudo apt -y update && sudo apt -y install 'fonts-noto-ui-core' && install_extra "fonts-noto-ui-extra" ;;
		3) sudo apt -y update && sudo apt -y install 'fonts-noto-hinted' 'fonts-noto-unhinted' ;;
		4) sudo apt -y update && sudo apt -y install 'fonts-noto-mono' ;;
		5) sudo apt -y update && sudo apt -y install 'fonts-noto-color-emoji' ;;
		6) sudo apt -y update && sudo apt -y install 'fonts-noto-cjk' && install_extra "fonts-noto-cjk-extra" ;;
		c) exit 0 ;;
		*) echo -e 'Please input one of the options above!'; exit 1 ;;
	esac
}
install_fonts_lato() {
	sudo apt -y update && { sudo apt -y install 'fonts-lato'; }
}
install_fonts_firacode() {
	case $OS_ID in
		"ubuntu") sudo add-apt-repository -y universe ;;
		"debian") sudo add-apt-repository -y contrib ;;
	esac
	sudo apt -y update && sudo apt -y install fonts-firacode
}
install_fonts_ibmplex() {
	sudo apt -y update && { sudo apt -y install 'fonts-ibm-plex'; }
}

##################################################
# CLI
##################################################

echo -e "────────────────────────────────────────" && sleep 0.5
echo -e "Package list:"
PKGLIST="
[1]:MultimediaCodecs(Ubuntu)
[2]:Spotify+Spicetify
[3]:Chrome
[4]:Mousepad
[5]:Nautilus-Admin
[f]:Fonts(Selection)
[c]:Cancel
"
for PKG in $PKGLIST; do echo -e "$PKG" && sleep 0.3; done
echo -e "Which package's you wish to install?"
read PACKAGE
case $PACKAGE in
	1) install_codecs ;;
	2) install_spotify ;;
	3) install_chrome ;;
	4) install_mousepad ;;
	5) install_nautilusadmin ;;
	f) install_fonts ;;
	c) exit 0 ;;
	*) echo -e 'Please input one of the options above!'; exit 1 ;;
esac
wait

##################################################
# END OF SCRIPT
##################################################