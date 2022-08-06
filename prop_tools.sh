#!/bin/bash

##################################################
# read properties
### references: Magisk's util_functions.sh
##### + https://gist.github.com/marcelbirkner/9b133f800d7d3fc5d828
# usage: read_prop VAR /path/to/file
### example: read_prop ID /etc/os-release
read_prop() {
    cat $2 | sed -n "s/^$1=//p" | sed 's/"//g'
}
##################################################


##################################################
# write properties
### references: https://gist.github.com/kongchen/6748525
# usage: write_prop VAR VALUE /path/to/file
### example: write_prop VERSIOM 22.04 /project/package.prop
##################################################
write_prop() {
    awk -v var="^$1=" -v val="$1=$2" '{ if ($0 ~ var) print val; else print $0; }' $3 > $3.tmp
    mv -f $3.tmp $3 2>/dev/null
}
##################################################
