#!/bin/bash
#This changes track by killing musicplayer mpg123
#and reloading it

pkill mpg123 > /dev/null 2>&1
sleep 1
mpg123 -Z /media/usb0/BGM/*.mp3 > /dev/null 2>&1 &
