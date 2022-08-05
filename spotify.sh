#!/bin/bash

##################################################
# SETUP
##################################################

# check dependencies
command -v curl >/dev/null || { echo "[curl] isn't installed!"; sudo apt -y update && sudo apt -y install curl; }
command -v wget >/dev/null || { echo "[grep] isn't installed!"; sudo apt -y update && sudo apt -y install wget; }
command -v tar >/dev/null || { echo "[tar] isn't installed!"; sudo apt -y update && sudo apt -y install tar; }
command -v unzip >/dev/null || { echo "[unzip] isn't installed!"; sudo apt -y update && sudo apt -y install unzip; }

##################################################
# INSTALL SPOTIFY
##################################################

SPDIR='/usr/share/spotify'
SPCONF="$HOME/.config/spotify" || SPCONF='~/.config/spotify'
SPPREFS="$SPCONF/prefs"

# check wether spotify is installed or not
if [ -z "$(command -v spotify)" ]; then
	# add spotify pubkey to apt
	curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
	# add spotify repository to apt sources
	sudo echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.dspotify.list
	# finally install spotify-client
	sudo apt -y update && sudo apt -y install 'spotify-client'
	# sleep to make sure commands are executed properly
	sleep 3
fi

# create spotify (linked) shortcut (if not exist)
if [ ! -f "/usr/share/applications/spotify.desktop" ]; then
	sudo ln -s /usr/share/spotify/spotify.desktop /usrshare/applications/
	# refresh xfce panel
	[ -z "$(command -v xfce4-panel)" ] || xfce4-panel -r
fi

# set spotify permissions
sudo chmod a+rw -R "$SPDIR"

# sleep to make sure commands are executed properly
sleep 3

##################################################
# INSTALL SPICETIFY
##################################################

SPICETIFY=$(command -v spicetify)

SPCDIR="$HOME/.spicetify" || SPCDIR='~/.spicetify'
SPCCONF="$HOME/.config/spicetify" || SPCCONF='~/.config/spicetify'

# check platform
case $(uname -sm) in
	"Darwin x86_64") target='darwin-amd64' ;;
	"Darwin arm64") target='darwin-arm64' ;;
	"Linux x86_64") target='linux-amd64' ;;
	"Linux aarch64") target='linux-arm64' ;;
	*) echo "Unsupported platform $(uname -sm). Only avaible for x86_64 and arm64 binaries for Linux and Darwin."; exit 1 ;;
esac

# version
version='v2.9.9'

DOWNDIR="$HOME/Downloads" || DOWNDIR='~/Downloads'
SPCURL="https://github.com/spicetify/spicetify-cli/releases/download/$version/spicetify-${version#v}-$target.tar.gz"
SPCFILE="$DOWNDIR/${SPCURL##*/}"

# remove previously installed spicetify (if installed)
[ -z "$SPICETIFY" ] || spicetify restore
[ -d "$SPCDIR" ] && sudo rm -rf "$SPCDIR"
[ -d "$SPCCONF" ] && sudo rm -rf "$SPCCONF"

# fetch & download spicetify
wget --directory-prefix="$DOWNDIR" "$SPCURL"

# sleep to make sure commands are executed properly
sleep 3

# create spicetify directory
sudo mkdir -p "$SPCDIR"

# extract spicetify archive, and remove it after extracted
sudo tar -zxf "$SPCFILE" -C "$SPCDIR" && rm -f "$SPCFILE"

# set spicetify permissions recursively
sudo chmod a+rwx -R "$SPCDIR"

# remove & add spicetify to $PATH
if [ -f "~/.bash_profile" ] || [ -f "~/.bash_login" ]; then
	grep -v '.spicetify' $HOME/.bashrc > $HOME/.bashrc.tmp && cp -af $HOME/.bashrc.tmp $HOME/.bashrc
	echo 'export PATH="$PATH:$HOME/.spicetify"' >> $HOME/.bashrc && source $HOME/.bashrc
else
	grep -v '.spicetify' $HOME/.profile > $HOME/.profile.tmp && cp -af $HOME/.profile.tmp $HOME/.profile
	echo 'export PATH="$PATH:$HOME/.spicetify"' >> $HOME/.profile && source $HOME/.profile
fi

# set executable permissions & run spicetify
sudo chmod a+x "$SPCDIR/spicetify" && spicetify

# sleep to make sure commands are executed properly
sleep 3

##################################################
# SPICETIFY CONFIGURATION
##################################################

# backup spotify
spicetify backup apply

# apply theme config
spicetify config inject_css 1 overwrite_assets 1 replace_colors 1

# additional config
spicetify config experimental_features 0 check_spicetify_upgrade 0

# lyrics integration
spicetify config extensions popupLyrics.js
spicetify config custom_apps lyrics-plus

# install spicetify marketplace
curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh

# apply configuration
spicetify apply

# sleep to make sure commands are executed properly
sleep 3

##################################################
# END OF SCRIPT
##################################################