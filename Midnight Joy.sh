#!/bin/bash
# Small script tp call Midnight Commander with Joy2Key
#
# Config: DPAD = Arrows; A = Enter; B = F10; X = Spacee; Y = F9
# Arrows move curosor, Enter operates as executive key
# F10 quits menus and quits MC, F9 navigates to PD-menu
# Space selects dialog boxes and marks files
#
# I make some default installs without overwrting excisting ones
# skin dark, disable command prompt, confirm exit, confirm exe
#
# by cyperghost
# for https://retropie.org.uk/

# --------- FUNC ---------
function first_start {
    touch "conf_ready"
    echo -e "[panel]\nMark = insert; ctrl-t; space" > mc.keymap
    echo -e "[Midnight-Commander]\nconfirm_exit=1\nconfirm_execute=1\nskin=dark\nuse_internal_edit=1" > ini
    echo -e "[Layout]\nmessage_visible=0\ncommand_prompt=0" >> ini
    echo "Please Restart script!"; sleep 5
}

# --------- PREP ---------
sudo pkill -f joy2key # kill old instance
sleep 0.5 #Debouncing

# --------- INIT ---------
readonly MC_CONFDIR="$HOME/.config/mc.midnightjoy"
readonly MC_CONFSTD="$HOME/.config/mc"
readonly JOY2KEY_SCRIPTLOC="$HOME/RetroPie-Setup/scriptmodules/helpers.sh"
readonly CONFIG=(kcub1 kcuf1 kcuu1 kcud1 0x0a kf10 0x20 kf9)

# --------- JOYS ---------
# Import from RetroPie setup, uses joy2keyStart and joy2keyStop
# scriptdir is  used by joy2key
if [[ -f $JOY2KEY_SCRIPTLOC ]]; then
    source "$JOY2KEY_SCRIPTLOC"
    scriptdir="$HOME/RetroPie-Setup"
    joy2keyStart ${CONFIG[@]}
else
    echo "Can't import Joy2Key Script! Error!"
    echo "Script not found in: $JOY2KEY_SCRIPTLOC"
    sleep 5; exit 0
fi

# ------- PROC -------
if [[ -f $MC_CONFSTD/conf_ready ]]; then
    mc
elif [[ -f $MC_CONFDIR/.config.mc/conf_ready ]]; then
    MC_HOME="$MC_CONFDIR" mc
elif [[ ! -d $MC_CONFDIR && ! -d $MC_CONFSTD ]]; then
    mkdir -p $MC_CONFSTD; cd $MC_CONFSTD
    first_start
elif [[ ! -d $MC_CONFDIR && -d $MC_CONFSTD ]]; then
    mkdir -p "$MC_CONFDIR/.config/mc"; cd "$MC_CONFDIR/.config/mc"
    first_start
else
    echo "Error! Can not acess config data!"
fi
joy2keyStop
