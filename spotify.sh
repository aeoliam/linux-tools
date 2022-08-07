#!/bin/bash

##################################################
# SETUP
##################################################

# setup dependencies
command -v 'curl' >/dev/null || { echo -e "\n[curl] isn't installed!\n"; sudo apt -y update && sudo apt -y install 'curl'; }
command -v 'wget' >/dev/null || { echo -e "\n[grep] isn't installed!\n"; sudo apt -y update && sudo apt -y install 'wget'; }
command -v 'tar' >/dev/null || { echo -e "\n[tar] isn't installed!\n"; sudo apt -y update && sudo apt -y install 'tar'; }
command -v 'unzip' >/dev/null || { echo -e "\n[unzip] isn't installed!\n"; sudo apt -y update && sudo apt -y install 'unzip'; }

##################################################
# INSTALL SPOTIFY
##################################################

SPOTIFY=$(command -v 'spotify')

sp_dir='/usr/share/spotify'
sp_conf="${HOME}/.config/spotify" || sp_conf='~/.config/spotify'
sp_prefs="${sp_conf}/prefs"

# remove previously installed spotify (avoid spicetify unable to backup spotify)
if [ -n "$SPOTIFY" ]; then
	sudo apt -y update && sudo apt-get -y purge --auto-remove 'spotify-client'
	[ -d "$sp_conf" ] && sudo rm -rf "$sp_conf"
	# sleep to make sure commands are executed properly
	sleep 3
fi

# add spotify pubkey to apt
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
# add spotify repository to apt sources
sudo echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.dspotify.list
# finally install spotify-client
sudo apt -y update && sudo apt -y install 'spotify-client'
# sleep to make sure commands are executed properly
sleep 3

# create spotify (linked) shortcut (if not exist)
if [ ! -f "/usr/share/applications/spotify.desktop" ]; then
	sudo ln -s /usr/share/spotify/spotify.desktop /usrshare/applications/
	# refresh xfce panel
	[ -z "$(command -v 'xfce4-panel')" ] || xfce4-panel -r
fi

# set spotify permissions recursively
sudo chmod a+rw -R "$sp_dir"

# sleep to make sure commands are executed properly
sleep 3

##################################################
# INSTALL SPICETIFY
##################################################

SPICETIFY=$(command -v 'spicetify')

spc_dir="${HOME}/.spicetify" || spc_dir='~/.spicetify'
spc_exe="${spc_dir}/spicetify"
spc_conf="${HOME}/.config/spicetify" || spc_conf='~/.config/spicetify'

# remove previously installed spicetify (if installed)
[ -z "$SPICETIFY" ] || spicetify restore
[ -d "$spc_dir" ] && sudo rm -rf "$spc_dir"
[ -d "$spc_conf" ] && sudo rm -rf "$spc_conf"

# check platform
case $(uname -sm) in
	"Darwin x86_64") target='darwin-amd64' ;;
	"Darwin arm64") target='darwin-arm64' ;;
	"Linux x86_64") target='linux-amd64' ;;
	"Linux aarch64") target='linux-arm64' ;;
	*) echo "Unsupported platform $(uname -sm). Only avaible for x86_64 and arm64 binaries for Linux and Darwin."; exit 1 ;;
esac

##############################
# fetch and download spicetify
##############################

# check spotify version
sp_ver=$(spotify --version)
sp_ver=${sp_version%.*.*}
sp_ver=${sp_version#*.*.}

releases_url='https://github.com/spicetify/spicetify-cli/releases'

# use latest spicetify version if spotify version newer than v1.1.84
[ "$sp_ver" -gt "84" ] && {
    tag=$(curl -LsH 'Accept: application/json' ${releases_url}/latest)
    tag=${tag%\"\,\"update_url*}
    tag=${tag#*tag_name\":\"}
}
# use spicetify v2.9.9 if spotify version is v1.1.84
[ "$sp_ver" == "84" ] && tag='v2.9.9'
# use spicetify v2.9.9 if spotify version earlier than v1.1.84
[ "$sp_ver" -lt "84" ] && tag='v2.9.5'

download_url="${releases_url}/download/${tag}/spicetify-${tag#v}-${target}.tar.gz"
download_dir="${HOME}/Downloads" || download_dir='~/Downloads'

# downloaded file
download_output="${download_dir}/${download_url##*/}"

# download file (if not already downloaded) & set it executable
[ -f "$download_output" ] || wget --directory-prefix="$download_dir" $download_url

# sleep to make sure commands are executed properly
sleep 3

# create spicetify directory
mkdir -p "$spc_dir"

# extract spicetify archive, and remove it after extracted
sudo tar -zxf "$download_output" -C "$spc_dir" && rm -f "$download_output"

# set spicetify permissions recursively
chmod a+rwx -R "$spc_dir"

##############################
# add spicetify to $PATH
##############################

case $SHELL in
	*bash) 
		[ -f "${HOME}/.bashrc" ] && shell_rc='.bashrc'
		[ -f "${HOME}/.bash_profile" ] && shell_rc='.bash_profile'
	;;
	*csh) 
		[ -f "${HOME}/.cshrc" ] && shell_rc='.cshrc'
		[ -f "${HOME}/.login" ] && shell_rc='.login'
	;;
	*ksh) shell_rc='.profile' ;;
	*zsh) shell_rc='.zshrc' ;;
	*) [ -f "${HOME}/.bash_profile" ] || shell_rc='.profile';;
esac

shell_rc="${HOME}/${shell_rc}"
grep -v "${spc_dir##*/}" "$shell_rc" > ${shell_rc}.tmp && mv -f "${shell_rc}.tmp" "$shell_rc"
echo -e "\nexport PATH="\$PATH:${spc_dir}"" >> $shell_rc && { source "$shell_rc" || . "$shell_rc"; }
echo -e "\nexport SPICETIFY_INSTALL="${spc_dir}"" >> $shell_rc && { source "$shell_rc" || . "$shell_rc"; }

# set executable permissions
chmod a+x "$spc_exe"

# run spicetify
spicetify || . $spc_exe

# sleep to make sure commands are executed properly
sleep 3

##################################################
# SPICETIFY CONFIGURATION
##################################################

# backup spotify
spicetify backup apply || . $spc_exe backup apply

# apply theme config
spicetify config inject_css 1 overwrite_assets 1 replace_colors 1 || . $spc_exe config inject_css 1 overwrite_assets 1 replace_colors 1

# additional config
spicetify config experimental_features 0 check_spicetify_upgrade 0 || . $spc_exe config experimental_features 0 check_spicetify_upgrade 0

# lyrics integration
spicetify config extensions popupLyrics.js || . $spc_exe config extensions popupLyrics.js
spicetify config custom_apps lyrics-plus || . $spc_exe config custom_apps lyrics-plus

# install spicetify marketplace
curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh

# apply configuration
spicetify apply || . $spc_exe apply

# sleep to make sure commands are executed properly
sleep 3

##################################################
# END OF SCRIPT
##################################################