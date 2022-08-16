#!/bin/bash
# by @aeoliam

##################################################
# FUNCTIONS
##################################################

apt_install() {
	sudo apt -y update
	sudo apt -y install "$1" || sudo dpkg -i "$1"
	[ -z "$2" ] && apt_install_extra "$2"
	[ -z "$3" ] && apt_install_extra "$3"
	wait; }
apt_install_extra() {
	echo -e "\nDo you also want to install ${1}? [Y/n]"
	read PACKAGE_EXTRA
	if [ "$PACKAGE_EXTRA" == "Y" ] || [ "$PACKAGE_EXTRA" == "y" ]; then sudo apt -y install "$1"; done; }
install_chrome() {
	local DOWNDIR="${HOME}/Downloads"
	local DEBURL='https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
	local DEBFILE="${DOWNDIR}/${DEBURL##*/}"
	[ -f "$DEBFILE" ] || wget --directory-prefix="$DOWNDIR" "$DEBURL" && wait
	apt_install "$DEBFILE"
	rm -f "$DEBFILE"; }
install_fonts() {
	echo -e "────────────────────────────────────────" && sleep 0.5
	echo -e "Fonts list:"
	local FONTSLIST="
	[1]:Noto(Selectable)
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
		3) apt_install 'fonts-lato' ;;
		4) apt_install 'fonts-ibm-plex' ;;
		c) exit 0 ;;
		*) echo -e 'Please input one of the options above!'; exit 1 ;;
	esac; }
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
		0) apt_install 'fonts-noto*' ;;
		1) apt_install 'fonts-noto-core' 'fonts-noto-extra' ;;
		2) apt_install 'fonts-noto-ui-core' 'fonts-noto-ui-extra' ;;
		3) apt_install 'fonts-noto-hinted' 'fonts-noto-unhinted' ;;
		4) apt_install 'fonts-noto-mono' ;;
		5) apt_install 'fonts-noto-color-emoji' ;;
		6) apt_install 'fonts-noto-cjk' 'fonts-noto-cjk-extra' ;;
		c) exit 0 ;;
		*) echo -e 'Please input one of the options above!'; exit 1 ;;
	esac; }
install_fonts_firacode() {
	curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/functions/prop.sh | sh
	local OS_ID=$(read_prop 'ID' '/etc/os-release')
	case $OS_ID in
		'ubuntu') sudo add-apt-repository -y universe ;;
		'debian') sudo add-apt-repository -y contrib ;;
	esac
	apt_install 'fonts-firacode'; }

##################################################
# CLI
##################################################

# perform cleanup
echo -e "Updating databases.."
curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/cleanup.sh | sh &>/dev/null
wait

echo -e "────────────────────────────────────────" && sleep 0.5
echo -e "Package list:"
PKGLIST="
[1]:Chrome
[2]:Spotify+Spicetify
[3]:VLC
[4]:Codecs(Ubuntu)
[5]:Mousepad
[6]:Nautilus-Admin
[7]:VirtualBox
[f]:Fonts(Selectable)
[c]:Cancel
"
for PKG in $PKGLIST; do echo -e "$PKG" && sleep 0.3; done
echo -e "Which package's you wish to install?"
read PACKAGE
case $PACKAGE in
	1) install_chrome ;;
	2) curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/spotify.sh | sh ;;
	3) apt_install 'vlc' 'vlc-plugin-*' ;;
	4) sudo add-apt-repository multiverse && apt_install 'ubuntu-restricted-extras' ;;
	5) apt_install 'mousepad' ;;
	6) apt_install 'nautilus-admin' ;;
	7) apt_install 'dkms' 'virtualbox' 'virtualbox-ext-pack' ;;
	f) install_fonts ;;
	c) exit 0 ;;
	*) echo -e 'Please input one of the options above!'; exit 1 ;;
esac
wait

# detect whether reboot is required or not
curl -fsSL https://raw.githubusercontent.com/aeoliam/linux-tools/master/reboot_required.sh | sh

##################################################
# END OF SCRIPT
##################################################