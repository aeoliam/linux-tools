#!/bin/bash
# by @aeoliam

##################################################
# FUNCTIONS
##################################################

ui_print()
{
	case "$2" in
		-p) printf "${1}\n" | output "$3" ;;
		-pa) printf "\n\n${1}\n" | output "$3" -a ;;
		*) printf "\n\n${1}\n"; sleep 3 ;;
	esac
}

output()
{
	case "$2" in
		-a) sudo tee -a "$1" &>/dev/null ;;
		*) sudo tee "$1" &>/dev/null ;;
	esac
}

abort()
{
	ui_print "$1"
	return 1
}

get_latest_release()
{
	local tag=$(curl -s "https://api.github.com/repos/${2}/releases/latest" | grep 'tag_name' | sed 's/"//g' | sed 's/tag_name: //p')
	local tag=${tag%%,*}
	[ -n "$tag" ] || {
		local tag=$(curl -LsH 'Accept: application/json' https://github.com/${2}/releases/latest)
		local tag=${tag%\"\,\"update_url*}
		local tag=${tag#*tag_name\":\"}; }
	[ -z "$tag" ] || printf "$tag"
}

dext()
{
	local downdir="${HOME}/Downloads"
	local downfile="${downdir}/${1##*/}"
	rm -fr "$downfile" 2>/dev/null
	wget --directory-prefix="$downdir" "$1"; wait
	mkdir -p "$2"
	printf "$1" | grep -o '.zip' && unzip -qjo "$downfile" -d "$2"
	printf "$1" | egrep -o '.tar.|.tb2|.tbz|.tbz2|.tz2|.taz|.tgz|.tlz|.txz|.tZ|.taZ|.tzst' && tar -xf "$downfile" -C "$2"
	rm -fr "$downfile" 2>/dev/null
	sudo chown 1000 "$2" -R
	sudo chgrp 1000 "$2" -R
	sudo chmod a+rw "$2" -R
	wait
}

##################################################
# SETUP DEPENDENCIES
##################################################

# install dependencies
command -v 'curl' >/dev/null || { ui_print "[curl] isn't installed!"; sudo apt -y update && sudo apt -y install 'curl'; }
command -v 'wget' >/dev/null || { ui_print "[grep] isn't installed!"; sudo apt -y update && sudo apt -y install 'wget'; }
command -v 'tar' >/dev/null || { ui_print "[tar] isn't installed!"; sudo apt -y update && sudo apt -y install 'tar'; }
command -v 'unzip' >/dev/null || { ui_print "[unzip] isn't installed!"; sudo apt -y update && sudo apt -y install 'unzip'; }

wait

##################################################
# INSTALL SPOTIFY
##################################################

sp_dir='/usr/share/spotify'
sp_conf="${HOME}/.config/spotify"
sp_prefs="${sp_conf}/prefs"

# remove previously installed spotify (avoid spicetify unable to backup spotify)
command -v 'spotify' >/dev/null && sudo apt -y update && sudo apt-get -y purge --auto-remove 'spotify-client'
[ -d "$sp_conf" ] && sudo rm -rf "$sp_conf"

wait

# add spotify pubkey to apt
curl -sS 'https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg' | gpg --dearmor | output '/etc/apt/trusted.gpg.d/spotify.gpg'
# add spotify repository to apt sources
ui_print "deb http://repository.spotify.com stable non-free" -p '/etc/apt/sources.list.d/spotify.list'
# finally install spotify-client
sudo apt -y update && sudo apt -y install 'spotify-client'

wait

# create spotify (linked) shortcut (if not exist)
if [ ! -f "/usr/share/applications/spotify.desktop" ]; then
	sudo ln -s '/usr/share/spotify/spotify.desktop /usrshare/applications/'
	# refresh xfce panel
	[ -z "$(command -v 'xfce4-panel')" ] || xfce4-panel -r
fi

# set spotify permissions recursively
sudo chmod a+rw "$sp_dir" -R

wait

# generate config
ui_print "Spotify will be opened automatically to generate config.\nPlease close it immediately!\n"
spotify &>/dev/null

wait

##################################################
# INSTALL SPICETIFY
##################################################

spc_dir="${HOME}/.spicetify"
spc_conf="${HOME}/.config/spicetify"

# remove previously installed spicetify (if installed)
[ -d "$spc_dir" ] && sudo rm -rf "$spc_dir" 2>/dev/null
[ -d "$spc_conf" ] && sudo rm -rf "$spc_conf" 2>/dev/null

# create spicetify directory
mkdir -p "$spc_dir"

wait

##############################
# auto-detect spicetify version
##############################

# check platform
platform=$(uname -sm)
case $platform in
	"Darwin x86_64") platform='darwin-amd64' ;;
	"Darwin arm64") platform='darwin-arm64' ;;
	"Linux x86_64") platform='linux-amd64' ;;
	"Linux aarch64") platform='linux-arm64' ;;
	*) abort "Unsupported platform ${platform}. Only avaible for x86_64 and arm64 binaries for Linux and Darwin." ;;
esac

# check spotify version
sp_ver=$(cat "${sp_conf}/prefs" | sed -n 's/^app.last-launched-version=//p' | sed 's/"//g')
#sp_ver=$(spotify --version)
sp_ver=${sp_ver#*.*.}; sp_ver=${sp_ver%.*.*}

	# use spicetify v2.9.9 if spotify version is v1.1.84
if [ "$sp_ver" == "84" ]; then
	tag='v2.9.9'
	# use spicetify v2.9.9 if spotify version earlier than v1.1.84
elif [ "$sp_ver" -lt "84" ]; then
	tag='v2.9.5'
else
	# use latest spicetify version if spotify version newer than v1.1.84
	tag=$(get_latest_release spicetify/spicetify-cli)
fi

spc_url="https://github.com/spicetify/spicetify-cli/releases/download/${tag}/spicetify-${tag#v}-${platform}.tar.gz"

##############################
# download spicetify
##############################

# download spicetify
dext "$spc_url" "$spc_dir"

# download spicetify marketplace
dext 'https://github.com/spicetify/spicetify-marketplace/archive/refs/heads/dist.zip' "${spc_conf}/CustomApps/marketplace"

##############################
# add spicetify to $PATH
##############################

case $SHELL in
	*bash) 
		[ -f ~/.bashrc ] && shell_rc='.bashrc'
		[ -f ~/.bash_profile ] && shell_rc='.bash_profile'
	;;
	*csh) 
		[ -f ~/.login ] && shell_rc='.login'
		[ -f ~/.cshrc ] && shell_rc='.cshrc'
	;;
	*ksh) shell_rc='.profile' ;;
	*zsh) shell_rc='.zshrc' ;;
	*) [ -f ~/.bash_profile ] || shell_rc='.profile';;
esac
shell_rc="${HOME}/${shell_rc}"

cat "$shell_rc" | grep -o "${spc_dir##*/}" && cat "$shell_rc" | grep -v "${spc_dir##*/}" | output "${shell_rc}"
ui_print "export PATH=\"\$PATH:${spc_dir}\"" -pa "$shell_rc"
ui_print "export spc_c_INSTALL=\"${spc_dir}\"" -pa "$shell_rc"

##################################################
# SPICETIFY CONFIGURATION
##################################################

spicetify=~/.spicetify/spicetify
chmod a+x $spicetify

# run spicetify
$spicetify

# backup spotify
$spicetify restore
$spicetify backup

# apply theme config
$spicetify config inject_css 1 overwrite_assets 1 replace_colors 1

# additional config
$spicetify config experimental_features 0 check_spicetify_upgrade 0

# lyrics integration
$spicetify config extensions popupLyrics.js
$spicetify config custom_apps lyrics-plus

# spicetify marketplace
$spicetify config custom_apps marketplace

# apply configuration
$spicetify apply

ui_print "Restart your terminal if you want to run spicetify commands."

##################################################
# END OF SCRIPT
##################################################