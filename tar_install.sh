#!/bin/bash

load_print() { echo -ne "$1\r"; sleep 0.1; }
loading_ui() {
    load_print " ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ (0%)   "
    load_print " ● ○ ○ ○ ○ ○ ○ ○ ○ ○ (7%)   "
    load_print " ● ● ○ ○ ○ ○ ○ ○ ○ ○ (20%)  "
    load_print " ● ● ● ○ ○ ○ ○ ○ ○ ○ (33%)  "
    load_print " ● ● ● ● ○ ○ ○ ○ ○ ○ (45%)  "
    load_print " ● ● ● ● ● ○ ○ ○ ○ ○ (58%)  "
    load_print " ● ● ● ● ● ● ○ ○ ○ ○ (62%)  "
    load_print " ● ● ● ● ● ● ● ○ ○ ○ (79%)  "
    load_print " ● ● ● ● ● ● ● ● ○ ○ (84%)  "
    load_print " ● ● ● ● ● ● ● ● ● ○ (91%)  "
    load_print " ● ● ● ● ● ● ● ● ● ● (100%) "
}

BASEDIR=${0%/*}
TARLOGS=$BASEDIR/tar_logs.txt
now="$(date +'%Y-%m-%d %r')"
sudo echo -e "# Logs generated at: $now\n" &>$TARLOGS

echo -e "\n────────── TAR Installer\n"; sleep 2

tar_extract() {
    sudo tar -xf $1
    echo -e "\n─ [$1] Extracted!\n" >>$TARLOGS
}

tar_install() {
    sudo ./$1/configure
    sudo make
    sudo make install
    echo -e "\n─ [$1] Installed!\n"
}

TARFORMAT='.tar.|.tb2|.tbz|.tbz2|.tz2|.taz|.tgz|.tlz|.txz|.tZ|.taZ|.tzst'
FILELIST=$(ls -A | egrep -i "$TARFORMAT" | sort)
if [ ! -z "$FILELIST" ]; then
    for TARFILE in $FILELIST; do
        # extract the tar file
        echo -e "─ [$TARFILE] Extracting..           "
        TAREXT=`tar_extract "$TARFILE" >>$TARLOGS 2>&1`
        wait $TAREXT && loading_ui
        echo -ne "─ [$TARFILE] Extracted ✔          \n" && sleep 2
        # install the tar file
        TARDIR=$(echo -n ${TARFILE%.*} | sed 's/.tar//g')
        if [ -f "$TARDIR/configure" ]; then
            echo "─ [$TARDIR] Installing.."
            TARINS=`tar_install "$TARDIR" >>$TARLOGS 2>&1`
            wait $TARINS && loading_ui
            echo -e "─ [$TARFILE] Installed ✔          \n" && sleep 2
        else
            echo -e "─ [$TARFILE] Has no configuration file!\n" >>$TARLOGS
            echo -e "─ [$TARFILE] Cannot be installed, please install it manually!\n"
        fi
        # remove leftover files after installation
        rm -rf $TARDIR
    done
    sleep 2
    echo "────────── Logs can be found at: $TARLOGS"
else
    echo "────────── TAR file not found."
fi
