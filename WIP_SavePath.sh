#!/bin/bash
# Save Path v1.0
# Change SavePath of SRM and STATE-files
# 29.01.2018
#
# by cyperghost for retropie.org.uk
#
# This script is intended to set automatically pathes to SRM and STATE files
# therefore 3 parameters got to be pathed to this
# Parameter 1: all or system > This sets retroarch.cfg system specific or all
# Parameter 2: $1 this is systemused and needed to create SUBDir
# Parameter 3: Base path of ROM Savegames /home/pi/RetroPie/savesgames
#
# I don't differ between SRM and STATE-path (maybe later I can implent this)
# so SRM will be in the same location as STATE
#
# Example 1: SavePath.sh all $3 "/home/pi/RetroPie/savegames" with a NES ROM
# results: SRM and STATE savepath '/home/pi/RetroPie/savesgames/nes'
# retroarch.cfg in /opt/retropie/configs/all will be used!
#
# Example 2: SavePath.sh system $3 "home/pi/Retropie/savegames" with a NES ROM
# results: SRM and STATE savepath '/home/pi/RetroPie/savegames/nes'
# but retroatch.cfg in /opt/retropie/configs/nes will be used!
#
# create or uncomment keys for 'savefile_directory = ""' and 
# 'savestate_directory = ""' by your own!
# I don't want to mess up anything with your config!
#

[ -z "$1" ] && echo "SavePath Check: Please parse 'all' or 'system'! Error!" >&2 && exit 1
[ -z "$2" ] && echo "SavePath Check: Please parse system parameter! Error!" >&2 && exit 1
[ -z "$3" ] && echo "SavePath Check: Please parse full path for save location!" >&2 && exit 1

    system_write="$1"
    save_path="$3"

    if [ "$system_write" = "all" ]; then
        system="all"
    elif [ "$system_write" = "system" ]; then
        system="$2"
    else
        echo "SavePath Check: Please parse 'all' or 'system'! Error!" >&2 && exit 1
    fi

    config_dir="/opt/retropie/configs/$system"
    config_file="$config_dir/retroarch.cfg"

# Get Config State, if there is an error then exit
func_get_config() {
    config="$(grep -Po "(?<=^$1 = ).*" "$config_file")"

    # Check for string config if it's empty then exit
    # else remove quotation marks
    [ -z "$config" ] && echo "SavePath Check: config Key: $1 in $config_file not found! Exit!" >&2 && exit 1
    config="${config%\"}"
    config="${config#\"}"

    # This is tricky!
    # The ~ is a shortage to the HOME directory
    # RetroPie is used to save the home dir as '~/RetroPie...'
    # So I check for presence, remove it and expand it again
    [ "${config:0:1}" = "~" ] && config="${config#??}" && config=~/"$config"
}

# Write to config
func_set_config() {
    sed -i "s|^\($1\s*=\s*\).*|\1\"$2\"|" "$config_file"
#    echo "\"$1\" set to \"$2\"."
}


# ---------------------------  M  A  I  N  ---------------------------

    [ -z "${save_path##*/}" ] && save_path="${save_path%?}"     # Remove last / character from pathes
    [ "${save_path:0:1}" = "/" ] && save_path="$save_path/$system" || exit 1

    func_get_config "savefile_directory"
        if [ "$config" != "$save_path" ]; then
            func_set_config "savefile_directory" "$save_path"
            mkdir -p "$save_path"
        fi

    func_get_config "savestate_directory"
        if [ "$config" != "$save_path" ]; then
            func_set_config "savestate_directory" "$save_path"
            mkdir -p "$save_path"
        fi