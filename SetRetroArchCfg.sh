!/bin/bash
# This will just check and write some value to RetroArch.cfg
# Usage of Parameters
# 1. Parameter is for system
# 2. Is for key value in RetroArch.cfg
# 3. Is for key value readout, if this value is in your config setted now
# 4. Is for key value write

# So we check for for setted and config and write if it was found
# You can disable this check if you write "USETHEFORCE" as parameter

# Get and check parameters
system="$1"
key="$2"
value_get="$3"
value_set="$4"

[ -z "$1" ] && echo "SetRetroArchCfg: Wrong parameters setted - set a system" >&2 && exit 1
[ -z "$2" ] && echo "SetRetroArchCfg: Wrong parameters setted - set a key to search for" >&2 && exit 1
[ -z "$3" ] && echo "SetRetroArchCfg: Wrong parameters setted - set a key value to check" >&2 && exit 1
[ -z "$4" ] && echo "SetRetroArchCfg: Wrong parameters setted - set a key value to write" >&2 && exit 1

# Path to RetroArch.cfg
config_dir="/opt/retropie/configs/$system"
config_file="$config_dir/retroarch.cfg"


# This is part of hiulits Boilder Script!
# Thank you!
# USAGE:
# set_config "[KEY]" "[VALUE]" - Sets the VALUE to the KEY in $SCRIPT_CFG.
# get_config "[KEY]" - Returns the KEY's VALUE in $SCRIPT_CFG.

function set_config() {
    sed -i "s|^\($1\s*=\s*\).*|\1\"$2\"|" "$config_file"
    echo "\"$1\" set to \"$2\"."
}

function get_config() {
    config="$(grep -Po "(?<=^$1 = ).*" "$config_file")"
    config="${config%\"}"
    config="${config#\"}"
}

[ "$value_get" = "USETHEFORCE" ] && force=1

# ReadOut and check
get_config "$key"
if [ "$value_get" = "$config" ] || [ $force ]; then
    set_config "$key" "$value_set"
fi
