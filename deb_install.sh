#!/bin/sh

BASEDIR=${0%/*}
cd $BASEDIR
DEBLIST=$(ls -A | grep -i '.deb')
[ ! -z "$DEBLIST" ] || echo -e "\n─── .deb file not found!\n─ Please put this script in the same directory as the .deb file located." && exit 1

install_deb() {
	sudo apt -y update
	for DEBPKG in $DEBLIST; do
		sudo apt -y install ./$DEBPKG || sudo dpkg -i $DEBPKG 
	done
}

uninstall_deb() {
	sudo apt -y update
	for DEBPKG in $DEBLIST; do
		sudo apt -y autoremove --purge ./$DEBPKG || sudo apt -y autoremove --purge $DEBPKG
	done
}

clean_up() {
    local CLEANUP="
	update
	upgrade
	autoremove
	purge
	autoclean
	"
	for TARGET in $CLEANUP; do
        sudo apt -y $TARGET
    done
}

SCRIPT=${0##*/}
CHECK=$(echo "$SCRIPT" | egrep -io 'install|uninstall')
if [ ! -z "$CHECK" ]; then
	[ "$CHECK" == "install" ] && install_deb
	[ "$CHECK" == "uninstall" ] && uninstall_deb
	clean_up
else
	echo -e "─ Please specify the script name wether to install or uninstall the package." && sleep 1
	echo -e "─ Example: [aeoliam_install.sh] and/or [aeoliam_uninstall.sh]" && sleep 2
	echo -e "─── Installation failed!"
	exit 1
fi
