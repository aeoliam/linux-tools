#!/bin/bash

# check platform
case $(uname -sm) in
	"Darwin x86_64") target="darwin-amd64" ;;
	"Darwin arm64") target="darwin-arm64" ;;
	"Linux x86_64") target="linux-amd64" ;;
	"Linux aarch64") target="linux-arm64" ;;
	*) echo "Unsupported platform $(uname -sm). Only avaible for x86_64 and arm64 binaries for Linux and Darwin."; exit 1 ;;
esac

# check dependencies
command -v curl >/dev/null || { echo "[curl] isn't installed!"; sudo apt -y update && sudo apt -y install curl; }
command -v wget >/dev/null || { echo "[grep] isn't installed!"; sudo apt -y update && sudo apt -y install wget; }
command -v tar >/dev/null || { echo "[tar] isn't installed!"; sudo apt -y update && sudo apt -y install tar; }
command -v unzip >/dev/null || { echo "[unzip] isn't installed!"; sudo apt -y update && sudo apt -y install unzip; }

install_spotify() {
	local SPDIR="/usr/share/spotify"
	local SPCONF="$HOME/.config/spotify" || SPCONF='~/.config/spotify'
	local SPPREFS="$SPCONF/prefs"
	# remove previously installed spotify (if installed)
	sudo apt -y update && sudo apt-get -y purge --auto-remove spotify-client
	[ -d "$SPCONF" ] && rm -rf $SPCONF
	# install spotify package
		# add spotify pubkey to apt
		curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
		# add spotify repository to apt sources
		sudo echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
		# finally install spotify client
		sudo apt -y update && sudo apt -y install spotify-client
	# create spotify (linked) shortcut (if not exist)
	[ ! -f "/usr/share/applications/spotify.desktop" ] && sudo ln -s /usr/share/spotify/spotify.desktop /usr/share/applications/
	# set spotify permissions
	sudo chmod a+rw -R /usr/share/spotify
	# install spicetify package
	install_spicetify
}

install_spicetify() {
	local DOWNDIR="$HOME/Downloads"
	local SPCDIR="$HOME/.spicetify" || SPCDIR='~/.spicetify'
	local SPCCONF="$HOME/.config/spicetify" || SPCCONF='~/.config/spicetify'
	# remove previously installed spicetify (if installed)
	[ -d "$SPCDIR" ] && sudo rm -rf $SPCDIR
	[ -d "$SPCCONF" ] && sudo rm -rf $SPCCONF
	# install spicetify package
		# fetch & download spicetify v2.9.9
		local URL='https://github.com/spicetify/spicetify-cli/releases/download/v2.9.9/spicetify-2.9.9-linux-amd64.tar.gz'
		wget --directory-prefix="$DOWNDIR" $URL
		# create spicetify directory
		sudo mkdir -p $SPCDIR
		# extract spicetify archive, and remove it after extracted
		SPCFILE="$DOWNDIR/${URL##*/}"
		sudo tar -xf $SPCFILE -C $SPCDIR && rm -f $SPCFILE
	# set spicetify permissions recursively
	sudo chmod a+rwx -R $SPCDIR
	# add spicetify directory to $PATH variable (if not listed)
	SPCCHECK=$(echo $PATH | grep -o "${SPCDIR##*/}")
	[ -z "$SPCCHECK" ] && { [ -f ~/.bash_profile ] || [ -f ~/.bash_login ]; } || { echo 'export PATH="$PATH:$SPCDIR"' >>  }
	# set executable permissions & run spicetify
	sudo chmod a+x $SPCDIR/spicetify && spicetify
	# spicetify configuration
		# backup spotify
		spicetify backup apply
		# apply theme config
		spicetify config inject_css 1 overwrite_assets 1 replace_colors 1
		# additional config
		spicetify config experimental_features 0 check_spicetify_upgrade 0
		# lyrics
		spicetify config extensions popupLyrics.js
		spicetify config custom_apps lyrics-plus
		# install spicetify marketplace
		curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
		# apply configuration
		spicetify apply
}
