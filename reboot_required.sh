#!/bin/bash
# by @aeoliam

if [ -f '/var/run/reboot-required' ]; then
	echo -e "─ Reboot required! Reboot now? [Y/n]"
	read reboot_choice
	{ [ "$reboot_choice" == "y" ] || [ "$reboot_choice" == "Y" ]; } && sudo reboot -f
fi
