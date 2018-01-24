#!/bin/bash

# Retroswap.sh
#############
# This script lets you switch retroarch config files.
# v4 09.09.2017 by cyperghost and FlashPC
#
# Place this script in /home/pi/RetroPie/retropiemenu/
# In order to run the script you must create the following folders:
#    1. /opt/retropie/configs/all/retroswap
#    2. within that folder create a folder for each system
#       2.1 create there folder "overlay"
#       2.2 create there folder "overlay-real"
#       2.3 create there folder "shader"
#       2.4 create there folder "standard"
#
# full example path for 3DO = /opt/retropie/configs/all/retroswap/3do/overlay
#
# Within each folder you have created place a retroarch.cfg file.
# The file needs to be named the same in each folder.
# Place your current retroarch_shader.cfg in the shader folder. 
# Name the file retroarch.cfg.
#
# Greetings fly out to meleu and TMNTturtleguy
#
# Please respect the work of others

# -- F U N C T I O N S --
modemenu ()
{
local idx=0
local shaderchoice
until [[ "${console[idx]}" == "$1" ]]
    do
       idx=$(( $idx + 1 ))
    done


until [[ "$shaderchoice" == "<--" ]]
    do
        shaderchoice=$(whiptail --backtitle " Console is ${console[idx+1]} " \
        --title " Choose " \
        --nocancel --menu "Choose an option" 0 0 0 \
            "<--" "... back to systemselection" \
            "overlay" "Use Basic Overlay & Scanlines" \
            "overlay-real" "Use Realistic Overlay & Scanlines" \
            "shaders" "Use Shaders...." \
            "standard" "Disable Overlays & Scanlines" \
            2>&1 > /dev/tty)


    case "$shaderchoice" in
        overlay) echo "$1 Overlay" && sleep 2 ;;
        overlay-real) echo "$1 RealOverlay" && sleep 2 ;;
        shaders) echo "$1 shaders" && sleep 2 ;;
        standard) echo "$1 standard" && sleep 2 ;;
    esac
done
}

#-- A R R A Y --
# Feel free to add and edit new console
# TAKE CARE OF UPPER AND LOWER CASE!

console=("3do" "Panasonic 3DO" "atari2600" "Atari 2600" "atari5200" "Atari 5200" "atarijaguar" "Atari Jaguar" "coleco" "ColecoVision" \
         "dreamcast" "Sega Dreamcast" "famicom" "Nintendo Famicom" "intellivision" "IntelliVision" "markiii" "Sega Mark III" \
         "mastersystem" "Sega Master System" "megadrive" "Sega MegaDrive" "segacd" "Sega MegaCD" "n64" "Nintendo 64" \
         "neogeo" "SNK Neo-Geo AES" "nes" "Nintendo Entertainment System" "nintendobsx" "Nintendo Satelliview" \
         "pcengine" "NEC PC-Engine" "pcenginecd" "NEC PC_EnigneCD" "psx" "Sony Playstation" "saturn" "Sega Saturn" \
         "sega32x" "Sega 32X" "sfc" "Nintendo Super Famicom" "snes" "Super Nintendo Entertainment System" "tg16" "TurboGrafx 16" \
         "tg16cd" "TurboGrafx 16CD")

# -- M A I N - L O O P --

while true
    do
        syschoice=$(whiptail --backtitle " Choose " --title " Choose " \
        --nocancel --menu "Select Console" 0 0 0 \
            "<--" "... back to ES" \
            "${console[@]}" \
            "<--" "... back to ES" \
            2>&1 > /dev/tty)

    case "$syschoice" in
        "<--") break ;;
        *) modemenu "$syschoice" ;;
    esac
done
