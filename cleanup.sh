#!/bin/bash

clean_up() {
	sudo apt -y update
	sudo apt -y upgrade
	sudo apt -y full-upgrade
	sudo apt-get -y dist-upgrade
	sudo apt-get -y clean
	sudo apt-get -y autoclean
	sudo apt -y autoremove
}

clean_up
