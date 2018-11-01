#!/bin/bash

# A script to fade ALSA volume when starting or ending
# a Emulator by using amixer and MASTER/PCM Control.
# kill -19 pauses musicplayer, kill -18 continues musicplayer
# Place the script in runcommand-onstart.sh to fade-out
# Place the script in runcommand-onend.sh to fade-in
# Status of musicplayer is determinated automatically
#
# by cyperghost
# 2018/10/31 - Halloween

# Reason I like the pyscript for BGM but it has it flaws and caveeats
# so I recommend the mpg123 method brought by synack
# Read here how to setup https://retropie.org.uk/forum/topic/9133

# Setup Musicplayer and Channel you want to change volume here
readonly VOLUMECHANNEL="PCM"
readonly MUSICPLAYER="mpg123"

# Get ALSA volume value and calculate step
VOLUMEALSA=$(amixer -M get $VOLUMECHANNEL | grep -o "...%]")
VOLUMEALSA=${VOLUMEALSA//[^[:alnum:].]/}
VOLUMESTEP=$(echo "scale=1; $VOLUMEALSA/20" | bc -l) # Volume with float
#VOLUMESTEP=$(($VOLUMEALSA/20)) # Old version this will calculate only integer

# ALSA-Commands
VOLUMEZERO="amixer -q -M set $VOLUMECHANNEL 0%"
VOLUMERESET="amixer -q -M set $VOLUMECHANNEL $VOLUMEALSA%"

# Player-Status
PLAYERPID="$(pidof $MUSICPLAYER)"
PLAYERSTATUS=$(ps -ostate= -p $PLAYERPID)

if [[ $PLAYERSTATUS == *S* ]]; then
    # Fading down and pausing in twenty steps
    for a in {0..19}; do
        amixer -q -M set "$VOLUMECHANNEL" "${VOLUMESTEP}%-"
        sleep 0.1
    done

    $VOLUMEZERO
    kill -19 $PLAYERPID
    sleep 0.5
    $VOLUMERESET

elif [[ $PLAYERSTATUS == *T* ]]; then
    # Playing and fading up in ten steps
    $VOLUMEZERO
    sleep 0.5
    kill -18 $PLAYERPID
    for a in {0..19}; do
        [[ $a -lt 13 ]] && sleep 0.1
        [[ $a -gt 12 ]] && sleep 0.25
        amixer -q -M set "$VOLUMECHANNEL" "${VOLUMESTEP}%+"
    done
    $VOLUMERESET
else
    echo "Musicplayer: $MUSICPLAYER is not running."
fi
