#!/bin/bash
# by @aeoliam
##################################################
# read properties
### references: https://askubuntu.com/questions/919185/how-do-i-close-a-program-from-the-terminal
# usage: kill_program "PROGRAM_NAME"
### example: kill_program 'spotify'
kill_program() { pkill "$1" || pgrep -o "$1" | while read $PID; do kill $PID; done; }
##################################################