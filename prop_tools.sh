#!/bin/bash

##################################################
# read properties
### references: Magisk's util_functions.sh
##### + https://gist.github.com/marcelbirkner/9b133f800d7d3fc5d828
# usage: read_prop VAR /path/to/file
### example: read_prop ID /etc/os-release
read_prop() {
	cat "$2" | sed -n "s/^${1}=//p" | sed 's/"//g' | sed "s/'//g"
}
##################################################


##################################################
# write properties
### references: https://gist.github.com/kongchen/6748525
# usage: write_prop VAR VALUE /path/to/file
### example: write_prop VERSIOM 22.04 /project/package.prop
##################################################
write_prop() {
	awk -v var="^${1}=" -v val="${1}=${2}" '{ if ($0 ~ var) print val; else print $0; }' "$3" > "${3}.tmp"
	mv -f "${3}.tmp" "$3" 2>/dev/null
	cat "$3" | grep "^${1}="
}
##################################################

echo "What do you want?"
echo "[r]ead prop"
echo "[w]rite prop"
read choice

if [ "$choice" == "r" ]; then
	echo "input prop name."
	read prop_name
	echo "input file path."
	read file_path
	read_prop "$prop_name" "$file_path"
elif [ "$choice" == "w" ]; then
	echo "input prop name."
	read prop_name
	echo "input prop value."
	read prop_value
	echo "input file path."
	read file_path
	write_prop "$prop_name" "$prop_value" "$file_path"
else
	echo "Please choose one of the options above!"
	exit 1
fi
