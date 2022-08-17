#!/bin/bash
# by @aeoliam

read_prop() { cat "$2" | sed -n "s/^${1}=//p" | sed 's/"//g' | sed "s/'//g"; }
write_prop() { awk -v var="^${1}=" -v val="${1}=${2}" '{ if ($0 ~ var) print val; else print $0; }' "$3" > "${3}.tmp"; mv -f "${3}.tmp" "$3" 2>/dev/null; cat "$3" | grep "^${1}="; }

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
