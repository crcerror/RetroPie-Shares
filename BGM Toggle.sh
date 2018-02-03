#!/bin/bash 
#Toggle MPG123 Music Player to mute/unmute condition
#Simple by checking running PID and sent -STOP or -CONT term
#Is no PID of MPG123 is available it will be launched

command="mpg123"

pids="$(pgrep "$command")"

if [ -z "$pids" ]; then
    "$command" -Z /media/usb0/BGM/*.mp3 > /dev/null 2>&1 &
    exit 0
fi

for pid in $pids; do
    state="$( ps -ostate= -p "$pid" )"
    stopped=0

    case "$state" in
        *T*)    stopped=1 ;;
    esac

    if (( stopped )); then
        kill -s CONT "$pid" > /dev/null 2>&1
    else
        kill -s STOP "$pid" > /dev/null 2>&1
    fi
done
