#!/bin/bash

echo "Input shutdown timer. (in seconds)"
read shutdown_time
total_time=$(seq 1 $shutdown_time)
for countdown in $total_time; do echo -en "[${countdown}]\r" && sleep 1; done
xfce4-session-logout --halt --fast
